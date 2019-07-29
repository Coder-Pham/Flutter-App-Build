# Cat In The Box

Original idea: https://codepen.io/oldstandstudio/pen/odVxdV

With some difference:
- From startup, the box is shaking
- Click first, box stop shaking and cat rise up
- Click again, cat back to the box and box start shaking again

## Animation Library Class

Some animation analysis:
- Cat move up and down (change vertical position), some widgets:
    - **Animation**: 
        - Records the current 'value' of the property being animated.
        - Records the status of the animation (currently running, stopped, etc)
    - **AnimationController**:
        - Starts, stops, restarts (method) the animation.
        - Records the duration of the animation
    - **Tween**:
        - Describes the range that the value being animated spans.
    - **AnimatedBuilder** (can think as StreamBuilder):
        - Takes an **Animation** and a 'builder' function.
        - Every time the animation changes value, builder reruns (return a widget).

## Start with Cat

I'm not very creative person so I not write some code to draw a Cat. Then, I'll download a image of cat, this will be easy :smile:

Now the fun part with animation:
- **Animation** (generic type): it records current *value* of the property, here we need property of vertical coordinate axis of object. Then define *double* type.
- **AnimationController**: well it's controller, nothing to think much :satisfied:

Whenever **HomeState** rebuilds, we want a Cat must be at specific location. So that we need **initState()**:
- First thing first, init **Stateful State** must init its parent.

- After that, **CatController** isn't defined yet, so let's do it now.
    - Cat only up for 2s then make it does the job in 2s.
    - @REQUIRED **vsync** (TickerProvider): can be used by any object that wants to be notified whenever a frame triggers.
        - Call to trigger change/update **Animation**.
        - Need a **TickerProviderStateMixin**.

- Next, **CatAnimation** needs a range to animated:
    - With **Tween** to describe the range of moving
    - And duration and speed of animation is determined by **animate()**. This **animated()** takes kind of animation of object (read *Implementers* of **Animation** class)
        - How fast object moves: speed increases gradually -> **CurvedAnimation** with *Curves.easeIn*.
        - How long object moves: determined by **CatController** - pass in *parent* parameter.

## AnimateBuilder Implementation

Ok now, start to combine all characteristic of object with Image by **AnimationBuilder** widget.
- *animation*: Characteristic of object.
- *child*: Object itself -> Performance saving
- *builder*: area being rendered 60 fps.
    - Why set padding top 100px ? Because the object is set to move back to box 100px, so then *catAnimation.value* changed overtime and cat will be push down overtime.

The *builder* itself re-created 60 fps when being request. Then if we call fetch image 60fps is absolute unable, to overcome that we use *child* - only fetch once and reuse in *builder*.

## Taps with GestureDetector

Now we should do something that to make Cat move only when being tapped. **GestureDetector** comes in for this.

https://api.flutter.dev/flutter/widgets/GestureDetector-class.html

We want 1 tap for rise up and other tap for back down, so we should use **onTap** in this **GestureDetector**.

Ok, when detect a tap on widget then what thing next ? Identify the current status of widget and move correctly direction, inside **CatAnimation** there is a suitable properties for this.
- **catAnimation.status** will tell us specific current status of widget.
- Its type is **AnimationStatus**, so we'll use predefined getter to do the work:
    - **dismissed**: is stop at beginning
    - **reverse**: is running backward
    - **forward**: is running forward
    - **completed**: is stop at the end
- Compare status and make proper action.

## Box and Positioned

Actually, a box is very straight-forward thing, just declare it as **Container** with color and done.

But the hard things here are how to position 2 things on top each other properly ?

We might wrap up whole **Center(Stack())** inside **GestureDetector**. That basically ok but the box will be left-aligned in the center of screen.

Ok because screen layout, we may wrap a Cat inside **Positioned** (only work in **Stack**) instead of **Container**. Here are 3 problems with this:
- The Cat never being seen.
- Wrong aligned of whole Stack
- Cat image is very big but **Stack** only show what inside its region. Then we may only see its bottom left of image.

Found problems then solve the problems:
- Shrink down image: The **Positioned** is expand base on image size itself.
    - Then we set size of image base on **distance left's edge is insect from left of Stack**.
    - Do the same with right side, now image will always sits inside tightly.
    - *top*: also helps for push Cat up and down. Because *distance of edge to edge* changed. This is offset so can be negative.

Do some tweak and math for initial & final position of Cat and OK.