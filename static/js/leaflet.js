var app = index.app;

var maps = {};
var address = '//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'

function send(data) {
  app.ports.leafletSub.send(data);
}

function withElement(id, cb) {
  if (document.getElementById(id)) return cb();

  var listener = function () {
    if (!document.getElementById(id)) return;
    document.removeEventListener('DOMNodeInserted', listener);
    cb();
  };

  document.addEventListener('DOMNodeInserted', listener);
}

function init (cmd) {
  var id = cmd.id;

  withElement(id, function () {
    var map = L.map(id, {zoomSnap: 0.25}).setView([-21.1, -45.54568], 16);
    var diff = map.project(map.getCenter(), map.getZoom());
    var projections = {test: L.latLng(map.getCenter().lat, map.getCenter().lng)};
    var moving = false;
    var zooming = false;

    maps[id] = [map, projections];

    map.invalidateSize();
    L.tileLayer(address, {maxZoom: 18}).addTo(map);

    // clicked event
    map.on('click', function onMapClick(e) {
      send({
        'id': id,
        'msg': 'clicked',
        'lat': e.latlng.lat,
        'lng': e.latlng.lng
      });
    });

    // movement
    function onMapMove() {
      if (moving || zooming) {
        var diff2 = map.project(map.getCenter(), map.getZoom());
        var x = diff2.x - diff.x;
        var y = diff2.y - diff.y;

        diff = diff2;

        send({
          'id': id,
          'msg': 'moved',
          'x': diff2.x,
          'y': diff2.y
        });

        Object.keys(projections).forEach(name => {
          if (!projections[name]) return;
          var proj = map.project(projections[name], map.getZoom());

          send({
            'id': id,
            'msg': 'projected',
            'name': name,
            'x': proj.x - diff.x,
            'y': proj.y - diff.y
          });
        });
      }

      window.requestAnimationFrame(onMapMove);
    }

    window.requestAnimationFrame(onMapMove);

    map.on('movestart', function onMoveStart () {
      moving = true;
    });

    map.on('moveend', function onMoveEnd () {
      moving = false;
    });

    map.on('zoomstart', function onZoomStart () {
      zooming = true;
    })

    map.on('zoomend', function onZoomStart () {
      zooming = false;
    })
  });
}

function insertProjection(cmd) {
  var id = cmd.id;
  var name = cmd.name;
  var projections = maps[id] && maps[id][1];
  if (!projections) return;

  projections[name] = L.latLng(cmd.lat, cmd.lng);
}

function removeProjection(cmd) {
  var id = cmd.id;
  var name = cmd.name;
  var projections = maps[id] && maps[id][1];
  if (!projections) return;

  delete projections[name];
}

function center(cmd) {
  var id = cmd.id
  var map = maps[id] && maps[id][0];
  if (!map) return;

  map.invalidateSize();
  map.setView([cmd.lat, cmd.lng], cmd.zoom);
}

app.ports.leafletCmd.subscribe(function leafletCmd(cmd) {
  switch (cmd.msg) {
    case 'init':
      init(cmd);
      break;

    case 'insertProjection':
      insertProjection(cmd);
      break;

    case 'removeProjection':
      removeProjection(cmd);
      break;

    case 'center':
      center(cmd);
      break;

    default:
      console.log(
        'Leaflet communication error: command "'
        + cmd.msg
        + '" does not exist.'
      );
  }
});
