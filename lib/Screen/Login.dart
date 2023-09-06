import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'Page/Register.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  State createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  // bool _isShowPassword = true;
  String name = "";
  String password = "";

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(250, 0, 250, 0),
          constraints: const BoxConstraints.expand(),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 140),
                Image.asset(
                  'assets/images/Logo3.png',
                  width: 250,
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                      },
                      onChanged: (value) {
                        name = value;
                      },
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                      // obscureText: false,
                      decoration: const InputDecoration(
                        labelText: "Nhập tên đăng nhập",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white12, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  obscureText: true,
                  // _isShowPassword,
                  decoration: const InputDecoration(
                    labelText: "Nhập mật khẩu",
                    prefixIcon: Icon(Icons.person),
                    // suffixIcon: InkWell(
                    //     onTap: () {
                    //       _isShowPassword = !_isShowPassword;
                    //       setState(() => null);
                    //     },
                    //     child:
                    //         _isShowPassword
                    //             ? Icon(Icons.visibility)
                    //             : Icon(Icons.visibility_off)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white12, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Quên mật khẩu?',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        textAlign: TextAlign.right,
                      ),
                    )),
                const SizedBox(height: 10),
                Container(
                  height: 55,
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ElevatedButton(
                    child: Text('Đăng nhập', style: TextStyle(fontSize: 20)),
                    onPressed: () async {
                      final sharedPreferences = await SharedPreferences.getInstance();
                      final _name = sharedPreferences.getString('name');
                      final _password = sharedPreferences.getString('password');
                      if (name == _name && password == _password) {
                        sharedPreferences.setBool('isLogin', true);
                        final isLogin = sharedPreferences.getBool('isLogin');
                        print('trạng thái đăng nhập $isLogin');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                        } else {
                        showDialog(
                            context: context,
                            builder: (context){
                              return CupertinoAlertDialog(
                                title:  Text('Tài khoản không hợp lệ'),
                                content: Text('Vui lòng kiểm tra lại!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Đóng'),
                                  )
                                ],
                              );
                            });
                        }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black87,
                      minimumSize: Size(500, 130),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 30),
                  child: RichText(
                    text: TextSpan(
                      text: 'Bạn chưa có tài khoản?',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                          text: 'Đăng ký ngay',
                          style: const TextStyle(color: Colors.orange, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
