# RxDart / ReactiveX

## Introducing RxDart

From the previous part, we need functions to take **EmailStream** and **PasswordStream**, combine together and get signal when the submit button is enable.

**Quick Note:**
- Apart of the ReactiveX family of libraries (other version: RxJS, RxPython, ...)
- Documentation: http://reactivex.io  
    - The best source:https://pub.dev/documentation/rxdart/latest/
- An API for asynchronous programming with observable streams. 
- Each version is similar, sometimes have small differences
- Because ReactiveX has to be similar between languages, they use some terminology different than what Dart uses.

## Terminology

In RxDart world:
- **Stream** == **Observable** (just Stream but with more functions/object)
- **StreamController** == **Subject** (just StreamController like sink, stream, ...)

## CombineLatest function

We need a specific function to take 2 Streams and get us something back that we create a behaviour of button.  

In this case, we will look at **combineLatest2** static method inside **Observable** class: Merges the given Streams into one Observable sequence.

So with this function, we'll pass in **EmailStream** and **PasswordStream**. In result we'll have **SubmitStream** which tied to login button.

**Highly Recommend**: https://rxmarbles.com/#combineLatest. Whenever both streams emit values then the result stream emit a value.

**QUICK NOTE:** In validator, our **StreamController.sink** does 1 or 2 actions *add()* - *addError()*. Only *add()* method is actually returns value into **Stream**.

Now, we create a GETTER of **Stream** from *combineLatest2* to tied with button.
- Functions take 2 **Stream**.
- And a check function. The return value from this function is also a return value for this **Stream**.
    - It's require to take values from 2 **Stream** as arguments.
    - Values are from **sink.add()**
- If *sink.addError()* occurs in 1 or 2 input *Stream* then result **Stream** also has that error.

## Back to StreamBuilder

When we done implementing RxDart for LoginEnable, now we need a way that *Submit Button* takes the new **Stream** and handle behaviour.

Ok then, working with **StreamBuiler** again, this Widget listens to new **Stream** just created. Whenever the new item comes to **Stream**, the button choose to enable/disable login. (Disabled button by set *null* for **onPress**)

Now a new problem, our **Email and Password Stream** are listened twice (once in **StreamBuilder**, second in **combineLatest**), Flutter doesn't allow that happens. The workaround is use **StreamController.broadcast()**, it's just the same like normal but it can be listened more than once.

## Replacing StreamController with Subject (BehaviourSubject)

After validate all *TextField*, we may be need to retrieve data and do something with it like send request, etc,...

But **StreamController** can retrieve data, it only gets 1 data at a time and dump it. So we find solution from RxDart.

Here we use **BehaviourSubject** - A special StreamController that captures the latest item that has been added to the controller, and emits that as the first item to any new listener. And by default, this **Subject** = **StreamController.broadcast()**.