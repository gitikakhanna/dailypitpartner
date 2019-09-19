import 'dart:async';
import 'package:dailypitpartner/src/models/freelance_model.dart';
import 'package:dailypitpartner/src/resources/repository.dart';
import 'package:dailypitpartner/src/utils/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'login_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Object with LoginValidator {
  LoginBloc() {
    if (Constants.prefs.getBool(Constants.pref_logged_in) ?? false) {
      fetchFreelancerData(
          Constants.prefs.getString(Constants.firebasse_email_id));
    }
  }

  final _repository = Repository();

  final _emailController = new BehaviorSubject<String>();
  final _passwordController = new BehaviorSubject<String>();

  final _freelanceController = new BehaviorSubject<FreelancerModel>();

  Function(FreelancerModel) get freelanceSink => _freelanceController.sink.add;
  Observable<FreelancerModel> get freelanceStream =>
      _freelanceController.stream;

  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Observable<bool> get submit =>
      Observable.combineLatest2(email, password, (e, p) => true);

  Future<FirebaseUser> login() async {
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.value, password: _passwordController.value);

    fetchFreelancerData(user.email);

    return user;
  }

  fetchFreelancerData(String email) async {
    freelanceSink(FreelancerModel(
      name: 'Loading',
    ));
    try {
      List<FreelancerModel> freelancers =
          await _repository.fetchFreelancerDetail(email);
      freelanceSink(freelancers.first);
    } catch (e) {
      freelanceSink(FreelancerModel(
        name: 'Error',
      ));
    }
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
    _freelanceController.close();
  }
}
