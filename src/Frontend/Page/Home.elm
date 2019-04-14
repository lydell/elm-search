module Frontend.Page.Home exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , toSession
    , update
    , view
    )

import Frontend.Session as Session exposing (Session)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Route


type Model
    = Model
        { session : Session
        , searchInput : String
        }


type Msg
    = EnteredSearchInput String
    | TriggeredSearch


init : Session -> ( Model, Cmd Msg )
init session =
    ( Model
        { session = session
        , searchInput = ""
        }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        EnteredSearchInput query ->
            ( Model { model | searchInput = query }
            , Cmd.none
            )

        TriggeredSearch ->
            ( Model model
            , Route.pushUrl (Session.navKey model.session)
                (Route.Search <| Just model.searchInput)
            )


view : Model -> { title : String, body : Html Msg }
view model =
    { title = "Elm Search"
    , body = viewContent model
    }


viewContent : Model -> Html Msg
viewContent (Model model) =
    Html.div [ Html.Attributes.class "page-home" ]
        [ Html.h1 [] [ Html.text "Elm Search" ]
        , Html.form [ Html.Events.onSubmit TriggeredSearch ]
            [ Html.input
                [ Html.Attributes.placeholder "(a -> b) -> Maybe a -> Maybe b"
                , Html.Attributes.value model.searchInput
                , Html.Events.onInput EnteredSearchInput
                ]
                []
            , Html.p [ Html.Attributes.class "help" ]
                [ Html.text "Search Elm packages by name or approximate type signature." ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


toSession : Model -> Session
toSession (Model { session }) =
    session
