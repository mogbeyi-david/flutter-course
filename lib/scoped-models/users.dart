import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_course/models/user.dart';

import './connected_products.dart';

class UsersModel extends ConnectedProducts {


  void login(String email, String password) {
    authenticatedUser = User(id: "userId", email: email, password: password);
  }
}
