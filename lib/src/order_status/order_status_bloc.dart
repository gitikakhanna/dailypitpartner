import 'package:bloc/bloc.dart';
import 'package:dailypitpartner/src/order_status/index.dart';

class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState> {
  static final OrderStatusBloc _orderStatusBlocSingleton =
      new OrderStatusBloc._internal();

  OrderStatusBloc._internal();

  factory OrderStatusBloc() {
    return _orderStatusBlocSingleton;
  }

  @override
  OrderStatusState get initialState => UnOrderStatusState();

  @override
  Stream<OrderStatusState> mapEventToState(OrderStatusEvent event) async* {
    try {
      yield LoadingOrderStatusState();
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (e) {
      yield ErrorOrderStatusState(errorMessage: e.toString());
    }
  }
}
