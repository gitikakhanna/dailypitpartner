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
          Constants.prefs.getString(Constants.firebase_user_id));
    }
  }

  FreelancerModel _freelancerModel;

  FreelancerModel editFreelancerObject;

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

    //TODO: Update fetch Freelancer Data API here
    fetchFreelancerData(user.uid);

    return user;
  }

  fetchFreelancerData(String uid) async {
    freelanceSink(FreelancerModel(
      name: 'Loading',
    ));
    try {
      List<FreelancerModel> freelancers =
          await _repository.fetchFreelancerDetail(uid);
      _freelancerModel = freelancers.first;
      Constants.prefs.setString(Constants.sql_user_id, _freelancerModel.id);
      freelanceSink(freelancers.first);
    } catch (e) {
      freelanceSink(FreelancerModel(
        name: 'Error',
      ));
    }
  }

  Future<bool> reAuthenticate(String password) async {
    try {
      FirebaseUser user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _freelancerModel.emailid,
        password: _freelancerModel.password,
      );
      return updatePassword(user, password);
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePassword(FirebaseUser user, String password) async {
    bool isUpdated =
        await _repository.updatePassword(password, _freelancerModel.phoneno);

    if (isUpdated) {
      user.updatePassword(password).then((_) {
        print('Updated');
      });
      return true;
    }

    return false;
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
    _freelanceController.close();
  }
}
