import 'package:dio/dio.dart' as d;
import 'package:first_app/instance.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
final grantType = env['GRANT_TYPE'];
final clientId = env['CLIENT_ID'];
final clientSecret = env['CLIENT_SECRET'];

final storage = new FlutterSecureStorage();

final dio = createDio();
Codec<String, String> stringToBase64 = utf8.fuse(base64);

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  var _error = '';
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
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
          d.Response response = await dio.post("/OAuth/Token",
              data: "password=$password&username=$username&grant_type=$grantType",
              options: d.Options(
                  contentType: 'application/x-www-form-urlencoded',
                  headers: {
                    "Authorization": "Basic ${stringToBase64
                        .encode('$clientId:$clientSecret')}"
                  }));

          final data = response.data;
          await storage.write(key: 'access_token', value: data['access_token'] );
          await storage.write(key: 'refresh_token', value: data['refresh_token'] );
          Navigator.pushReplacementNamed(context, '/schedule');

        } on d.DioError catch (e) {
          final error = jsonDecode(e.response.toString());

          if (error != null) {
            final errorKey = error['error'];

            if (errorKey == 'invalid_grant') setState(() {
              _error = "Неверный логин или пароль";
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
                      child: Text( 'Логин'),
                    ),
                    TextFormField(
                      controller: loginController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Обязательное поле';
                        }
                        return null;
                      },
                      decoration: InputDecoration(hintText: "Введите логин"),
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
                          child: Text('Пароль'),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Обязательное поле';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: "Введите пароль"),
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
                child: ElevatedButton(
                    onPressed:  handleSubmit,
                    child: Text('Submit'),
                  ),
              ),
            ]
        )
    );
  }
}