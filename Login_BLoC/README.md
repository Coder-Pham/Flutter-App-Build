# Login_BLoC

A new Flutter project to learn BLOC Pattern with Login form.

## Getting Started

Start from the previous login app, but this time we have another screen connect to *MaterialApp* and want to use the same data between 2 screen.

```
App -> MaterialApp --> LoginScreen
                   |
                   ->  UserPreferences
```

So this is where the **BLoC** (Business Logic Compoment) comes in, 1 source of information through multiple widget in app.
- House of the data, state inside this 1 entity.
- Does not tight to any widget. Seperate from hierarchy widget.

For example, we need to share data of CheckBox in LoginScreen to other screen. We put these data to *BLoC* (seperate entity).
In another screen where needs those CheckBox data, we get request from *BLoC* and pass to there.

## The Purpose of Streams with BLoC

We can consider that *TextFormField* as *input* in HTML, a source of events.  

Also we are working with Streams result through *listen()*. But in the world of Flutter, we are not limited to *listen()* and we make use of Widget.

So *BLoC* works as central data by wired up - pipe(or any other kind of method):
```
INPUT data stream   ->  BLoC    -> OUTPUT data stream 
from a widget                       to a widget
```

Still the CheckBox example, now we look deeper:
```
                            APP
                ------------------------
                |                       |
                V                       V
            LoginScreen             OtherScreen
                |                       |   
                V                       V
            Information             Informantion
        PRODUCING widget          CONSUMING widget
                |                       ^
                V                       |
                -------------------------
                            |
                   BLOC( Transformer )
```

- Transformer can be any thing, etc: **map()**, **StreamTransformer.fromHandle()**.

