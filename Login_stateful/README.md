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

## Retrieve data in FormField

In FormState, there is **save** method which to save all FormField.

**save** method is do the same action like **validate**, it find all children **FormField** which has **onSaved** paramter.

## Mixins Validator

In case our email validator is used by many form (etc: Login Form, Forgot pass form, ...), we want to use these *validator* again. We might use **MixinsValidate** as a *friend* class of State to use valdiators across all form in app.

- First we create **MixinsValidate** class contains all validator we will use.
- Back to **State**, we include **MixinsValidate** as a friend class by **<< with >>** syntax.
- Head to *validator* method, we use defined validator from friend class as *VoidCallback* not to call method. 

(Check code if there are something misunderstand).