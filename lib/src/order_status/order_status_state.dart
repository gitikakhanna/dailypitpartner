import 'package:dailypitpartner/src/models/order_status_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class OrderStatusState extends Equatable {
  OrderStatusState([Iterable props]) : super(props);

  /// Copy object for use in action
  OrderStatusState getStateCopy();
}

class UnOrderStatusState extends OrderStatusState {
  @override
  String toString() {
    return "UnOrderStatusState";
  }

  @override
  OrderStatusState getStateCopy() {
    return UnOrderStatusState();
  }
}

class LoadingOrderStatusState extends OrderStatusState {
  @override
  String toString() {
    return "LoadingOrderStatusState";
  }

  @override
  OrderStatusState getStateCopy() {
    return LoadingOrderStatusState();
  }
}

class ErrorOrderStatusState extends OrderStatusState {
  final String errorMessage;

  ErrorOrderStatusState({this.errorMessage}) : super([errorMessage]);

  @override
  String toString() {
    return "ErrorOrderStatusState";
  }

  @override
  OrderStatusState getStateCopy() {
    return ErrorOrderStatusState(errorMessage: this.errorMessage);
  }
}

class InOrderStatusState extends OrderStatusState {
  final OrderStatusResponse orderStatusResponse;

  InOrderStatusState({@required this.orderStatusResponse})
      : super([orderStatusResponse]);

  @override
  String toString() {
    return "InOrderStatusState";
  }

  @override
  OrderStatusState getStateCopy() {
    return InOrderStatusState(orderStatusResponse: this.orderStatusResponse);
  }
}

class NoOrderStatusState extends OrderStatusState {
  final OrderStatusResponse orderStatusResponse;

  NoOrderStatusState({@required this.orderStatusResponse})
      : super([orderStatusResponse]);

  @override
  String toString() {
    return "NoOrderStatusState";
  }

  @override
  OrderStatusState getStateCopy() {
    return NoOrderStatusState(orderStatusResponse: this.orderStatusResponse);
  }
}
