import 'dart:convert';
import 'package:http/http.dart';
import '../model/post.dart';

class Repository{
  String url = 'https://649a667fbf7c145d0238cd2b.mockapi.io/abxc';
  List<Post> _postList = [];
  Future<List<Post>> getPost({required String type}) async {
    String urlCategory = 'https://649a667fbf7c145d0238cd2b.mockapi.io/abxc?type=$type';
    Response response = await get(Uri.parse(urlCategory));
    if (response.statusCode == 200) {
      _postList = List<Post>.from(jsonDecode(utf8.decode(response.bodyBytes)).map((e)=>Post.fromJson(e)));
       return _postList;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  Future<List<Post>> createPost(String avatar, String name, String type, String price) async {
    Response response = await post(Uri.parse(url),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(<String, String>{
        'avatar': avatar,
        'name': name,
        'type': type,
        'price': price,
      }),
    );
    if (response.statusCode == 201) {
      return _postList;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  Future<List<Post>> updatePost(dynamic id, String avatar, String name,
      String type, String price,
      ) async {
    Response response = await patch(Uri.parse('${url}/$id'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(<String, String>{
        'avatar': avatar,
        'name': name,
        'type': type,
        'price': price,
      }),
    );
    if (response.statusCode == 200) {
      return _postList;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  Future<List<Post>> deletePost(dynamic id, int index) async {
    Response response = await delete(Uri.parse('${url}/$id'));
    if (response.statusCode == 200) {
      _postList.removeAt(index);
      return _postList;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}