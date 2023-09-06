import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos01/Screen/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Page/AdminPage.dart';
import 'Page/BillPage.dart';
import 'Page/HomePage.dart';

class MyHome extends StatefulWidget {
  @override
  State createState() => _MyHome();
}

class _MyHome extends State<MyHome> {
  String pageActive = 'Home';

  _pageView() {
    switch (pageActive) {
      case 'Home':
        return const HomePage();
      case 'Admin':
        return const AdminPage();
      // case 'Bill':
      //   return const BillPage();

      default:
        return const HomePage();
    }
  }

  _setPage(String page) {
    setState(() {
      pageActive = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.black12,
            ),
            width: 150,
            padding: const EdgeInsets.only(top: 10),
            margin: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            child: _sideMenu(),
          ),
          Expanded(
            flex: 10,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              child: _pageView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideMenu() {
    return Column(
      children: [
        Image.asset(
          'assets/images/Logo3.png',
          width: double.infinity,
          height: 100,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              _itemMenu(
                menu: 'Home',
                icon: Icons.home_filled,
              ),
              _itemMenu(
                menu: 'Admin',
                icon: Icons.person,
              ),
              // _itemMenu(
              //   menu: 'Bill',
              //   icon: Icons.my_library_books,
              // ),
              const SizedBox(height: 400),
              IconButton(
                onPressed: () async {
                  final sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.setBool('isLogin', false);
                  final isLogin = sharedPreferences.getBool('isLogin');
                  print(' Đăng xuất thành công trạng thái của isLogin là : $isLogin');
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage())
                  );
                },
                icon: const Icon(
                  Icons.output,
                  size: 45,
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _itemMenu({required String menu, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 10, 30, 10),
      child: GestureDetector(
        onTap: () => _setPage(menu),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color:
              pageActive == menu ? Colors.orange : Colors.transparent,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.slowMiddle,
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: 45,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
