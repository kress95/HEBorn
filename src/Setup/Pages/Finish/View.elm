module Setup.Pages.Finish.View exposing (Config, view)

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
            [ text "It was really good, wasn't it?" ]
        , p []
            [ text "Well.. You're ready to leave now." ]
        , p []
            [ text "Maybe you'll find someone else to help you... Maybe Black Mesa!" ]
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
                [ text "FINISH HIM" ]
            ]
        ]
