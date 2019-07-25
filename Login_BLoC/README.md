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
    - And *errorText* is show up - down whenever value changed, so we need *onChanged* paramter. Whenver value changes, it will call API to add value into *Stream*.
    - We can call directly (reference to the function) or call in other function:
    ```dart
    onChange: (newValue) {
        bloc.changeEmail(newValue);
    }
    ```

So that's just how each part of **StreamBuilder** should works, the flow of the code may quiet obscure.
- First, *onChanged* always listen for text changes in Field, when it happened the *sink* get involved.
- *Sink* takes text into *StreamTransformer* and it is checked here.
- *StreamTransformer* returns value through *Stream.sink*.
- *stream* parameter - always listen *Stream*. Whenever something happens, it make *StreamBuilder* re-render its children.

## Scoped BLOC Approach

From beginning, we're using **BLOC** as a *Single Global Instance*, but this approach works well with small app. But with large app, **Scoped BLOC** is better.

For example, *TextField* has children widgets so we now more control of **BLOC** for each part of screen, app, code, ...

In this part, we'll about **InheritedWidget** and use it to wrap specific **BLOC** with **Screen**. So there is no other widget which is parent of **Screen** or siblings **Screen** can use this **BLOC**. But still its children can use this **BLOC**.

### Provider Implementation

When we mean to implement **InheritedWidget**, we meant to create custom widget that going to extend from **InheritedWidget**. This calls **Provider** class has its own **BLOC**.
- Because of that REMIND to create **Provider** constructor:
```dart
Provider({Key key, Widget child}) : super(key: key, child: child);
```

The require method in every **Provider** is *updateShouldNotify()* method. We don't care argument for this particular function and it always return True. 

We also should include a **BLOC** instance in this **Provider**.

Another obscure and **important** function is:
```dart
static Bloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).bloc;
}
```

Code explain:
- From the begining, we example *TextField* has its own children widgets. These new widgets in separate files. So the scope of *LoginScreen* is completely separate scoped of new widget. Then these widgets must somehow reach to **BLOC** in **InheritedWidget** and use it.
    - So the **of** function is for that reaching. The **of** function allows custom widget, just reach up there and use it.

- *HOW*: base on **BuildContext**. This parameter is handle, identifier that locates specific widget inside **widget hierarchy**.
    - **context**: extends down widget that beneath them.
    - So a current widget knows its parent by **context**.
    - `context.inheritFromWidgetOfExactType(Provider)` is a way to tell its parent where it finds **Provider** class type.
    - `as Provider`: if found then whatever it gets back, that'll be **Provider**.

### How to use Provider

- First, wrap up **Provider** with a parent custom widget we want, usually is a **Screen** widget.
- In child widget which needs to use **BLOC** in **Provider**, we initial a **BLOC** with *static* function *of()*.
- So now, we have **BLOC** to use, but what if its children widgets need to use **BLOC**, we can't initialize every **BLOC** in every widgets.
    - So we init ONLY ONE **BLOC**.
    - And when its children need it, we pass **BLOC** as a argument.