import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../model/post.dart';


@immutable
abstract class OrderEvent extends Equatable{
  const OrderEvent();
  @override
  List<Object?> get props => [];
}
class LoadingOrderEvent extends OrderEvent{
  @override
  List<Object?> get props => [];
}
class AddBillEvent extends OrderEvent{
  final List<Post> posts;
  const AddBillEvent(this.posts);
  @override
  List<Object?> get props => [];
}
class RemoveBillEvent extends OrderEvent{
  final Post post;
  const RemoveBillEvent(this.post);
  @override
  List<Object?> get props => [];
}
class IncrementEvent extends OrderEvent{
  final List<Post> posts;
  final int index;
  const IncrementEvent(this.posts, this.index);
}
class DecrementEvent extends OrderEvent{
  final List<Post> posts;
  final int index;
  const DecrementEvent(this.posts, this.index);
}
class PriceEvent extends OrderEvent{
  final String price;
  const PriceEvent(this.price);
}
class AddPriceEvent extends OrderEvent{
  final int price;
  const AddPriceEvent(this.price);
  @override
  List<Object?> get props => [];
}
class RemovePriceEvent extends OrderEvent{
  final Post post;
  const RemovePriceEvent(this.post);
  @override
  List<Object?> get props => [];
}

