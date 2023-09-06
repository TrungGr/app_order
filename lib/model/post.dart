class Post {
  dynamic id;
  String? avatar;
  String? name;
  String? type;
  String? price;
  bool selected;
  int count;

  Post({this.id,  this.avatar, this.name,  this.type, this.price, this.selected = false, this.count=1});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      avatar: json['avatar'],
      name: json['name'],
      price: json['price'],
      type: json['type'],

    );
  }
}
