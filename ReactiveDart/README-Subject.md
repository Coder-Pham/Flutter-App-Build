# Difference between Rxdart Subject

Both are SIMILAR to: **StreamController.broadcast()**

The difference between 2 Subjects:
- BehaviorSubject will always remember last ITEM which it put out.

For ex, BehaviorSubject add new Item before **listen((event) {print(event);})** is registered. The LISTENER will still print that value.
- But if PublishSubject, it will not.


## Example BehaviorSubject

```dart
void main() async {
    var subject = BehaviorSubject<int>();

    subject.listen((value) {
        print("First: ${value}");
    });
    subject.add(0);
    subject.add(1);

    subject.listen((value) {
        print("Second: ${value}");
    });

    subject.add(3);
    subject.add(4);
}
```

Expected will be: 
- Print first with 4 values
- Print second with 3 values

If with PublishSubject:
- Print second with 2 values.