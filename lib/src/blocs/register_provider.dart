import 'register_bloc.dart';
import 'package:flutter/material.dart';

class RegisterProvider extends InheritedWidget{
  
  final RegisterBloc bloc;
  RegisterProvider({Key key, this.child}):bloc = RegisterBloc(),
  super(key: key, child:child);

  final Widget child;

  static RegisterBloc of(BuildContext context){
    return(context.inheritFromWidgetOfExactType(RegisterProvider)as RegisterProvider).bloc;
  }

  bool updateShouldNotify(RegisterProvider oldWidget){
    return true;
  }

}