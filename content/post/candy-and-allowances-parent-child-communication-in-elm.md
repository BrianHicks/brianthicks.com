---
date: "2016-06-23T16:48:54-05:00"
title: "Candy and Allowances: Parent-Child Communication in Elm"
tags: ["elm"]

---

Nobody wants to feel like their application holds together by duct tape and
baling wire. Coupling components is icky, but&hellip; sometimes you've got a
parent and child components that just *have* to talk to each other. It can feel
like you're missing something simple when these situations come up. Do you have
to give up on clean separation of concerns just to get it working? There's hope,
though: this problem is not as difficult as it seems on the surface.

<!--more-->

## Initial Modeling

Let's work out the relationship between parent and child components with
*actual* parents and children. Imagine an allowance tracker. The parent gets
paychecks, and then give the children
[allowances](https://en.wikipedia.org/wiki/Allowance_(money).) You might start
to model the parent like this:

```elm
type alias Model =
    { money : Float
    , children : Dict String Child.Model
    }
    

init : Model
init =
    { money = 0
    , children =
        Dict.fromList
            [ ( "Trevor", Child.init )
            , ( "Jane", Child.init )
            ]
    }

    
type Msg
    = Paycheck Float
    | ChildMsg String Child.Msg
    
    
update : Msg -> Model -> Model
update msg model =
    case msg of
        Paycheck amount ->
            { model | money = model.money + amount }

        ChildMsg name msg' ->
            case Dict.get name model.children of
                Nothing ->
                    model

                Just child ->
                    { model
                        | children =
                            Dict.insert name (Child.update msg' child) model.children
                    }
```

So far, so good. The parent gets their own paychecks and lives in peaceful
coexistence with the children. Meanwhile, the children do pretty much as they
please. We keep a record of the children by their names, and use that to update
them whenever we get one of their messages. Next, let's check out what's going
on in the Child model:

```elm
type alias Model =
    { money : Float }
    

type Msg
    = Allowance Float
    | Candy


update : Msg -> Model -> Model
update msg model =
    case msg of
        Allowance amount ->
            { model | money = model.money + amount }

        Candy ->
            { model | money = model.money - 5 }
```

We've given our children the ability to receive an allowance, and then spend
that money on candy with wild abandon. In fact, they can go into debt to the
candy store! Good thing we're such modern *laissez-faire* parents, or this would
be a real problem. But a bigger problem: we don't actually have a way to give
the children their allowance money, leading to a candy-based debt spiral. We'd
better intervene.

## Parent to Child: Allowances

In the parent, again:

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        -- Paycheck and ChildMsg removed for space

        Allowance ->
            let
                perChild =
                    10.0

                total =
                    perChild * (Dict.size model.children |> toFloat)

                giveTo =
                    Child.update (Child.Allowance perChild)
            in
                if model.money - total < 0 then
                    model
                else
                    { model
                        | money =
                            model.money - total
                        , children =
                            Dict.map (\_ child -> giveTo child) model.children
                    }
```

What's going on here? Well, we're being responsible parents at last. We can't
give the children money if doing so would mean that we had negative money, and
we need to give the same amount to each child. We do this by computing the total
money needed by multiplying the allowance amount by the number of children. Then
we check if the total amount would bring the parent balance below 0. If it
would, we do nothing. Otherwise, we go ahead and give the children money by
sending a message they know about.

This is the first way we're actively communicating between the parent and child
components. The child defines certain events (`Msg`) to which it will respond
via `update`. That means that other components (such as our parent) can send
those messages just as easily as they can pass them along.

If this still seems icky, remember that the parent doesn't "own" the messages
passed to the child. We can consider the child messages part of the public API
for that module. Since we're following the Elm Architecture, we get a consistent
public API. If we change the API between our modules, the compiler will tell us
right away.

## Child to Parent: Candy!

Parents sending messages to children is only half the equation, though. What
about communication from the child to the parent? In our case, let's return to
lax parenting. Whenever the children want to buy candy and don't have money,
we'll just cover it. But how? Remember how in `Parent.update` we're handling
child messages?

```elm
update : Msg -> Model -> Model
update msg model =
    case msg of
        ChildMsg name msg' ->
            case Dict.get name model.children of
                Nothing ->
                    model

                Just child ->
                    { model
                        | children =
                            Dict.insert name (Child.update msg' child) model.children
                    }
```

It seems like we should put something here. But where? We *definitely* don't
want to change the child state in the parent, since this would mean that part of
the implementation of the child would live in the parent. This would couple them
tightly, and we definitely don't want that! So what's the way around this? Let's
just change `Child.update` to pass a message back to the parent!

In `Child`:

```elm
update : Msg -> Model -> ( Model, Float )
update msg model =
    case msg of
        Allowance amount ->
            ( { model | money = model.money + amount }
            , 0
            )

        Candy ->
            let
                money =
                    model.money - 5
            in
                ( { model | money = money }
                , min money 0 |> abs
                )
```

We've just modified the signature of `update` to return an extra bit of data. If
the childs balance goes negative, it will complain until the parent gives it a
bit of extra money. "But wait a minute," I can hear you saying, "doesn't
modifying the signature of `update` go against the Elm Architecture?" Nope! In
fact, the shape that `update` returns is another part of the public API. As
implementers, we get to define the public API of our modules. Let's back this up
with a quote from Evan Czaplicki in
[a thread on this subject](https://groups.google.com/forum/#!searchin/elm-discuss/Sub/elm-discuss/3Ue4pAjL29E/jOPcnbaHCQAJ):

> I think folks take the Elm Architecture tutorial too literally. It's more of
> guidelines. If you want to pass information to a parent after an update, just
> do it:
>
> `update : Action -> Model -> ( Model, Effects Action, whateverYouWant)`

So now we've got a way to pass data back up! That said, how do we actually *use*
this message from the parent? Something like this:

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
                        ( updated, amount ) =
                            Child.update msg' child

                        ( child', money ) =
                            if amount > 0 then
                                ( Child.update (Child.Allowance amount) updated |> fst
                                , model.money - amount
                                )
                            else
                                ( updated, model.money )

                        children =
                            Dict.insert name child' model.children
                    in
                        { model | children = children, money = money }
```

The first thing you'll notice is that we're now looking for the amount when
calling `update`. We then compute the new amount of money the parent has as well
as giving the child the money to cover their candy shopping spree.

Now whenever the child gets a `Candy` message and doesn't have any money it asks
the parent for a little extra. This is the communication from the child to the
parent, so now we have two-way communication. The best part is that neither side
knows too much about the others state. Since they communicate over well-defined
messages, as long as the `update` functions handle all the cases (which the
compiler will ensure) we can't end up in an inconsistent state. Plus, we can add
new parents to these child components in a safe way. Separation of concerns is
great!

## Done!

I omitted a few parts from this post to keep it concise, but you can grab the
final version of the code at
[BrianHicks/candy-and-allowances](https://github.com/BrianHicks/candy-and-allowances)
on GitHub. That includes my final implementation of child-to-parent
communication, as well as the view functions.

To sum up:

- You can communicate to child components by calling their `update` function
  with the `Msg`s that they define. This is probably possible in your
  application *right now* if you're following the Elm Architecture.

- Some small changes to the child component's `update` function let you set up a
  feedback loop back to the parent. A real life version of this might look like
  updating the parent's view from a scroll bar: messages would indicate the
  percent scrolled, and the parent could update its offset accordingly.
  
  This pattern should scale up just fine, as well. If you need more messages,
  make another union type for them (called, for example, `MsgOut` and using a
  similar way.) That said, if a child component has a huge number of events the
  parent needs to handle, it may be a sign that you either need to split
  functionality out to multiple children or make the child part of the parent to
  begin with. A minimal interface here will make your child components much
  easier to reuse.
  
Now you'll know what tools to reach for the next time you need to solve this
problem!

**update**: [part II, covering child to child communication]({{< ref
"candy-and-allowances-part-two-child-child-communication-in-elm.md" >}}) is now
available.

{{<elmSignup>}}
