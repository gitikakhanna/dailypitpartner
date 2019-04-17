import '../resources/repository.dart';
import '../models/register_model.dart';
import 'package:rxdart/rxdart.dart';
import 'register_validator.dart';

class RegisterBloc with Validator{
  final _repository = Repository();
  final _registerDataStorer = BehaviorSubject<Register>();
  final _issuerDataStored  = PublishSubject<Future<bool>>();

  RegisterBloc(){
    _registerDataStorer.stream.transform(_registerDataTransformer()).pipe(_issuerDataStored);
  }

  Function(Register) get registerData => _registerDataStorer.sink.add;
  Observable <Future<bool>> get isDataStored => _issuerDataStored.stream;

  final _nameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get changeName => _nameController.sink.add;
  Observable<String> get name => _nameController.stream.transform(validateName);

  Function(String) get changeEmail => _emailController.sink.add;
  Observable<String> get email => _emailController.stream.transform(validateEmail);

  Function(String) get changePassword => _passwordController.sink.add;
  Observable<String> get password => _passwordController.stream.transform(validatePassword);

  Observable<bool> get submit => Observable.combineLatest3(name, email, password, (n, e, p) => true);

  registerDataValue(){
    final nameValue = _nameController.value;
    final emailValue = _emailController.value;
    final passwordValue = _passwordController.value;

    registerData(Register(
      name: nameValue,
      email: emailValue,
      password: passwordValue,
    ));

  }



  _registerDataTransformer(){
    return  ScanStreamTransformer(
      (Future<bool> result, Register register,_){
        result = _repository.registerUser(register);
        return result;
      }
    );
  }

  dispose(){
    _registerDataStorer.close();
    _issuerDataStored.close();
    _nameController.close();
    _emailController.close();
    _passwordController.close();
  }

}