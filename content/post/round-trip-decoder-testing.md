---
date: "2017-04-24T09:00:00-06:00"
title: "Add Safety to Your Elm JSON Encoders With Fuzz Testing"
featureimage: "/images/use-fuzz-tests-to-add-safety-to-your-elm-json-decoders.png"
thumbnail: "/images/use-fuzz-tests-to-add-safety-to-your-elm-json-decoders-with-title.png"
section: "Technology"
tags: ["elm"]

---

How do you keep your JSON encoders, decoders, and model in sync?
You can skip fields in your encoder, right?
But should you?
And what about when you add new fields?
Decoders are a little easier, but you have to sync them up with your encoders or you'll lose data.
And the worst part is that we can't rely on the compiler to catch these classes of errors&hellip; argh!

This is a perfect situation for property tests (fuzz tests in `elm-test` lingo.)
The test system will keep us honest by giving us random values to test with.
You can assert that encoders and decoders mirror each other, and add a bit more safety to your app.

<!--more-->

Let's explore this with a simple record and an encoder/decoder pair:

```elm
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


type alias Person =
    { name : String }


encoder : Person -> Value
encoder person =
    Encode.object
        [ ( "name", Encode.string person.name ) ]


decoder : Decoder Person
decoder =
    Decode.map Person
        (Decode.field "name" Decode.string)
```

`encoder` and `decoder` are mirrors of one another: if I encode a value then decode the result I should get the same data I started with.
Let's write a test to make sure this property holds.
We'll need to:

1. Create some test data
2. Encode it to a string
3. Decode it from a string
4. Check to make sure the decoded value is the same as the test data

It ends up looking like this:

```elm
import Expect
import Fuzz exposing (Fuzzer)
import Json.Decode as Decode
import Json.Encode as Encode
import Person exposing (Person, encoder, decoder)
import Test exposing (Test, fuzz, describe)


-- note: you *could* do this inline but I prefer my fuzzers as top-level
-- definitions so I can reuse them between test modules.
person : Fuzzer Person
person =
    Fuzz.map Person
        Fuzz.string


serialization : Test
serialization =
    describe "serialization"
        [ fuzz person "round trip" <|
            \thisPerson ->
                thisPerson
                    |> encoder
                    |> Decode.decodeValue decoder
                    |> Expect.equal (Ok thisPerson)
        ]


all : Test
all =
    describe "person"
        [ serialization ]
```

We want to get random `Person` values for testing, so we create a `Fuzzer`.
Not only will this test with a wide variety of values, it will shrink them if a test fails.
Shrinking makes sure that we get the simplest possible failure cases for our values.

Once we get a value, we're encoding it and then decoding it.
If the value is the same, we're done! Otherwise, we'll see how the value changed in the round trip.

We can test this by breaking something.
Let's add a new field to the record and decoder, but not the encoder:

```elm
type alias Person =
    { name : String
    , age : Int
    }
    

decoder : Decoder Person
decoder =
    Decode.map2 Person 
        (Decode.field "name" Decode.string)
        (Decode.field "age" Decode.int)


encoder : Person -> Value
encoder person =
    Encode.object
        [ ( "name", Encode.string person.name ) ]
```

Once we fix the test file so it compiles (adding the new field to the fuzzer) we can run the test and see the failure:

```text
↓ person
↓ serialization
✗ round trip

Given { name = "", age = 0 }

    Err "Expecting an object with a field named `age` but instead got: {\"name\":\"\"}"
    ╷
    │ Expect.equal
    ╵
    Ok { name = "", age = 0 }
```

And then, once we add the proper field:

```elm
encoder : Person -> Value
encoder person =
    Encode.object
        [ ( "name", Encode.string person.name ) 
        , ( "age", Encode.int person.age )
        ]
```

It passes!

```text
TEST RUN PASSED

Duration: 34 ms
Passed:   1
Failed:   0
```

So now you know!
Next time you find yourself wondering if your encoder is going to break, write some fuzz tests and sleep easy!

{{< elmSignup >}}

**Update**: corrected typo and simplified test case to roundtrip on `Value` instead of `String`. Thanks to Ian Mackenzie!
