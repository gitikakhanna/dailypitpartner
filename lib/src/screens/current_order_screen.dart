import 'package:dailypitpartner/src/models/order_model.dart';
import 'package:flutter/material.dart';
import '../resources/repository.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentOrderScreen extends StatefulWidget {
  final String orderId;

  CurrentOrderScreen({Key key, this.orderId}) : super(key: key);

  _CurrentOrderScreenState createState() => _CurrentOrderScreenState();
}

class _CurrentOrderScreenState extends State<CurrentOrderScreen> {
  final _repo = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[50],
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Current Order',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'Customer Details',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: UserDetailBuilder(repo: _repo, widget: widget)),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'Order Details',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: OrderDetailBuilder(repo: _repo, widget: widget)),
              Container(
                margin: EdgeInsets.all(16.0),
                child: RaisedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context){
                        return AlertDialog(
                        title: Text('Service Completed ?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('Confirm'),
                            onPressed: (){
                              _repo.updateStatus(widget.orderId);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                        );
                      },
                    );
                    
                  },
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Completed',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailBuilder extends StatelessWidget {
  const UserDetailBuilder({
    Key key,
    @required Repository repo,
    @required this.widget,
  })  : _repo = repo,
        super(key: key);

  final Repository _repo;
  final CurrentOrderScreen widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _repo.fetchSingleOrder(widget.orderId),
      builder: (context, AsyncSnapshot<List<OrderModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Text(
            'Loading',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.grey,
            ),
          ));
        }

        return Column(
          children: <Widget>[
            ListTile(
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${snapshot.data.first.username}'),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Name'),
              ),
            ),
            Divider(
              height: 8,
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Address'),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${snapshot.data.first.userAddress}',
                  overflow: TextOverflow.fade,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  //_repo.updateStatus(widget.orderId);
                  
                  launch(
                      'google.navigation:q=${snapshot.data.first.userAddress}');
                },
                //textColor: Colors.white,
                color: Colors.green,
                icon: Icon(Icons.navigation),
                iconSize: 40.0,
                splashColor: Colors.green[200],
              ),
            ),
          ],
        );
      },
    );
  }
}

class OrderDetailBuilder extends StatelessWidget {
  const OrderDetailBuilder({
    Key key,
    @required Repository repo,
    @required this.widget,
  })  : _repo = repo,
        super(key: key);

  final Repository _repo;
  final CurrentOrderScreen widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _repo.fetchSingleOrder(widget.orderId),
      builder: (context, AsyncSnapshot<List<OrderModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: Text(
            'Loading',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.grey,
            ),
          ));
        }

        return Column(
          children: <Widget>[
            ListTile(
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${snapshot.data.first.orderId}'),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Order Id'),
              ),
            ),
            Divider(
              height: 8,
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${snapshot.data.first.subCategoryName}'),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${snapshot.data.first.price}',
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    Key key,
    @required Repository repo,
    @required this.widget,
  })  : _repo = repo,
        super(key: key);

  final Repository _repo;
  final CurrentOrderScreen widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _repo.fetchSingleOrder(widget.orderId),
      builder: (context, AsyncSnapshot<List<OrderModel>> snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'Loading',
          );
        }

        return IconButton(
          onPressed: () {
            //_repo.updateStatus(widget.orderId);
            launch('google.navigation:q=${snapshot.data.first.userAddress}');
          },
          //textColor: Colors.white,
          color: Colors.green,
          icon: Icon(Icons.navigation),
          iconSize: 40.0,
          splashColor: Colors.green[200],
        );
      },
    );
  }
}
