# Navigation - PageRoute widget

## Basic Understand

- Anytime we create a **MaterialApp** instance we auto get an object **Nagivator**

When created **MaterialApp Navigator** will lookup to know what will be show on screen (ask in following):
- Do I have a widget *home*
- Do I have a map object *routes* (named parameter)
- Do I have an *onGenerateRoute* callback (named parameter)

The last 2 questions is to show more other screen instead of just 1 home screen. There is another question about **fallback** for render screens which don't exist (404 page).

## Routes method

To startup, we can use Routes Table to know what route name (like web link) to what screen should be show (screen widget).

| <td colspan=2> **Route Table**     
| Route name(static) |   PageBuilder |
|--------------------|---------------|
| /                  |   NewsList    |
| /id                |   NewsDetail  |

**NOTE**: *PageBuilder* is a widget with *builder* function and anytime that function is called. It's up to you to return the widget that we want to show on the screen.

### Shortcoming with this method

We want to tap on a **ListTile** story and go to a screen that shows info about that story. 

So difficulty is how to pass info from TopNews screen to Details screen

Because route name is static so that we cant setup route name as `/details/:id` as web application.

Solution:
- We can use BLoC with another stream to pass story info
- Or we use **onGenerateRoute** callback function 

## onGenerateRoute callback - Solution for passing info between screens

How it going to work:
- When we tap on story id 23 (for example), code will run **`navigator.pushNamed(context, '/23')`**.
    - Second arg (any string we want) to create a route with that route name.
- Then **`onGenerateRoute`** will be invoked with '/23'.
- We parse that route name, get '/23'.
- Then create instance of **StoryDetails**, pass in '23'


With this we have ability more easily communicate info from 1-to-1

### Implementation onGenerateRoute

As simple implementation to replace **home** parameter, we first want to show only **NewsList()**.

The **onGenerateRoute**:
- *@require* a function with **RouteSettings** parameter and return **Route**.
- Therefore, we can't simply return screen widget, but use **MaterialPageRoute** builder (builder is used to render other widgets at some point of time).
    - This builder as EVERY BUILDERS, is a function requires **BuildContext** parameter
    - And return screen widget

### Implementation Navigator.pushNamed()

In Flutter, it's quite easy to nagivate between 2 screens.

Here, we just want to change from TopNews to NewsDetail whenever tap on any story. So to do that:
- Look for **onTap** parameter in **ListTile**, it requires a function.
- In that function, we run **Navigator.pushNamed(context, routeName)**.
    - Navigator object is STATIC object which generates whenever a MaterialApp is created.
    - REMEMBER to pass BuildContext to this function.

## Logic for PageRoute 

At **onGenerateRoute** callback, we can set what screen will be render by RouteSettings. And this *RouteSettings* is changed by Nagivator object (push and pop functions), therefore we can investigate its latest route by:
- **RouteSettings.name** parameter which returns string of *routename* in pushNamed()

**NOTE**: a very AMAZING with nagivation in AppBar Flutter.
- Whenever switch to screen which has a AppBar, there will be always a *back* button right there (no need to configuration).