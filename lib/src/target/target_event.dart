import 'package:dailypitpartner/src/models/order_status_response.dart';
import 'package:dailypitpartner/src/models/target_response.dart';
import 'package:dailypitpartner/src/models/update_target_response.dart';
import 'package:flutter/foundation.dart';

import 'index.dart';
import 'target_provider.dart';

abstract class TargetEvent {
  Future<TargetState> applyAsync({TargetState currentState, TargetBloc bloc});

  TargetRepository _targetRepository = TargetRepository(TargetProvider());
}

class LoadTargetEvent extends TargetEvent {
  @override
  Future<TargetState> applyAsync(
      {TargetState currentState, TargetBloc bloc}) async {
    try {
      TargetResponse res = await _targetRepository.getPartnerTarget();
      if (res.isCompleted) {
        return CompletedTargetState(targetResponse: res);
      } else {
        return InCompletedTargetState(targetResponse: res);
      }
    } catch (e) {
      return ErrorTargetState(errorMessage: e.toString());
    }
  }
}

class UpdateTargetEvent extends TargetEvent {
  String value;

  UpdateTargetEvent({@required this.value});

  @override
  Future<TargetState> applyAsync(
      {TargetState currentState, TargetBloc bloc}) async {
    try {
      UpdateTargetResponse res =
          await _targetRepository.updatePartnerTarget(value);
      TargetResponse res1 = await _targetRepository.getPartnerTarget();
      if (res.completed) {
        return CompletedTargetState(targetResponse: res1);
      } else {
        return InCompletedTargetState(targetResponse: res1);
      }
    } catch (e) {
      return ErrorTargetState(errorMessage: e.toString());
    }
  }
}
