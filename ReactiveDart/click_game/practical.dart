/**
 * Test on dartpad.dartlang.org 
 * with button.html file
 */

import 'dart:html';

void main() {
  final ButtonElement button = querySelector('button');

  // onClick return ElementStream<MouseEvent>
  button.onClick
      // Wait for 1s timeout if no click then call onTimeout
      .timeout(
        new Duration(seconds: 1),
        onTimeout: (sink) => sink.addError('You lost !!!'),
      )
      .listen(
        (event) {},
        onError: (err) => print(err),
      );
}
