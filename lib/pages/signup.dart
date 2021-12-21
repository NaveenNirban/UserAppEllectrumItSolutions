import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:user_app/config/application.dart';
import 'package:user_app/config/route/router.dart' as router;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var database;

  /// Global Key to handling form
  final _formKey = GlobalKey<FormState>();

  /// Text controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  ///
  Map<String, String> data = {};

  /// To remove focus from text input fields on submit tap
  late FocusNode _firstNameFocusNode,
      _lastnameFocusNode,
      _usernameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode;

  @override
  void initState() {
    initializeDb();

    /// Initializing FocusNode instances
    _firstNameFocusNode = FocusNode();
    _lastnameFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
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

  void checkAndCreateTable(var tableName) async {
    final db = await database;
    try {
      var result = await db.execute('select * from $tableName');
      //print("Table data is result $result");
    } on DatabaseException catch (exception) {
      /// If table does not exist then creating
      createTable(tableName);
    }
  }

  void createTable(var tableName) async {
    final db = await database;
    try {
      await db.execute(
          'create table $tableName (firstname varchar,lastname varchar,username varchar,email varchar,password varchar);');
    } on Exception catch (exception) {
      /// Continue
    }
  }

  Future<String> saveToDb(var userData) async {
    final db = await database;
    try {
      await db.insert(DatabaseConfig.localTableName, {
        'firstname': userData['firstname'],
        'lastname': userData['lastname'],
        'username': userData['username'],
        'email': userData['email'],
        'password': userData['password']
      });
      return "Done";
    } on Exception catch (exception) {
      return "User already exists";
    }
  }

  @override
  void dispose() {
    /// Free memory by disposing FocusNode instances
    _firstNameFocusNode.dispose();
    _lastnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// FirstName
                    TextFormField(
                      focusNode: _firstNameFocusNode,
                      controller: _firstNameController,
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
                      controller: _lastNameController,
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

                    /// Username
                    TextFormField(
                      focusNode: _usernameFocusNode,
                      controller: _usernameController,
                      decoration: InputDecoration(
                          hintText: 'Username',
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

                    /// Email
                    TextFormField(
                      focusNode: _emailFocusNode,
                      controller: _emailController,
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
                      height: width * 0.05,
                    ),

                    /// Password
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

                    /// Confirm Password
                    TextFormField(
                      focusNode: _confirmPasswordFocusNode,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
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
                        "Already an user ? ",
                        style: TextStyle(fontSize: 18),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, router.Router.login);
                          },
                          child: const Text(
                            "Login here",
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
                          _firstNameFocusNode.unfocus();
                          _lastnameFocusNode.unfocus();
                          _usernameFocusNode.unfocus();
                          _emailFocusNode.unfocus();
                          _passwordFocusNode.unfocus();
                          _confirmPasswordFocusNode.unfocus();
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            data = {
                              'firstname': _firstNameController.text,
                              'lastname': _lastNameController.text,
                              'username': _usernameController.text,
                              'email': _emailController.text,
                              'password': _passwordController.text
                            };
                            var result = await saveToDb(data);
                            //print(result);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Signing Up, please wait...')),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                )),
          )),
    ));
  }
}
