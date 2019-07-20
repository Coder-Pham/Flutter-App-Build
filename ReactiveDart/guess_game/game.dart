import 'dart:html';

void main() {
  final ButtonElement button = querySelector('button');
  final InputElement input = querySelector('input');

  // take(int count): provides at most $count data events
  // where(): create a new Stream from this Stream, return bool
  // listen(): if where() can return a Stream, then run Function
  // else do nothing and wait to out of guesses.
  button.onClick
      .take(4)
      .where((event) => input.value == 'banana')
      .listen(
        (event) => print('You got it!'),
        onDone: () => print('Run out of guesses.')
      );
}