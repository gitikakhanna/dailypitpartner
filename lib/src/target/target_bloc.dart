import 'package:bloc/bloc.dart';

import 'index.dart';

class TargetBloc extends Bloc<TargetEvent, TargetState> {
  static final TargetBloc _targetBlocSingleton = new TargetBloc._internal();

  TargetBloc._internal();

  factory TargetBloc() {
    return _targetBlocSingleton;
  }

  @override
  TargetState get initialState => UnTargetState();

  @override
  Stream<TargetState> mapEventToState(TargetEvent event) async* {
    try {
      yield LoadingTargetState();
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (e) {
      yield ErrorTargetState(errorMessage: e.toString());
    }
  }
}
