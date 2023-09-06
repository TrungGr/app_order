import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../model/post.dart';

@immutable
abstract class PostState extends Equatable{
  const PostState();
  @override
  List<Object?> get props => [];
}

class LoadingState extends PostState{
  @override
  List<Object?> get props => [];
}
class LoadedState extends PostState{
  const LoadedState(this.posts);
  final List<Post> posts;

  @override
  List<Object?> get props => [posts];
}
class ErrorState extends PostState{
  const ErrorState(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
class AddState extends PostState{
  const AddState(this.posts);
  final List<Post> posts;

}
class UpdateState extends PostState{
  const UpdateState(this.posts);
  final List<Post> posts;
}

class DeleteState extends PostState{
  const DeleteState(this.posts);
  final List<Post> posts;
}

class ChangeBackgroundSelectedState extends PostState{
  const ChangeBackgroundSelectedState(this.posts);
  final List<Post> posts;
}

class ChangeBackgroundUnSelectedState extends PostState{
  const ChangeBackgroundUnSelectedState(this.post);
  final Post post;
}

