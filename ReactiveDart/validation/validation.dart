import 'dart:async';
import 'dart:html';

void main() {
  final InputElement input = querySelector('input');
  final DivElement div = querySelector('div');

  final validator = StreamTransformer.fromHandlers(
    handleData: (input, sink) {
      if (input.contains('@'))
        sink.add(input);
      else
        sink.addError('Enter a valid email');
    }
  );

  input.onInput
      .map((dynamic event) => event.target.value)
      .transform(validator)
      .listen(
        (event) => div.innerHtml = '',
        onError: (err) => div.innerHtml = err, 
      );
}
