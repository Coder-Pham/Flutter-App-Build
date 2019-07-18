# Login_stateful

A new learning Flutter project to have a base knowlegde about Form.

## Getting Started

At the beginning, we'll create a login form with nothing special. Still have the basic layout (except *FormState*).

```
SCAFFOLD -> **LOGIN SCREEN** -> CONTAINER -> **FORM** -> COLUMN -> 3 WIDGETS
                |                               |
                -> *LoginState*                 -> *FormState*
```

So to get data from the TextField,... in Form, we must create GlobalKey in LoginState to associate with FormState. 

**REMIND:** Every text the user input in form is frequently update and save as a attribute in FormState.

## Validate FormField

In FormState, there is **validate** method which to validate all FormField inside have a redefined *validator*. 