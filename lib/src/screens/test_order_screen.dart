import 'package:dailypitpartner/src/models/order_model.dart';
import 'package:dailypitpartner/src/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    //final bloc = UserProvider.of(context);
    //final serviceBloc = ServiceProvider.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Ongoing',
                icon: Icon(Icons.autorenew),
              ),
              Tab(text: 'Completed', icon: Icon(Icons.check_circle_outline)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            TabOrderWidget(
              type: 0,
            ),
            TabOrderWidget(
              type: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class TabOrderWidget extends StatelessWidget {
  final int type;
  const TabOrderWidget({Key key, @required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> user) {
          //print(user.data.uid);
          if (!user.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print(user.data.uid);
          return FutureBuilder(
            future: Repository().fetchMyOrders(user.data.uid),
            builder: (context, AsyncSnapshot<List<OrderModel>> myOrders) {
              if (!myOrders.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (myOrders.data.length == 0) {
                if (type == 0) {
                  return Center(
                    child: Text(
                      'No Orders yet',
                    ),
                  );
                } else if (type == 1) {
                  return Center(
                    child: Text(
                      'No Orders Completed yet',
                    ),
                  );
                }
              }

              return ListView.builder(
                itemCount: myOrders.data.length,
                itemBuilder: (context, index) {
                  OrderModel myOrder;
                  if (type == 0) {
                    if (myOrders.data[index].status != 'completed')
                      myOrder = myOrders.data[index];
                  } else if (type == 1) {
                    if (myOrders.data[index].status == 'completed')
                      myOrder = myOrders.data[index];
                  }
                  return (myOrder == null)
                      ? Container()
                      : Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: ListTile(
                              title: Text('${myOrder.subCategoryName}'),
                              subtitle: Text('${myOrder.price}'),
                              trailing: Text('${myOrder.status}'),
                              onTap: () {
                                //if (myOrder.status.toString().toLowerCase() ==
                                //'assigned') {
                                Navigator.pushNamed(
                                    context, '/c${myOrder.orderId}');
                                //}
                              }),
                        );
                },
              );
            },
          );
        });
  }
}
