import 'package:dailypitpartner/src/models/order_status_response.dart';
import 'package:dailypitpartner/src/models/target_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class TargetState extends Equatable {
  TargetState([Iterable props]) : super(props);

  /// Copy object for use in action
  TargetState getStateCopy();
}

class UnTargetState extends TargetState {
  @override
  String toString() {
    return "UnTargetState";
  }

  @override
  TargetState getStateCopy() {
    return UnTargetState();
  }
}

class LoadingTargetState extends TargetState {
  @override
  String toString() {
    return "LoadingTargetState";
  }

  @override
  TargetState getStateCopy() {
    return LoadingTargetState();
  }
}

class ErrorTargetState extends TargetState {
  final String errorMessage;

  ErrorTargetState({this.errorMessage}) : super([errorMessage]);

  @override
  String toString() {
    return "ErrorTargetState";
  }

  @override
  TargetState getStateCopy() {
    return ErrorTargetState(errorMessage: this.errorMessage);
  }
}

class InCompletedTargetState extends TargetState {
  final TargetResponse targetResponse;

  InCompletedTargetState({this.targetResponse}) : super([targetResponse]);

  @override
  String toString() {
    return "InCompletedTargetState";
  }

  @override
  TargetState getStateCopy() {
    return InCompletedTargetState(targetResponse: this.targetResponse);
  }
}

class CompletedTargetState extends TargetState {
  final TargetResponse targetResponse;

  CompletedTargetState({this.targetResponse}) : super([targetResponse]);

  @override
  String toString() {
    return "CompletedTargetState";
  }

  @override
  TargetState getStateCopy() {
    return CompletedTargetState(targetResponse: this.targetResponse);
  }
}
