import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;

class ConfirmCodeResetPassword extends StatefulWidget {
  final String phone;
  ConfirmCodeResetPassword(this.phone);
  @override
  _ConfirmCodeResetPasswordState createState() =>
      _ConfirmCodeResetPasswordState();
}

class _ConfirmCodeResetPasswordState
    extends StateMVC<ConfirmCodeResetPassword> {
  UserController _con;

  _ConfirmCodeResetPasswordState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    print(config.App(context).appHeight(50));
    return Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: config.App(context).appWidth(100),
              height: config.App(context).appHeight(29.5),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(22.5) - 120,
            child: Container(
              width: config.App(context).appWidth(84),
              height: config.App(context).appHeight(29.5),
              child: Text(
                S.of(context).submit,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(25.5) - 50,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 50,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                    )
                  ]),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
              width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
              child: Form(
                key: _con.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      onSaved: (input) => _con.user.code = input,
                      validator: (input) => input.trim().length < 3
                          ? S.of(context).not_a_valid_phone
                          : null,
                      decoration: InputDecoration(
                        labelText: "Sms",
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: '__ __ __ __',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.verified_user,
                            color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    BlockButtonWidget(
                      text: Text(
                        S.of(context).submit,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        print(widget.phone);
                        _con.user.phone = widget.phone;
                        _con.registerCodeConfirmResetPassword(widget.phone);
                        // _deleteConfirm(context);
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    BlockButtonWidget(
                      text: Text(
                        S.of(context).resent1,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        print(widget.phone);
                        _con.user.phone = widget.phone;
                        _con.resentCodeConfirmPassword(widget.phone);
                        // _deleteConfirm(context);
                      },
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 10,
          //   child: FlatButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed('/Login');
          //     },
          //     textColor: Theme.of(context).hintColor,
          //     child: Text(S.of(context).i_have_account_back_to_login),
          //   ),
          // )
        ],
      ),
    );
  }
}
