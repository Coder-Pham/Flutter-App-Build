# Reactive Programming with Dart - Streams

A new learning Dart source code to learn **Streams**.

## Definition

*Stream*: A source of asynchronous data events.

Take the *Stream* as the Chocolate Cake Factory where have 3 steps:
- Order Taker
- Order Inspector (check type of order)
- Baker (return cake or Order Error)

So we acknowledge that:
- The factory receives an order, does some processing on it, then return at the other end.
- The factory isn't built hen the order is made, but way before it.
- The factory spend a lot of time waiting an order.
- Factory must have an 'entry point'.
- After a cake is made, S.O has to come pick it up.

## StreamController

In code, we will build up a Factory based on *StreamController*. Beside the scene, we got 2 new children object: **Sink** and **Stream**

- Sink: as Order Taker, take some value and hand it to Stream
    - To take a order (request input), the **Sink** has the *add()* method can use by following: `StreamController.sink.add()`
- Stream: Factory, process the order.

## StreamTransformer

Take the Factory example, the **StreamTransformer** is considered as a baker.

The **StreamTransformer** take data argument and process it wheter it should return some value or an Error.
So process data, we must define *Callback* function in its *handleData* which take processing arguments and *sink*

To iterate through all *Stream* and use transformer, we use *transform()* method:
```
StreamController.stream.map((order) => order.type).transform(baker);

WHERE:  map() method to get attribute from each item comes into the stream, does some processing on it. This step is considered as Inspector.
        transform() method take appropriate StreamTransformer name to use, combine with map() return.
``` 

## Listener

The **Listener** is considered as the pickup station in Factory, where it takes result from baker and return to client.

In this case, our final return is a cake or an error which is handle by *listen()* method.

*listen()* method take a required function to take action. And in case of *sink.addError()* happens, there is *onError* named parameter to handle too.

# Practical Example of Stream

View code *button.html* and *practical.dart*, to learn more the code. The target is create game to click a button every second.

We handle button by *ButtonElement* which has *onClick* event will generate a click event. And the only way to work with that is through a *Stream*.

Another ex: 
- user typing into text input (Source of events)
- Network request
