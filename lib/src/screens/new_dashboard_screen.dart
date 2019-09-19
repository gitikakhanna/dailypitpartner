import 'package:dailypitpartner/src/blocs/login_bloc.dart';
import 'package:dailypitpartner/src/blocs/login_provider.dart';
import 'package:dailypitpartner/src/models/freelance_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewDashboardScreen extends StatefulWidget {
  NewDashboardScreen({Key key}) : super(key: key);

  _NewDashboardScreenState createState() => _NewDashboardScreenState();
}

class _NewDashboardScreenState extends State<NewDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.freelanceStream,
        builder:
            (BuildContext context, AsyncSnapshot<FreelancerModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.name == 'Loading') {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.name == 'Error') {
              return Center(
                child: Text('Something is Wrong'),
              );
            } else {
              return FreelancerProfileCard(
                freelancer: snapshot.data,
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}

class FreelancerProfileCard extends StatelessWidget {
  final FreelancerModel freelancer;
  FreelancerProfileCard({Key key, @required this.freelancer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('${freelancer.name}'),
              Text('${freelancer.address}'),
            ],
          ),
        ),
      ),
    );
  }
}
