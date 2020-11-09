module Main exposing (..)

import Browser
import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, css, href, src)
import Html.Styled.Events exposing (on, onClick)
import Json.Decode as Decode
import Svg.Styled.Attributes exposing (direction, mode)


main : Program () Model Msg
main =
    Browser.sandbox
        { view = view >> toUnstyled
        , update = update
        , init = init
        }


type alias Product =
    { name : String
    , price : Float
    , emoji : String
    }


type alias Model =
    { products : List Product
    , minicartOpened : Bool
    }


init : Model
init =
    { products = []
    , minicartOpened = False
    }


products : List Product
products =
    [ { name = "Soccer Ball", price = 200.0, emoji = "⚽️" }
    , { name = "Football Ball", price = 300.0, emoji = "🏈" }
    , { name = "Volley Ball", price = 300.0, emoji = "🏐" }
    , { name = "Baseball Ball", price = 300.0, emoji = "⚾️" }
    , { name = "Tennis Ball", price = 300.0, emoji = "🎾" }
    , { name = "Rugby Ball", price = 300.0, emoji = "🏉" }
    , { name = "Snooker Ball", price = 300.0, emoji = "🎱" }
    ]


type Msg
    = Add Product
    | Remove Product
    | ToggleMinicart


update : Msg -> Model -> Model
update msg model =
    case msg of
        Add currentProduct ->
            { model | products = currentProduct :: model.products, minicartOpened = True }

        Remove currentProduct ->
            { model | products = List.filter (\x -> x.name /= currentProduct.name) model.products }

        ToggleMinicart ->
            { model | minicartOpened = not model.minicartOpened }


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled div
        [ color (hex "333")
        , fontFamilies [ "Helvetica" ]
        , width (px 200)
        , color (hex "fff")
        , textAlign center
        , cursor pointer
        , borderRadius (px 5)
        , padding2 (px 15) (px 10)
        , backgroundColor (hex "72a4d4")
        ]


btnrm : List (Attribute msg) -> List (Html msg) -> Html msg
btnrm =
    styled div
        [ color (hex "333")
        , fontFamilies [ "Helvetica" ]
        , width (px 200)
        , color (hex "fff")
        , textAlign center
        , cursor pointer
        , borderRadius (px 5)
        , padding2 (px 3) (px 5)
        , backgroundColor (hex "bf3a3c")
        ]


product : List (Attribute msg) -> List (Html msg) -> Html msg
product =
    styled div
        [ backgroundColor (hex "f6f6f6")
        , border3 (px 1) solid (hex "ccc")
        , height (px 300)
        , width (px 300)
        , borderRadius (px 5)
        , margin (px 15)
        , displayFlex
        , alignItems center
        , flexDirection column
        ]


productList : List (Attribute msg) -> List (Html msg) -> Html msg
productList =
    styled div
        [ displayFlex
        , marginTop (px 50)
        , margin2 (px 0) auto
        , width (pct 95)
        , alignItems center
        , flexWrap wrap
        ]


navbar : List (Attribute msg) -> List (Html msg) -> Html msg
navbar =
    styled nav
        [ height (px 50)
        , fontFamilies [ "Helvetica" ]
        , color (hex "33333")
        , backgroundColor (hex "f6f6f6")
        , displayFlex
        , boxSizing borderBox
        , padding (px 15)
        , alignItems center
        , justifyContent spaceBetween
        ]


emoji : List (Attribute msg) -> List (Html msg) -> Html msg
emoji =
    styled div
        [ fontSize (px 80)
        ]

minicartButton : List (Attribute msg) -> List (Html msg) -> Html msg
minicartButton =
    styled div
        [ cursor pointer
        ]


minicart : List (Attribute msg) -> List (Html msg) -> Html msg
minicart =
    styled div
        [ height (pct 100)
        , width (px 300)
        , position absolute
        , top (px 0)
        , right (px 0)
        , fontFamilies [ "Helvetica" ]
        , color (rgb 250 250 250)
        , backgroundColor (hex "f6f6f6")
        , border3 (px 1) solid (hex "#ccc")
        , displayFlex
        , boxSizing borderBox
        , padding (px 15)
        , flexDirection column
        , color (hex "333")
        ]


wrapper : List (Attribute msg) -> List (Html msg) -> Html msg
wrapper =
    styled div
        [ position absolute
        , top (px 0)
        , bottom (px 0)
        , right (px 0)
        , left (px 0)
        , displayFlex
        , alignItems center
        , justifyContent center
        , backgroundColor (rgba 33 43 54 0.4)
        ]


wrapperClass : String
wrapperClass =
    "wrapper"


wrapperClickDecoder : msg -> Decode.Decoder msg
wrapperClickDecoder closeMsg =
    Decode.at [ "target", "className" ] Decode.string
        |> Decode.andThen
            (\c ->
                if String.contains wrapperClass c then
                    Decode.succeed closeMsg

                else
                    Decode.fail "ignoring"
            )


minicartComponent : Model -> Html Msg
minicartComponent model =
    if model.minicartOpened then
        wrapper [ class wrapperClass, on "click" (wrapperClickDecoder ToggleMinicart) ]
            [ minicart []
                (List.map
                    (\l ->
                        div []
                            [ p [] [ text l.name ]
                            , btnrm [ onClick (Remove l) ] [ text "Remove item" ]
                            ]
                    )
                    model.products
                )
            ]

    else
        text ""


view : Model -> Html Msg
view model =
    div []
        [ navbar []
            [ div [] [ text "Elm shopping" ]
            , minicartButton [ onClick ToggleMinicart] [ text "🛒" ]
            ]
        , productList []
            (List.map
                (\l ->
                    product []
                        [ p [] [ text l.name ]
                        , emoji [] [ text l.emoji ]
                        , p [] [ text ("$ " ++ String.fromFloat l.price) ]
                        , btn [ onClick (Add l) ] [ text "Buy item" ]
                        ]
                )
                products
            )
        , minicartComponent model
        ]
