import 'package:pos01/db/repository.dart';
import 'package:pos01/model/post.dart';
import '../events/eventMenu.dart';
import '../states/stateMenu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState>{
  final Repository _repository;

  PostBloc(this._repository) : super(LoadingState()){
    on<LoadingEvent>((event, emit) async {
      emit(LoadingState());
      print('loading');
      try {
        final posts = await _repository.getPost(type: event.type??'');
      emit(LoadedState(posts));
      print('loaded');
      } catch(e){
        emit(ErrorState(e.toString()));
      }
    });


    on<AddEvent>((event, emit) async{
      emit(LoadingState());
      try{
        final posts = await _repository.createPost(
            event.avatar,
            event.name,
            event.type,
            event.price);
        emit(AddState(posts));
      }catch(e){
        emit(ErrorState(e.toString()));
      }
    });


    on<UpdateEvent>((event, emit) async{
      emit(LoadingState());
      try{
        final posts = await _repository.updatePost(
            event.id,
            event.avatar,
            event.name,
            event.type,
            event.price,
        );
        emit(UpdateState(posts));
      }catch(e){
        emit(ErrorState(e.toString()));
      }
    });


    on<DeleteEvent>((event, emit) async{
      emit(LoadingState());
      print('loading delete');
      try{
        final posts = await _repository.deletePost(event.id, event.index);
        emit(DeleteState(posts));
        print('delete ok');
        emit(LoadedState(posts));
      }catch(e){
        emit(ErrorState(e.toString()));
      }
    });


    on<ColorChangedEvent>((event, emit) async{
      List<Post> posts = event.post;
      if(event.post[event.index].selected==true){
        emit(ChangeBackgroundUnSelectedState(event.post[event.index]));
        posts[event.index].count=1;
        print('ok');
      }else{
        emit(ChangeBackgroundSelectedState(posts));
      }
      posts[event.index].selected=!posts[event.index].selected;
      try{
        emit(LoadedState(posts));

      }catch(e){
        emit(ErrorState(e.toString()));
      }
    });

  }
}

