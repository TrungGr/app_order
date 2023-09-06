import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos01/bloc/states/stateOrder.dart';

import '../../model/post.dart';
import '../events/eventOrder.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState>{
   List<Post> _listPostOder = [];

  OrderBloc():super(LoadingOrderState()){

    on<AddBillEvent>((event, emit) async{
      emit(LoadingOrderState());
      _listPostOder = event.posts;
      emit(LoadedOrderState(_listPostOder));
    });

    on<RemoveBillEvent>((event, emit) async{
      emit(LoadingOrderState());
      _listPostOder.remove(event.post);
      emit(LoadedOrderState(_listPostOder));
    });

    on<IncrementEvent>((event, emit) async{
      emit(LoadingOrderState());
       event.posts[event.index].count++;
      emit(LoadedOrderState(_listPostOder));
    });

    on<DecrementEvent>((event, emit) async{
      emit(LoadingOrderState());
      if(event.posts[event.index].count > 1){
        event.posts[event.index].count--;
        emit(LoadedOrderState(_listPostOder));
      }else{
      emit(LoadedOrderState(_listPostOder));
      }
    });

  }
}