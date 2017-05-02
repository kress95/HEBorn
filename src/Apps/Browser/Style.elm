module Apps.Browser.Style exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Css.Elements exposing (input, span)
import Css.Utils exposing (transition, easingToString, Easing(..), pseudoContent, selectableText)
import Css.Common exposing (flexContainerVert, flexContainerHorz, internalPadding, internalPaddingSz)
import Css.Icons as Icon


type Classes
    = Window
    | HeaderBar
    | Toolbar
    | AddressBar


css : Stylesheet
css =
    (stylesheet << namespace "browser")
        [ class HeaderBar
            [ flexContainerHorz
            , borderBottom3 (px 1) solid (hex "000")
            ]
        , class Toolbar
            [ flex (int 0)
            , flexContainerHorz
            , lineHeight (px 32)
            ]
        , class AddressBar
            [ children
                [ input
                    [ flex (int 1)
                    , marginLeft (px 18)
                    , padding (px 3)
                    , borderRadius (px 12)
                    , border3 (px 1) solid (hex "000")
                    ]
                ]
            ]
        ]
