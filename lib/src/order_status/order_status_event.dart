import 'package:dailypitpartner/src/models/order_status_response.dart';

import 'index.dart';
import 'order_status_provider.dart';

abstract class OrderStatusEvent {
  Future<OrderStatusState> applyAsync(
      {OrderStatusState currentState, OrderStatusBloc bloc});

  OrderStatusRepository _orderStatusRepository =
      OrderStatusRepository(OrderStatusProvider());
}

class LoadOrderStatusEvent extends OrderStatusEvent {
  @override
  Future<OrderStatusState> applyAsync(
      {OrderStatusState currentState, OrderStatusBloc bloc}) async {
    try {
      OrderStatusResponse orderStatusResponse =
          await _orderStatusRepository.getAllOrderStatus();
      if (orderStatusResponse.freelancerId == null) {
        return NoOrderStatusState(orderStatusResponse: orderStatusResponse);
      } else {
        return InOrderStatusState(orderStatusResponse: orderStatusResponse);
      }
    } catch (e) {
      return ErrorOrderStatusState(errorMessage: e.toString());
    }
  }
}
