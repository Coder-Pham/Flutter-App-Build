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
- *child*: Object itself.
- *builder*: area being rendered 60 fps.
    - Why set padding top 100px ? Because the object is set to move upward 100px, so then from initial location to 100px above shouldn't have anything else. 
    - Only *child* is animated, others can't be moved. So when *child* moves, padding doesn't move.