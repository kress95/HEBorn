module Setup.Pages.CustomFinish.View exposing (Config, view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Setup.Resources exposing (..)
import Setup.Pages.Helpers exposing (withHeader)


{ id, class, classList } =
    Html.CssHelpers.withNamespace prefix


type alias Config msg =
    { onNext : msg, onPrevious : msg }


view : Config msg -> Html msg
view { onNext, onPrevious } =
    withHeader [ class [ StepWelcome ] ]
        [ h2 [] [ text "Good bye!" ]
        , p []
            [ text "What are you waiting fool? Run, Forrest, run!" ]
        , div []
            [ button
                [ onClick onPrevious
                , class [ PreviousPageButton ]
                ]
                [ text "BACK" ]
            , button
                [ onClick onNext
                , class [ NextPageButton ]
                ]
                [ text "ALRIGHT" ]
            ]
        ]
