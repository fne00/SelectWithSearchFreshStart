import 'dart:async';
import 'dart:io';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'login-static',
  templateUrl: 'login_static_component.html',
  styleUrls: ['login_static_component.css'],
  directives: [
    formDirectives,
    coreDirectives
  ]
)

class LoginStatic {
  String pageTitle = "Login";
  String username = '';
  String password = '';
  String buttonText = "Login";

  String pass = '';
  String cpass = '';
  String setPasswordButtonText = "Save Password";

  String errorMsg = '';

  bool showSetPassword = false;

  List<Map<String, dynamic>> loginCredential = [{
    'user' : 'Tom',
    'pass': '',
    'group': ['a']
  }, {
    'user' : 'Sam',
    'pass': '123',
    'group': ['j']
  }
  ];

  LoginStatic() {
    var cookie = document.cookie;
    if(cookie.contains('username') == true){
      this.errorMsg = "Logged In";
    };
  }

  /*
  * Function to handle login
  * Check user existance in case password is blank
  * Check credential in case username password provided
  * set Cookie if user found
   */
  handleLogin() {

    this.errorMsg = '';
    if(this.username == '' && this.password == '') {
      this.errorMsg = "Username Required";
      return;
    }

    if(this.username != '' && this.password == '') {
      bool isUserExists = this.checkUserExistance(this.username);

      if(isUserExists) {
        this.pageTitle = "Set New Password";
        this.showSetPassword = true;
      } else {
        this.errorMsg = "User Not found.";
      }
    } else {
      var user = this.checkUserCredential(this.username, this.password);
      print(user);
      if(user != null) {
        this.setLoginCookie(user['user'], user['group']);
        this.errorMsg = "Logged In";

        // redirect to welcome
      } else {
        this.errorMsg = "Invalid Credential.";
      }
    }
  }

  checkUserExistance(String username) {
    var user = this.loginCredential.firstWhere((user) => user['user'] == username && user['pass'] == '', orElse: ()=>null);
    if(user != null) {
      return true;
    } else {
      return false;
    }
  }

  checkUserCredential(String username, String password) {
    var user = this.loginCredential.firstWhere((user) => user['user'] == username && user['pass'] == password, orElse: ()=>null);
    return user;
  }

  setLoginCookie(String username, List groups) {
    print(username);
    var c = Cookie('username', username);
    c.maxAge = 24*60*60;
    c.path = '/';
    c.httpOnly = false;
    document.cookie = c.toString();
  }

  saveNewPassword() {
    this.errorMsg = '';
    if(this.pass != '' && this.pass == this.cpass) {
      for(int i=0; i<this.loginCredential.length; i++) {
        if(this.loginCredential[i]['user'] == this.username && this.loginCredential[i]['pass'] == ''){
          this.loginCredential[i]['pass'] = this.pass;
          this.password = this.pass;
          this.handleLogin();
          break;
        }
      }
    }
  }
}