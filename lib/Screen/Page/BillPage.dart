import 'package:flutter/material.dart';

class BillPage extends StatefulWidget {
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPage();
}

class _BillPage extends State<BillPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black12,
      ),
    );
  }
}