import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/post.dart';


@immutable
abstract class PostEvent extends Equatable{
  const PostEvent();
  @override
  List<Object?> get props => [];
}

class LoadingEvent extends PostEvent{
  final String type;

  const LoadingEvent({required this.type});

  @override
  List<Object?> get props => [];

}
class AddEvent extends PostEvent{
  final String avatar;
  final String name;
  final String type;
  final String price;
  const AddEvent(this.avatar, this.name, this.type, this.price);
  @override
  List<Object?> get props => [];
}
class UpdateEvent extends PostEvent{
  final dynamic id;
  final String avatar;
  final String name;
  final String type;
  final String price;
  const UpdateEvent(this.id, this.avatar, this.name, this.type, this.price,);
  @override
  List<Object?> get props => [];
}
class DeleteEvent extends PostEvent{
  final Post post;
  final dynamic id;
  final int index;
  const DeleteEvent(this.post, this.id, this.index);
  @override
  List<Object?> get props => [post];
}
class ColorChangedEvent extends PostEvent{
  final List<Post> post;
  final int index;
  const ColorChangedEvent(this.index, this.post);
}
class ResetItemEvent extends PostEvent{
  final List<Post> post;
  final int index;
  const ResetItemEvent(this.index, this.post);
}

