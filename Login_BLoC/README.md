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

## Working with TextField in BLOC

When we use **StatelessWidget** and **BLOC**, we are no longer use **Form** in **StatefulWidget** so we must find another way to get value in field and valuate it.

After reading **TextField** docs, we notice 2 things: *onChanged()* method and *errorText* in *decoration*.
- *onChanged()* is called when the user changes the value EVERYTIME
- *errorText* is called when the user changes the value.

How we construct the **BLOC**:
```
                                    COLUMN
                ---------------------------------------------
                |                                           |
                V                                           V
            EmailField                                  PassField
        onChanged   errorText                     onChanged   errorText
            |           ^                             |           ^
            |           |                             |           |
            V   validate xformer                      V    validate xformer  
          sink  -->  stream                         sink   -->  stream
        --------------------------                ------------------------  
        | EmailStreamController  |                | PassStreamController |
        ------------------------------------------------------------------
        |                       BLOC                                     |
        ------------------------------------------------------------------
```

- We will create seperate Dart class to serve as **BLOC**, has 2 object:
    - Email StreamController
    - Password StreamController
- When value changes, pass to sink and stream. 
- Run validate xformer in stream and return out to sink.
- ErrorText is take return value to display.


## Code Explain

### BLOC

File *bloc.dart* is the entity which has 2 **StreamController** to control and manage the output of *EmailTextField* and *PasswordTextField*.
Those **StreamController** will take only *String* type-specify, it shows by *StreamController* is generic type.

Because this **BLOC** is `Single Global Instance` then we should need API for others to access it. 
- We propose private 2 **StreamController** with `_` before each parameter.
- Create *Getter* for each Stream's inputs (sink).
- Create *Getter* for each Stream's flow control (transformer).

Because we follow `Single Global Instance` method instead of `Scoped Instance`, then we create 1 final **BLOC** instance.

### Validator

Each validator is a **StreamTransformer.fromHandlers**, as previous section, those validators take 1 String argument and return String result.

Each result is returned by a *sink* of Stream.

### Login Screen

The layout of Login Screen has no different with ones before.

Now the main differ is apply *Stream* into *TextField* seamlessly. So we us **StreamBuilder** widget to link all compoments together:
- **StreamBuilder** watches a *Stream*, if the *Stream* changes (or add new) then **StreamBuilder** will automatically process & re-render its widget.
- *stream* in method is *Stream* of EmailTextField in **BLOC**.
- *builder* in method is its child widget, it takes 2 require argument: *context* and *snapshot*
    - The important is *snapshot*, it contains 1 value ONLY whatever just came across our *Stream* (by sink).
    - 2 value in *snapshot* are *data* & *error*.
    - And *errorText* is show up - down whenever value changed, so we need *onChange* paramter. Whenver value changes, it will call API to add value into *Stream*.
    - We can call directly (reference to the function) or call in other function:
    ```
    onChange: (newValue) {
        bloc.changeEmail(newValue);
    }
    ```