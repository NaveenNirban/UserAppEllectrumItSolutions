import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/config/application.dart';
import 'package:user_app/models/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<User>> userFuture;
  @override
  void initState() {
    userFuture = _fetchUsers();

    /// Initializing FocusNode instances
    _firstNameFocusNode = FocusNode();
    _lastnameFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  @override
  void dispose() {
    /// Free memory by disposing FocusNode instances
    _firstNameFocusNode.dispose();
    _lastnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _firstName1Controller.dispose();
    _lastName1Controller.dispose();
    _email1Controller.dispose();
    super.dispose();
  }

  Future<List<User>> _fetchUsers() async {
    dynamic response = await http.get(Uri.parse(APIInfo.getAll + "1"));
    //print(jsonDecode(response.body)['data']);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //var data = response.body['data'];
      List<User> listData = (json.decode(response.body)['data'] as List)
          .map((data) => User.fromJson(data))
          .toList();

      return listData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<String> createUser(data) async {
    dynamic response = await http.post(Uri.parse(APIInfo.addUser), body: data);
    //print(jsonDecode(response.body)['data']);

    print(response.body);
    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //var data = response.body['data'];
      /*List<User> listData = (json.decode(response.body)['data'] as List)
          .map((data) => User.fromJson(data))
          .toList();*/

      var result = jsonDecode(response.body)['id'];

      return result;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<String> editUser(data) async {
    dynamic response = await http
        .put(Uri.parse(APIInfo.editUser + '${data['id']}'), body: data);
    if (response.statusCode == 200) {
      return "done";
    } else {
      return 'error';
    }
  }

  /// Global Key to handling form
  final _formKey = GlobalKey<FormState>();

  /// Text controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstName1Controller = TextEditingController();
  final _lastName1Controller = TextEditingController();
  final _email1Controller = TextEditingController();

  ///
  Map<String, String> data = {};

  /// To remove focus from text input fields on submit tap
  late FocusNode _firstNameFocusNode,
      _lastnameFocusNode,
      _usernameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;

  /// Dialog for user delete
  Future<void> _showMyDialog(id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('User Delete'),
                Text('Would you like to delete user with id $id ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                dynamic response =
                    await http.delete(Uri.parse(APIInfo.deleteUser + '$id`'));
                if (response.statusCode == 204) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('User deleted Successfully with id : $id')),
                  );
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// BottomSheet for edit user
  Future<void> _bottomSheetEdit(width, User userData) {
    _firstName1Controller.text = userData.first_name;
    _lastName1Controller.text = userData.last_name;
    _email1Controller.text = userData.email;
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: width * 2,
            padding: EdgeInsets.all(width * 0.05),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit User",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: width * 0.1,
                    ),

                    /// FirstName
                    TextFormField(
                      focusNode: _firstNameFocusNode,
                      controller: _firstName1Controller,
                      decoration: InputDecoration(
                          hintText: 'FirstName',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'FirstName can not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: width * 0.05,
                    ),

                    /// LastName
                    TextFormField(
                      focusNode: _lastnameFocusNode,
                      controller: _lastName1Controller,
                      decoration: InputDecoration(
                          hintText: 'LastName',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'LastName cannot be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: width * 0.05,
                    ),

                    /// Email
                    TextFormField(
                      focusNode: _emailFocusNode,
                      controller: _email1Controller,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: width * 0.1,
                    ),
                    Container(
                      height: width * 0.12,
                      width: width * 0.3,
                      child: ElevatedButton(
                        onPressed: () async {
                          _firstNameFocusNode.unfocus();
                          _lastnameFocusNode.unfocus();
                          _emailFocusNode.unfocus();
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            //User dataModel = User(_firstNameController.text);

                            data = {
                              'first_name': _firstName1Controller.text,
                              'last_name': _lastName1Controller.text,
                              'email': _email1Controller.text,
                              'id': userData.id.toString()
                            };
                            String result = await editUser(data);
                            if (result == "done") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('User Editted Successfully')),
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Dimension Constraints
    double height = MediaQuery.of(context).size.height;
    double safeHeight = height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  height: width * 2,
                  padding: EdgeInsets.all(width * 0.05),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add User",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: width * 0.1,
                            ),

                            /// FirstName
                            TextFormField(
                              focusNode: _firstNameFocusNode,
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                  hintText: 'FirstName',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'FirstName can not be empty';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: width * 0.05,
                            ),

                            /// LastName
                            TextFormField(
                              focusNode: _lastnameFocusNode,
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                  hintText: 'LastName',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'LastName cannot be empty';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: width * 0.05,
                            ),

                            /// Email
                            TextFormField(
                              focusNode: _emailFocusNode,
                              controller: _emailController,
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: width * 0.1,
                            ),
                            Container(
                              height: width * 0.12,
                              width: width * 0.3,
                              child: ElevatedButton(
                                onPressed: () async {
                                  _firstNameFocusNode.unfocus();
                                  _lastnameFocusNode.unfocus();
                                  _emailFocusNode.unfocus();
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    data = {
                                      'first_name': _firstNameController.text,
                                      'last_name': _lastNameController.text,
                                      'email': _emailController.text,
                                    };
                                    String result = await createUser(data);
                                    if (result != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'User added Successfully with id : ${result}')),
                                      );
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: const Text('Submit'),
                              ),
                            ),
                          ],
                        )),
                  ));
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        height: safeHeight,
        width: width,
        padding: EdgeInsets.all(width * 0.05),
        //color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: safeHeight * 0.05,
                child: Text(
                  "Hello ${widget.username}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
            Container(
              height: safeHeight * 0.9,
              width: width,
              //color: Colors.pink,
              child: FutureBuilder<List<User>>(
                future: userFuture,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                  PopupMenuItem(
                                    child: ListTile(
                                      onTap: () {
                                        _bottomSheetEdit(
                                            width, snapshot.data[index]);
                                        //editUserSheet(snapshot.data[index].id);
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      onTap: () {
                                        _showMyDialog(snapshot.data[index].id);
                                      },
                                      leading: Icon(Icons.delete_forever),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                              leading:
                                  Image.network(snapshot.data[index].avatar),
                              title: Text(
                                snapshot.data[index].first_name +
                                    " " +
                                    snapshot.data[index].last_name,
                              ),
                              subtitle: Text(snapshot.data[index].email),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error.toString()}');
                  }

                  // By default, show a loading spinner.
                  return Center(child: const CircularProgressIndicator());
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
