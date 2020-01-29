import 'package:dailypitpartner/src/order_status/order_status_provider.dart';

class OrderStatusRepository implements IOrderStatusProvider {
  final IOrderStatusProvider orderStatusProvider;

  OrderStatusRepository(this.orderStatusProvider);

  @override
  Future getAllOrderStatus() async {
    return await orderStatusProvider.getAllOrderStatus();
  }
}
