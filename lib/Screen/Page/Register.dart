import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos01/Screen/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  createState() => _Register();
}

class _Register extends State<Register> {

  String name = "";
  String password = "";
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Đăng ký',
              style: TextStyle(color: Colors.white, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.orange,
          iconTheme: const IconThemeData(color: Colors.white, size: 30),
          elevation: 0,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(250, 0, 250, 0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 130),
                TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Name',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Password',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 60,
                  margin:  EdgeInsets.only(top: 15),
                  padding:  EdgeInsets.only(bottom: 5),
                  child: ElevatedButton(
                    child: Text('Sign Up', style: TextStyle(fontSize: 20)),
                    onPressed:
                        () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('name', name);
                      prefs.setString('password', password);
                      print('Tài khoản: $name - Mật khẩu: $password');

                      showDialog(
                          context: context,
                          builder: (context){
                            return CupertinoAlertDialog(
                              title:  Text('Đăng ký tài khoản thành công'),
                              content: Text('Đăng nhập ngay!'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => LoginPage()));
                                    },
                                    child: Text('Đồng ý')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Đóng'),
                                )
                              ],
                            );
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black87,
                      minimumSize: Size(500, 130),
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
