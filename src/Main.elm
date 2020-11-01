module Main exposing (..)

import Browser
import Css exposing (..)
import Html
import Html.Styled.Events exposing (onClick)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src)
import Svg.Styled.Attributes exposing (mode)
import Svg.Styled.Attributes exposing (direction)

main: Program () (List Product) Msg
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

type alias Model = List (Product)

init : List (Product)
init = []
products : List (Product)
products = [
         { name = "Soccer Ball", price = 200.0, emoji = "⚽️"}
       , { name = "Football Ball", price = 300.0, emoji = "🏈"}
       , { name = "Volley Ball", price = 300.0, emoji = "🏐"}
       , { name = "Baseball Ball", price = 300.0, emoji = "⚾️"}
       ]

type Msg =
  Add Product
  | Remove Product
update : Msg -> Model -> Model 
update msg model =
    case msg of
        Add currentProduct ->
            currentProduct :: model

        Remove currentProduct ->
            List.filter (\x -> x /= currentProduct) model


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled div
        [ color (hex "333")
        , fontFamilies ["Helvetica"]
        , width (px 200)
        , color (hex "fff")
        , textAlign center
        , cursor pointer
        , borderRadius (px 5)
        , padding2 (px 5) (px 10)
        , backgroundColor (hex "72a4d4")
        ]
btnrm : List (Attribute msg) -> List (Html msg) -> Html msg
btnrm =
    styled div
        [ color (hex "333")
        , fontFamilies ["Helvetica"]
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
        , width (px 1000)
        , alignItems center
        , flexWrap wrap
        ]



navbar : List (Attribute msg) -> List (Html msg) -> Html msg
navbar =
    styled nav
        [ height (px 50)
        , fontFamilies ["Helvetica"]
        , color (rgb 250 250 250)
        , backgroundColor (hex "333333")
        , displayFlex
        , boxSizing borderBox
        , padding (px 15)
        , alignItems center
        ]

emoji : List (Attribute msg) -> List (Html msg) -> Html msg
emoji =
    styled div
        [ fontSize (px 80)
        ]

minicart : List (Attribute msg) -> List (Html msg) -> Html msg
minicart =
    styled div
        [ height (pct 100)
        , width (px 300)
        , position absolute
        , top (px 0)
        , right (px 0)
        , fontFamilies ["Helvetica"]
        , color (rgb 250 250 250)
        , backgroundColor (hex "f6f6f6")
        , border3 (px 1) solid (hex "#ccc")
        , displayFlex
        , boxSizing borderBox
        , padding (px 15)
        , flexDirection column
        , color (hex "333")
        ]

view : Model -> Html Msg
view model =
  div []
    [navbar []
        [ div [] [ text "Elm shopping" ]]
    , productList []
          (List.map (\l -> 
            product []
              [
                p [] [text l.name]
              , emoji [] [text l.emoji]
              , p [] [text ( String.fromFloat l.price )]
              , btn [onClick (Add l)] [text "comprar"]
              ]
            )
          products)
                -- [onClick (Add l)] [text l.name]) products)
    , minicart []
          (List.map (\l -> 
            div []
              [p [] [text l.name] 
              , btnrm [onClick (Remove l)] [text "Remover"]]
              )
          model)
    ]