import 'package:flutter/material.dart';
import 'package:pos01/model/post.dart';
import '../../bloc/blocs/blocMenu.dart';
import '../../bloc/events/eventMenu.dart';


class ShowFrom extends StatelessWidget {
  ShowFrom({Key? key, required this.onCreateProduct, required this.bloc, this.post})
      : super(key: key);
  TextEditingController avatarController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final PostBloc bloc;
  final Function() onCreateProduct;
  Post? post;

  @override
  Widget build(BuildContext context) {
    if(post!=null){
      avatarController = TextEditingController(text: post!.avatar??'');
      nameController = TextEditingController(text: post!.name??'');
      typeController = TextEditingController(text: post!.type??'');
      priceController = TextEditingController(text: post!.price??'');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10,bottom: 10),
          child: Row(
            children: [
              const SizedBox(width: 400),
              const Text(
                'Nhập thông tin sản phẩm',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              const SizedBox(
                width: 350,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(50, 10, 50, 5),
          child: TextField(
            toolbarOptions: const ToolbarOptions(
              paste: true,
              copy: true,
            ),
            controller: avatarController,
            decoration: const InputDecoration(hintText: 'Ảnh sản phẩm'),
            style: const TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Tên sản phẩm'),
            style: const TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
          child: TextField(
            controller: typeController,
            decoration: const InputDecoration(hintText: 'Loại sản phẩm'),
            style: const TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
          child: TextField(
            controller: priceController,
            decoration: const InputDecoration(hintText: 'Giá sản phẩm'),
            style: const TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(250, 30, 250, 30),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(20)),
          child: MaterialButton(
            onPressed: () {
              if(post == null){
              Navigator.pop(context);
              bloc.add(AddEvent(
                  avatarController.text,
                  nameController.text,
                  typeController.text,
                  priceController.text));
              }
              if(post != null){
                Navigator.pop(context);
                bloc.add(
                    UpdateEvent(
                       post!.id??'',
                    avatarController.text,
                    nameController.text,
                    typeController.text,
                    priceController.text,
                    // index
                    )
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                post == null ?
                'Tạo sản phẩm' : 'Update',
                style: const TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
        ),
        Container(
          // gắn phím ảo dưới showbottomsheet
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          ),
        ),
      ],
    );
  }
}
