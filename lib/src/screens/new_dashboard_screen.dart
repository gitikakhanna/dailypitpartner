import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailypitpartner/src/blocs/login_bloc.dart';
import 'package:dailypitpartner/src/blocs/login_provider.dart';
import 'package:dailypitpartner/src/models/freelance_model.dart';
import 'package:dailypitpartner/src/screens/edit_profile_screen.dart';
import 'package:dailypitpartner/src/utils/constants.dart';
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FreelancerProfileCard(
                    freelancer: snapshot.data,
                  ),
                ],
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}

class FreelancerProfileCard extends StatefulWidget {
  final FreelancerModel freelancer;
  FreelancerProfileCard({Key key, @required this.freelancer}) : super(key: key);

  @override
  _FreelancerProfileCardState createState() => _FreelancerProfileCardState();
}

class _FreelancerProfileCardState extends State<FreelancerProfileCard> {
  List<Color> statusColors;
  List<String> statusNames;

  String _currentName;
  Color _currentColor;
  @override
  void initState() {
    super.initState();
    statusColors = [Colors.tealAccent, Colors.redAccent];
    statusNames = ['Online', 'Offline'];
    _currentColor = statusColors.elementAt(0);
    _currentName = statusNames.elementAt(0);
  }

  onStatusChangeTap(String docId) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text('Change Status'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Firestore.instance
                    .document('freelancer/$docId')
                    .updateData({'active': 'online'});

                setState(() {
                  _currentColor = statusColors[0];
                  _currentName = statusNames[0];
                });
                Navigator.pop(context);
              },
              child: Text(statusNames[0]),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Firestore.instance
                    .document('freelancer/$docId')
                    .updateData({'active': 'offline'});
                setState(() {
                  _currentColor = statusColors[1];
                  _currentName = statusNames[1];
                });
                Navigator.pop(context);
              },
              child: Text(statusNames[1]),
            ),
          ],
        );
      },
    );
  }

  changeStatus() {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              content: CupertinoActivityIndicator(),
            ));
    Firestore.instance
        .collection('freelancer')
        .where('freelancerid',
            isEqualTo: Constants.prefs.getString(Constants.firebase_user_id))
        .getDocuments()
        .then((QuerySnapshot sn) {
      Navigator.pop(context);
      onStatusChangeTap(sn.documents.first.documentID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        CachedNetworkImageProvider(widget.freelancer.image),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.freelancer.name}',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.freelancer.emailid}',
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 4,
                    ),
                    label: Text(
                      _currentName,
                      style: Theme.of(context).textTheme.button.copyWith(
                          color: _currentColor == statusColors[0]
                              ? Colors.black
                              : Colors.white),
                    ),
                    backgroundColor: _currentColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  changeStatus();
                },
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[300],
                        Colors.blue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Change Status',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditProfileScreen(
                      freelancer: widget.freelancer,
                      loginBloc: LoginProvider.of(context),
                    );
                  }));
                },
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[300],
                        Colors.blue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Change Status',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
