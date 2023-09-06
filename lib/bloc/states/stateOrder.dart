import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../model/post.dart';

@immutable
abstract class OrderState extends Equatable{
  const OrderState();
  @override
  List<Object?> get props => [];
}
class LoadingOrderState extends OrderState{
  @override
  List<Object?> get props => [];
}
class LoadedOrderState extends OrderState{
  const LoadedOrderState(this.posts);
  final List<Post> posts;

  @override
  List<Object?> get props => [posts];
}

