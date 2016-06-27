---
date: "2016-06-27T14:17:39-05:00"
title: "Candy and Allowances, Part II: Child-Child Communication in Elm"
tags: ["elm"]

---

In our [previous article]({{< ref
"candy-and-allowances-parent-child-communication-in-elm.md" >}}) we talked about
how parents and children can communicate with one another in Elm. But how about
when you need two child components to know about each others state? Hmm&hellip;

<!--more-->

## Our Story So Far

We have two components: a `Parent` and a `Child`. The parent covers spending
money for the children. It can receive a paycheck, and when it does it can hand
out allowance to the children. The children, meanwhile, buy candy with reckless
abandon. The parent takes on the burden of their debt, decreasing their own
resources. Messages are passed down to the child and up to the parent through
`update` functions.

But children do not exist in a vacuum. They can see each other, and they *love*
to brag about how much candy they're getting. What's a little sibling rivalry
between friends?

## Containers

First, let's stop off to talk a bit of design philosophy. Parents manage their
childrens state in the Elm architecture. You will have a tree of records that
can go arbitrarily deep and wide. Yet once the branches of that tree diverge,
they should almost never come back together. Think about how the update function
works: you write it to return the new state of a single component, which
includes any children.

So given how our update function works, how do we pass messages between two
sibling components (that is, components which are the children of a single
container?) We can send messages to the parent, but then we need to defer to the
implementation. The containing component has to own the routing of messages
between its children.

## The Jealous Child

Back to the code now! Let's see how our new model represents our jealous
children:

```elm
type alias Model =
    { money : Float
    , jealousy : Float
    }


init : Model
init =
    { money = 0
    , jealousy = 0
    }


type Msg
    = Allowance Float
    | Candy
    | SeeOthersCandy
    | ShowOffCandy


type OutMsg
    = NeedMoney Float
    | BragAboutCandy
```

We're now representing jealousy on the model. Jealousy increases when children
see others bragging about their candy, and decreases when getting candy. We can
also now intend to show off our candy. Finally, we're representing the need for
money as a tag instead of a float, since we're sending different messages to the
parent.

Let's see how our update function changes as a result:

```elm
update : Msg -> Model -> ( Model, Maybe OutMsg )
update msg model =
    case msg of
        Allowance amount ->
            ( { model | money = model.money + amount }
            , Nothing
            )

        SeeOthersCandy ->
            ( { model | jealousy = model.jealousy + 1 }
            , Nothing
            )

        ShowOffCandy ->
            ( model
            , Just BragAboutCandy
            )

        Candy ->
            let
                money =
                    model.money - 5

                moneyMessage =
                    if money < 0 then
                        Just (NeedMoney (abs money))
                    else
                        Nothing
            in
                ( { model | money = money, jealousy = 0 }
                , moneyMessage
                )
```

Not every case of `Msg` needs to send a message to the parent, so we're
representing the messages to the parent as `Maybe OutMsg` instead of a float. We
can still get allowance, but now we can see other childrens candy. Neither of
these cases need to notify the parent, so we return `Nothing` for the message.

`ShowOffCandy` is more complex, but not terribly bad. When we get it there are
no changes to our model, but we should send the parent a message. So that's
exactly what we do.

`Candy` is the most complex message. Now we're checking to see if we need money
in constructing a message. If we don't need any, no money needed, hooray! That's
`Nothing`. But if we do, we send a message of the absolute value of money
needed, as the `NeedMoney` message.

That about does it for the update function. We're responding and sending a few
more events. Now let's look at how we're getting those new events:

## The Gossipy Parent

We'll have to change `Parent` to broadcast the messages to the right children.
Let's handle the `update` function first:

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        ChildMsg name msg' ->
            case Dict.get name model.children of
                Nothing ->
                    model

                Just child ->
                    let
                        ( updated, childMsg ) =
                            Child.update msg' child

                        ( child', model' ) =
                            updateFromChild childMsg name updated model

                        children =
                            Dict.insert name child' model'.children
                    in
                        { model' | children = children }
```

The thing to notice here is that we've moved our message handling into
`updateFromChild`. Nothing else has changed too much. Here's our handler
function:

```elm
updateFromChild : Maybe Child.OutMsg -> String -> Child.Model -> Model -> ( Child.Model, Model )
updateFromChild msg name child model =
    case msg of
        Nothing ->
            ( child, model )

        Just (Child.NeedMoney amount) ->
            if amount > 0 then
                ( Child.update (Child.Allowance amount) child |> fst
                , { model | money = model.money - amount }
                )
            else
                ( child, model )

        Just Child.BragAboutCandy ->
            let
                showOff =
                    \name' child ->
                        if name' == name then
                            child
                        else
                            Child.update Child.SeeOthersCandy child |> fst
            in
                ( child
                , { model | children = Dict.map showOff model.children })
```

Here we're handling the different cases of `OutMsg`. First when we don't have a
message we return nothing. Easy. If the child needs money, that's the logic that
used to be in `Parent.update`.

The new stuff comes with our broadcast message `Child.BragAboutCandy`. We're
just going to send our children a `SeeOthersCandy` message. We're not, however,
going to send it to the child who wants to show off their candy. That just
wouldn't make sense!

Once we get our new child and parent state from `updateFromChild`, `update` sets
it in the right place in the dictionary and returns as normal.

## Wrappin' it Up

There you have it, broadcast communication from one child to all siblings. If
you need more specific communication, you can pass a set of identifiers down to
the children for use as coordinates. Just like last time this pattern should
scale up just fine, but be cautious of owning too much in the child. Components
are easier to reuse if they're small.

As before, the code for this post is available at
[BrianHicks/candy-and-allowances](https://github.com/BrianHicks/candy-and-allowances)
on Github. The specific commit making these changes is
[816e0d](https://github.com/BrianHicks/candy-and-allowances/commit/816e0d04b4479f04129da2edbfb4e4ada56803bb).

{{< elmSignup >}}
