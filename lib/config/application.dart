/// All application constants will be here
class DatabaseConfig {
  static const String localDbName = "users.db";
  static const String localTableName = "users";
}

class APIInfo {
  static const String serverName = 'https://reqres.in/';
  static const String getAll = serverName + "api/users?=";
  static const String addUser = serverName + "api/users";
  static const String editUser = serverName + "api/users/";
  static const String deleteUser = serverName + "api/users/";
}
