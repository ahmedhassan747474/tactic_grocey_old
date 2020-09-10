import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/pages/confirmcode.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;
  final _smsController = TextEditingController();

  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  void login() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.login(user).then((value) {
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 2);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_account_not_exist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  _deleteConfirm(BuildContext context) async {
    await showDialog(
        context: context,
//        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                "ادخال رمز التاكيد",
              ),
              content: TextFormField(
                  onSaved: (input) => user.code = input,
                  keyboardType: TextInputType.number,
                  controller: _smsController,
                  decoration: InputDecoration(
                      counterText: '',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 20.0))
//                    validator: validate,
                  ),
              actions: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () {
                    user.code = _smsController.text;
                    print('_con.user.code');
                    print(user.code);
                    registerCodeConfirm();
                  },
                  child: Text(
                    'ارسال',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    'اعادة ارسال الكود',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ));
  }

  register(String phone) async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.register(user).then((value) {
        if (value != null && value == 200) {
          Navigator.of(scaffoldKey.currentContext).push(MaterialPageRoute(
            builder: (context) => ConfirmCodeRegister(phone),
          ));
          // '/ConfirmCodeRegister'
          // _deleteConfirm(scaffoldKey.currentContext);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_email_account_exists),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  resentCodeConfirm() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resentCodeConfirm(user).then((value) {
        if (value != null && value == 200) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content:
                Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
          ));
          // '/ConfirmCodeRegister'
          // _deleteConfirm(scaffoldKey.currentContext);
        } else {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).this_code_confirm_resent_wrong),
          ));
        }
      }).catchError((e) {
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_code_confirm_resent_wrong),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void registerCodeConfirm() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      print('uer controller    registerCodeConfirm()  Overlay -------------- ');
      print(
          'uer controller    registerCodeConfirm()  user.code -------------- ' +
              user.code);
      print(
          'uer controller    registerCodeConfirm()  user.phone -------------- ' +
              user.phone);

      repository.registerCodeConfirm(user).then((value) {
        print(
            'uer controller    registerCodeConfirm()  registerCodeConfirm(user)  -------------- ');
        if (value != null && value.apiToken != null) {
          Navigator.of(scaffoldKey.currentContext).pop();
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 2);
        } else {
          print(
              'uer controller    registerCodeConfirm()  user.phone -------------- else');
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).this_code_confirm_wrong),
          ));
        }
      }).catchError((e) {
        print(
            'uer controller    registerCodeConfirm()  user.phone -------------- else' +
                e.toString());
        loader.remove();
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_code_confirm_wrong),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content:
                Text(S.of(context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext)
                    .pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}
