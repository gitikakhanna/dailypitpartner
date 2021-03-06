import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailypitpartner/src/blocs/login_bloc.dart';
import 'package:dailypitpartner/src/blocs/login_provider.dart';
import 'package:dailypitpartner/src/models/freelance_model.dart';
import 'package:dailypitpartner/src/order_status/index.dart';
import 'package:dailypitpartner/src/screens/edit_profile_screen.dart';
import 'package:dailypitpartner/src/target/index.dart';
import 'package:dailypitpartner/src/utils/constants.dart';
import 'package:dailypitpartner/src/utils/info_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class NewDashboardScreen extends StatefulWidget {
  NewDashboardScreen({Key key}) : super(key: key);

  _NewDashboardScreenState createState() => _NewDashboardScreenState();
}

class _NewDashboardScreenState extends State<NewDashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dailypit Partner',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
              return ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
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
  String newPassword;
  String reenteredPassword;
  String _currentName;
  Color _currentColor;
  @override
  void initState() {
    super.initState();
    statusColors = [Colors.tealAccent, Colors.redAccent];
    statusNames = ['Online', 'Offline'];
    _currentColor = statusColors.elementAt(0);
    _currentName = statusNames.elementAt(0);
    OrderStatusBloc().dispatch(LoadOrderStatusEvent());
    TargetBloc().dispatch(LoadTargetEvent());
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
            elevation: 2.0,
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
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<TargetEvent, TargetState>(
                  bloc: TargetBloc(),
                  builder: (context, TargetState currentState) {
                    if (currentState is InCompletedTargetState) {
                      return Column(
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth: 13.0,
                            animation: true,
                            percent:
                                (currentState.targetResponse.achievedvalue) /
                                    (currentState.targetResponse.targetvalue),
                            center: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    '${currentState.targetResponse.achievedvalue}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    '/${currentState.targetResponse.targetvalue}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            footer: new Text(
                              "Target to Achieve",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.purple,
                          ),
                          Container(
                            margin: EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      "http://dailypit.com/images/targetinitial.jfif"),
                            ),
                          ),
                        ],
                      );
                    }

                    if (currentState is CompletedTargetState) {
                      return Column(
                        children: <Widget>[
                          CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth: 13.0,
                            animation: true,
                            percent:
                                (currentState.targetResponse.achievedvalue) /
                                    (currentState.targetResponse.targetvalue),
                            center: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    '${currentState.targetResponse.achievedvalue}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    '/${currentState.targetResponse.targetvalue}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            footer: new Text(
                              "Target Achieved",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.purple,
                          ),
                          Container(
                            margin: EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  fit: BoxFit.fill,
                                  imageUrl:
                                      "http://dailypit.com/images/target.jpeg"),
                            ),
                          ),
                        ],
                      );
                    }

                    if (currentState is NoTargetState) {
                      return Center(
                        child: Text(
                          "No Target available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return Center(
                        child: PKCardPageSkeleton(
                      totalLines: 2,
                    ));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<OrderStatusEvent, OrderStatusState>(
                  bloc: OrderStatusBloc(),
                  builder: (context, OrderStatusState currentState) {
                    if (currentState is InOrderStatusState)
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InfoCard(
                            margin: EdgeInsets.only(
                                left: 8, right: 2, top: 2, bottom: 2),
                            color: Colors.blue[300],
                            info:
                                '${currentState.orderStatusResponse.assignedCount}',
                            title: 'Orders Assigned',
                          ),
                          InfoCard(
                            margin: EdgeInsets.only(
                                left: 2, right: 8, top: 2, bottom: 2),
                            info:
                                '${currentState.orderStatusResponse.completedCount}',
                            title: 'Orders Completed',
                            color: Colors.greenAccent,
                          ),
                        ],
                      );

                    if (currentState is NoOrderStatusState) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InfoCard(
                            margin: EdgeInsets.only(
                                left: 8, right: 2, top: 2, bottom: 2),
                            color: Colors.blue[300],
                            info:
                                '${currentState.orderStatusResponse.assignedCount}',
                            title: 'Orders Assigned',
                          ),
                          InfoCard(
                            margin: EdgeInsets.only(
                                left: 2, right: 8, top: 2, bottom: 2),
                            info:
                                '${currentState.orderStatusResponse.completedCount}',
                            title: 'Orders Completed',
                            color: Colors.greenAccent,
                          ),
                        ],
                      );
                    }

                    return Center(
                        child: PKCardPageSkeleton(
                      totalLines: 2,
                    ));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Card(
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
                        alignment: Alignment.center,
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
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 12.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditProfileScreen(
                            freelancer: widget.freelancer,
                            loginBloc: LoginProvider.of(context),
                          );
                        }));
                      },
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[200],
                              Colors.blue[400],
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Update Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 12.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Change Password'),
                              content: Material(
                                color: Colors.transparent,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          newPassword = value;
                                        });
                                      },
                                      obscureText: true,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'New Password',
                                        hintText: 'XXXX',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          reenteredPassword = value;
                                        });
                                      },
                                      obscureText: true,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: 'Re Enter Password',
                                        hintText: 'XXXX',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () async {
                                    if (reenteredPassword.length != 0 &&
                                        reenteredPassword == newPassword) {
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                              content:
                                                  CupertinoActivityIndicator());
                                        },
                                      );
                                      bool result = await LoginProvider.of(
                                              context)
                                          .reAuthenticate(reenteredPassword);
                                      if (result) {
                                        Navigator.pop(context);
                                        toast(
                                            'Password Updated Successfully !!');
                                        FirebaseAuth.instance.signOut();
                                        Navigator.popAndPushNamed(
                                            context, '/l');
                                      } else {
                                        Navigator.pop(context);
                                        toast('Oops Something is Wrong');
                                      }
                                    } else {
                                      toast('Entered Password is not same');
                                    }
                                  },
                                  child: Text('Change'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                              ],
                              //contentPadding: EdgeInsets.all(8.0),
                            );
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[50],
                              Colors.blue[300],
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
