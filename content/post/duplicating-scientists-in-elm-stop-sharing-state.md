---
date: "2016-07-11T08:00:00-05:00"
title: "Duplicating Scientists in Elm: Stop Sharing State"
tags: ["elm"]

---

When you're building an app with Elm, you'll find a common problem: where do you
put shared state in models? Let's take selecting an item for viewing as an
example. You'll start out having a model field with a selected item and one with
a collection. But that's duplication! How do you keep the model state in sync
when one side has to change?

<!--more-->

## What's Going On Now

The chief science biographer has come to us with a request: we want an index of
famous scientists. Each of them has a name and a short biography. To spice
things up we're also going to assign them each a display color.

First we want to render a list of scientists to select from, and select one when
clicked on. Once selected, we'll displaly their name and biography. We've
modeled this behavior with a `selected` field on `Model`. We might have nothing
selected so it's a `Maybe`, specifically a `Maybe Scientist`.

```elm
type alias Scientist =
    { name : String
    , bio : String
    , color : Color
    }


type alias Model =
    { scientists : Dict String Scientist
    , selected : Maybe Scientist
    }
```

What would our update function look like? We'll just need to handle `Select` at
this point. This should plug a `Scientist` into `model.selected`.

```elm
type Msg
    = Select String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Select who ->
            case Dict.get who model.scientists of
                Nothing ->
                    model

                scientist ->
                    { model | selected = scientist }
```

Everything's looking good so far! We can select scientists and click around to
see them all.

{{< figure src="/images/elm-scientists/initial.png" alt="mockup of our application, showing a list of scientists. Radia Perlman, the inventor of the spanning-tree protocol, is selected." >}}

## Scientist Chameleons

Now the chief science biographer comes back with a new request: they want to be
able to change colors! Let's model this with a new case on `Msg`:

```elm
type Msg
    = Select String
    | ChangeColor String Color


update : Msg -> Model -> Model
update msg model =
    case msg of
        -- Select who ...

        ChangeColor who color ->
            case Dict.get who model.scientists of
                Nothing ->
                    model

                Just scientist ->
                    { model
                        | scientists =
                            model.scientists
                                |> Dict.insert who { scientist | color = color }
                    }
```

This looks great, but there's a bug. Can you see it?

When we change the color of the selected scientist the color of the list item
changes, but not the color of the selected scientist. We have duplicated the
state, so we'll have to figure out how to get the color into `model.selected`.

{{< figure src="/images/elm-scientists/update.png" alt="mockup showing the change in the list items but not the selected item" >}}

Getting into situations like this can feel pretty frustrating. But think about
it for a little bit; we actually want this behavior! If changing a value in one
place changed it everywhere, we'd have to explicitly copy the values anytime we
wanted to make a change. We'll just have to approach things in a different way.

## May I See Your ID, Please?

The solution is to keep an ID in `model.selected` instead of duplicating state.
We're already keeping scientists by ID in `model.scientists`, so let's just use
that.

```elm
type alias Model =
    { scientists : Dict String Scientist
    , selected : Maybe String
    }
```

This new structure simplifies handling new selections a little bit:

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        Select who ->
            { model | selected = Just who }
```

Our view layer does get a touch more complicated though. When we were rendering
a `Maybe Scientist`, we could just pass it to our view function like so:

```elm
detailView : Maybe Scientist -> Html Msg
detailView s =
    case s of
        Nothing ->
            Html.text "No scientist selected."

        Just scientist ->
            Html.div [ scientist.color |> toCss |> Attr.style ]
                [ Html.h2 [] [ Html.text scientist.name ]
                , Html.p [] [ Html.text scientist.bio ]
                ]
```

In this brave new world where `model.selected` is `Maybe String` instead, how do
we render this? But, as it turns out, going from `Maybe String` to `Maybe
Scientist` is pretty simple. We'll just combine `Maybe.andThen` with `Dict.get`.
Now any components that relied on getting a `Maybe Scientist` will still get
that.

```elm
lookupByID : Maybe comparable -> Dict comparable a -> Maybe a
lookupByID id collection =
    id `Maybe.andThen` (\inner -> Dict.get inner collection)
```

And we'll use it like so:

```elm
view : Model -> Html Msg
view model =
    Html.div []
        [ Html.ul [] (model.scientists |> Dict.values |> List.map itemView)
        , lookupByID model.selected model.scientists
            |> detailView
        ]
```

Everything compiles! When we load up the app again the chief science biographer
can change colors of everything at will. Success!

{{< figure src="/images/elm-scientists/unify.png" alt="mockup showing the change in the list items and the selected item" >}}

It's not all good, though: this approach does come with a caveat. If you set an
id that doesn't correspond to any scientist, you'll have to deal with that. This
is not a *huge* problem since you have to deal with the presence of `Nothing`
anyway. It is worth considering, though.

## Done!

Now you know how to deal with shared state: pass an ID around! When you use this
technique, you won't have to worry about syncing information back and forth.
Next time you need to share, consider using an ID instead. We used a `Dict` in
this example, but a list is also fine. You can also use an incremeting integer
instead of a string for the ID; whatever makes sense for your data model!

FYI: the code for this post
[is available on my Github](https://github.com/BrianHicks/elm-scientists).

{{< elmSignup >}}
