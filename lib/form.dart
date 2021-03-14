import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

final tokenUrl = "https://pmrsu.ru/OAuth/Token";
final grantType = 'password';
final clientId = '8';
final clientSecret = 'qweasd';

final storage = new FlutterSecureStorage();

final dio = Dio.Dio();
Codec<String, String> stringToBase64 = utf8.fuse(base64);

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  var _error = '';
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    loginController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  @override
  void handleSubmit() async {
      if (_formKey.currentState.validate()) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Processing Data')));
        final username = loginController.text;
        final password = passwordController.text;
        setState(() {
          _error = '';
        });
        try {
          final response = await dio.post(tokenUrl,
              data: "password=$password&username=$username&grant_type=$grantType",
              options: Dio.Options(
                  contentType: 'application/x-www-form-urlencoded',
                  headers: {
                    "Authorization": "Basic ${stringToBase64
                        .encode('$clientId:$clientSecret')}"
                  }));

          final data = jsonDecode(response.toString());
          await storage.write(key: 'access_token', value: data['access_token'] );
          await storage.write(key: 'refresh_token', value: data['refresh_token'] );
          Navigator.pushReplacementNamed(context, '/profile');

        } catch (e) {
          final error = jsonDecode(e.response.toString());

          if (error != null) {
            final errorKey = error['error'];

            if (errorKey == 'invalid_grant') setState(() {
              _error = "Invalid login or password";
            });
          }
        }
      }

  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text( 'Login'),
                    ),
                    TextFormField(
                      controller: loginController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Field is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(hintText: "Enter login"),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: <Widget> [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Password'),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: "Enter password"),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Text('$_error', style: TextStyle(color: Colors.red))
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed:  handleSubmit,
                    child: Text('Submit'),
                  ),
                ),
              ),
            ]
        )
    );
  }
}