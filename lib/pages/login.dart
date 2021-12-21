import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:user_app/config/application.dart';
import 'package:user_app/config/route/router.dart' as router;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Database variable
  var database;

  /// Variable to be supplied with navigator argument
  var username;
  Map<String, String> data = {};

  /// Global Key to handling form
  final _formKey = GlobalKey<FormState>();

  /// Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// To remove focus from text input fields on submit tap
  late FocusNode _emailFocusNode, _passwordFocusNode;

  @override
  void initState() {
    initializeDb();

    /// Initializing FocusNode instances
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  /// Database initialization
  void initializeDb() async {
    database = await openDatabase(
      join(await getDatabasesPath(), DatabaseConfig.localDbName),
      onCreate: (db, version) {},
      version: 1,
    );
    checkAndCreateTable(DatabaseConfig.localTableName);
  }

  /// Check if users table is created or not
  void checkAndCreateTable(var TableName) async {
    final db = await database;
    try {
      var result = await db.query(TableName);
      print("Table data is result $result");
    } on DatabaseException catch (exception) {
      /// If table does not exist then creating
      createTable(TableName);
    }
  }

  /// Create default users table
  void createTable(var TableName) async {
    final db = await database;
    try {
      await db.execute(
          'create table $TableName (firstname varchar,lastname varchar,username varchar,email varchar,password varchar);');
    } on Exception catch (exception) {
      /// Continue
    }
  }

  /// Login function
  Future<bool> login(var userData) async {
    try {
      final db = await database;
      List checkIfUserNameIsUsername = await db.rawQuery(
          "SELECT * FROM ${DatabaseConfig.localTableName} WHERE username='${userData['username']}' AND password='${userData['password']}'");
      List checkIfUserNameIsEmail = await db.rawQuery(
          "SELECT * FROM ${DatabaseConfig.localTableName} WHERE email='${userData['username']}' AND password='${userData['password']}'");

      /// Checking if supplied username data is in database or not
      if (checkIfUserNameIsEmail.isEmpty) {
        if (checkIfUserNameIsUsername.isEmpty) {
          return false;
        } else {
          username = checkIfUserNameIsUsername[0]['username'];
          return true;
        }
      } else {
        username = checkIfUserNameIsEmail[0]['username'];
        return true;
      }
    } on Exception catch (exception) {
      return false;
    }
  }

  @override
  void dispose() {
    /// Free memory by disposing FocusNode instances
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Dimension Constraints
    double height = MediaQuery.of(context).size.height;
    double safeHeight = height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      body: Container(
          height: safeHeight,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: width * 0.05),
          //color: Colors.blue,
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    focusNode: _emailFocusNode,
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'Username / Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  TextFormField(
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: '*******',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  Row(children: [
                    const Text(
                      "New user ? ",
                      style: TextStyle(fontSize: 18),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, router.Router.signup);
                        },
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ))
                  ]),
                  SizedBox(
                    height: width * 0.1,
                  ),
                  Container(
                    height: width * 0.12,
                    width: width * 0.3,
                    child: ElevatedButton(
                      onPressed: () async {
                        _emailFocusNode.unfocus();
                        _passwordFocusNode.unfocus();
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          /// Wrap data into map
                          data = {
                            'username': _emailController.text,
                            'password': _passwordController.text
                          };

                          /// Call login function
                          var result = await login(data);
                          if (result) {
                            Navigator.pushNamed(context, router.Router.home,
                                arguments: username);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Wrong credentials')),
                            );
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ))),
    ));
  }
}
