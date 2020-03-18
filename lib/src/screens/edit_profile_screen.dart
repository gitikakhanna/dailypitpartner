import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dailypitpartner/src/blocs/login_bloc.dart';
import 'package:dailypitpartner/src/models/freelance_model.dart';
import 'package:dailypitpartner/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final FreelancerModel freelancer;
  final LoginBloc loginBloc;
  EditProfileScreen({@required this.freelancer, @required this.loginBloc});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File profileImage;
  String documentName;
  String documentPath;
  FreelancerModel editedFreelancer;

  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    editedFreelancer = widget.freelancer;
    profileImage = null;
    documentName = null;
    documentPath = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            profileImageSection(),
            documentSection(),
            formSection(),
            Container(
              padding: EdgeInsets.all(16),
              child: CupertinoButton(
                color: Colors.blue,
                onPressed: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text('Update'),
                          content: Text('Do you want to update the profile ?'),
                          actions: <Widget>[
                            CupertinoButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                _formKey.currentState.save();
                                Navigator.pop(context);
                                uploadData();
                              },
                            ),
                            CupertinoButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Text('Update Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadData() async {
    print('${editedFreelancer.name}');
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: CupertinoActivityIndicator(),
          );
        });
    var uri = Uri.parse(
        'http://dailypit.com/crmscripts/api/partnerapp/updateFreelancer.php');
    FormData formData = new FormData.from({
      'phone': editedFreelancer.phoneno,
      'name': editedFreelancer.name,
      'address': editedFreelancer.address,
      'qualification': editedFreelancer.qualification
    });
    if (profileImage != null) {
      formData.add(
          'file_0',
          new UploadFileInfo(
              new File(profileImage.path), profileImage.path.split('/').last));
    }

    if (documentName != null) {
      formData.add(
        'file_1',
        new UploadFileInfo(new File(documentPath), documentName),
      );
    }
    var response = await Dio().post(uri.toString(), data: formData);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('${response.data.toString()}');
      Navigator.pop(context);
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Success'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Your Profile was updated successfully'),
              ),
              actions: <Widget>[
                CupertinoButton(
                  child: Text('Ok'),
                  onPressed: () {
                    widget.loginBloc.fetchFreelancerData(
                        Constants.prefs.getString(Constants.firebase_user_id));
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('Failure'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Oops !! Something Went Wrong .'),
              ),
              actions: <Widget>[
                CupertinoButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  Form formSection() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: widget.freelancer.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Name',
                prefixIcon: Icon(Icons.tag_faces),
              ),
              onSaved: (String value) {
                editedFreelancer.name = value.toString().trim();
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: widget.freelancer.address,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
                hintText: 'Address',
                prefixIcon: Icon(Icons.location_city),
              ),
              onSaved: (String value) {
                editedFreelancer.address = value.toString();
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: widget.freelancer.qualification,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Qualification',
                hintText: 'Qualification',
                prefixIcon: Icon(Icons.school),
              ),
              onSaved: (String value) {
                editedFreelancer.qualification = value.toString();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget documentSection() {
    return Column(
      children: <Widget>[
        documentName == null
            ? Container()
            : Container(
                height: MediaQuery.of(context).size.height * 0.05,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('$documentName'),
                    SizedBox(
                      width: 6,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          documentName = null;
                          documentPath = null;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
              ),
        CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              documentName == null
                  ? Text('Select Verification File')
                  : Text('Change File'),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.attach_file,
                size: 16,
              ),
            ],
          ),
          onPressed: () async {
            getDocument();
          },
        ),
      ],
    );
  }

  Widget profileImageSection() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          child: Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: profileImage == null
                          ? CachedNetworkImageProvider(widget.freelancer.image)
                          : FileImage(profileImage)))),
        ),
        CupertinoButton(
          onPressed: () {
            getImage();
          },
          child: Text('Change Profile Image'),
        ),
      ],
    );
  }

  Future getDocument() async {
    String filePath;
    filePath = await FilePicker.getFilePath(type: FileType.ANY);
    print(filePath.split('/').last);
    setState(() {
      documentName = filePath.split('/').last;
      documentPath = filePath;
    });
  }

  Future getImage() async {
    var image;
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Select Image'),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () async {
                  image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {
                    if (image != null) profileImage = image;
                  });
                  Navigator.pop(context);
                },
                child: Text('Camera'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    if (image != null) profileImage = image;
                  });
                  Navigator.pop(context);
                },
                child: Text('Gallery'),
              ),
            ],
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Choose a option to pick an image'),
            ),
          );
        });
  }
}
