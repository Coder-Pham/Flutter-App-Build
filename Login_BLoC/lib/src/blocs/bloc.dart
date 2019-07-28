import 'dart:async';
import 'validate.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validators {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  // Add data to stream
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Stream<bool> get submitValid =>
      Observable.combineLatest2(email, password, (e, p) => true);

  // Retrieve data from stream
  Stream<String> get email => _email.stream.transform(emailValidator);
  Stream<String> get password => _password.stream.transform(passwordValidator);

  submit() {
    final valideEmail = _email.value;
    final validPassword = _password.value;
  }

  // Destructor
  dispose() {
    _email.close();
    _password.close();
  }
}
