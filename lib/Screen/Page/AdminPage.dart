import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos01/bloc/states/stateMenu.dart';

import '../../bloc/blocs/blocMenu.dart';
import '../../bloc/events/eventMenu.dart';
import '../../db/repository.dart';
import '../../model/post.dart';
import 'ShowFromPage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage> {

  String avatar='';
  String name='';
  String type='';
  String price='';

  late PostBloc _bloc;

  Future<bool> _showModalBottomSheet({required BuildContext context, Post? postItem,})async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) =>  SingleChildScrollView(
        child: ShowFrom(onCreateProduct: () {
          this.avatar=avatar;
          this.name=name;
          this.price=price;
          this.type=type;

        },
          bloc: _bloc,
          post: postItem,
        ),
      ),);
    return false;

  }

  @override
  void initState() {
    super.initState();
    _bloc=PostBloc(
      RepositoryProvider.of<Repository>(context),
    )..add(const LoadingEvent(type: 'cafe'));
  }
  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
      create: (context) => _bloc,
      child:
      Scaffold(
        backgroundColor: Colors.white,
        body: DefaultTabController(
          length: 3,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTabBar(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            _showModalBottomSheet(context: context, postItem: null).then((value){
              if(value){
                context.read<PostBloc>().add(AddEvent(
                    avatar,
                    name,
                    type,
                    price));
              }
            });
          },
          icon: const Icon(Icons.add,size: 40,),
          label: const Text('Add',style: TextStyle(fontSize: 30),),
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }

  Widget _itemCafe(){
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state){
        if (state is LoadingState){
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        else if(state is AddState){
          _bloc.add(const LoadingEvent(type: 'cafe'));
        }
        else if(state is UpdateState){
          _bloc.add(const LoadingEvent(type: 'cafe'));
        }
        if (state is LoadedState){
          List<Post> postList = state.posts;
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
              ),
              itemCount: postList.length,
              itemBuilder: (_, index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            postList[index].avatar ?? '',
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return  Image.asset('assets/images/NoImage.png',width: double.infinity,height: 180,);
                            },
                            width: double.infinity,
                            height: 180,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Tên : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].name ?? '',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Loại : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].type ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Giá : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].price ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),

                            ],
                          ),
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        context.read<PostBloc>().add(DeleteEvent( postList[index],
                                            postList[index].id,
                                            index));
                                      },
                                      icon: const Icon(Icons.delete,size: 50)),
                                  const SizedBox(width: 50),
                                  IconButton(
                                      onPressed: () {
                                        _showModalBottomSheet(context: context, postItem: postList[index]);
                                      },
                                      icon: const Icon(Icons.edit,size: 50))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        return Container();
      },
    );
  }
  Widget _itemTea(){
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state){
        if (state is LoadingState){
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        else if(state is AddState){
          _bloc.add(const LoadingEvent(type: 'tea'));
        }
        else if(state is UpdateState){
          _bloc.add(const LoadingEvent(type: 'tea'));
        }
        if (state is LoadedState){
          List<Post> postList = state.posts;
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
              ),
              itemCount: postList.length,
              itemBuilder: (_, index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            postList[index].avatar ?? '',
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return  Image.asset('assets/images/NoImage.png',width: double.infinity,height: 180,);
                            },
                            width: double.infinity,
                            height: 180,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Tên : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].name ?? '',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Loại : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].type ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Giá : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].price ??'',
                                style: const TextStyle(fontSize: 20),
                              ),

                            ],
                          ),
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        context.read<PostBloc>().add(DeleteEvent( postList[index],
                                            postList[index].id,
                                            index));

                                      },
                                      icon: const Icon(Icons.delete,size: 50)),
                                  const SizedBox(width: 50),
                                  IconButton(
                                      onPressed: () {
                                        _showModalBottomSheet(context: context, postItem: postList[index]);
                                      },
                                      icon: const Icon(Icons.edit,size: 50))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        return Container();
      },
    );
  }
  Widget _itemCookie(){
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state){
        if (state is LoadingState){
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        else if(state is AddState){
          _bloc.add(const LoadingEvent(type: 'cookie'));
        }
        else if(state is UpdateState){
          _bloc.add(const LoadingEvent(type: 'cookie'));
        }
        if (state is LoadedState){
          List<Post> postList = state.posts;
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
              ),
              itemCount: postList.length,
              itemBuilder: (_, index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            postList[index].avatar ?? '',
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return  Image.asset('assets/images/NoImage.png',width: double.infinity,height: 180,);
                            },
                            width: double.infinity,
                            height: 180,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Tên : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].name ?? '',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Loại : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].type ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Giá : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].price ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),

                            ],
                          ),
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        context.read<PostBloc>().add(DeleteEvent( postList[index],
                                            postList[index].id,
                                            index));

                                      },
                                      icon: const Icon(Icons.delete,size: 50)),
                                  const SizedBox(width: 50),
                                  IconButton(
                                      onPressed: () {
                                        _showModalBottomSheet(context: context, postItem: postList[index]);
                                      },
                                      icon: const Icon(Icons.edit,size: 50))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        return Container();
      },
    );
  }
  Widget _itemKem(){
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state){
        if (state is LoadingState){
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        else if(state is AddState){
          _bloc.add(const LoadingEvent(type: 'kem'));
        }
        else if(state is UpdateState){
          _bloc.add(const LoadingEvent(type: 'kem'));
        }
        if (state is LoadedState){
          List<Post> postList = state.posts;
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
              ),
              itemCount: postList.length,
              itemBuilder: (_, index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            postList[index].avatar ?? '',
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return  Image.asset('assets/images/NoImage.png',width: double.infinity,height: 180,);
                            },
                            width: double.infinity,
                            height: 180,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Tên : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].name ?? '',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Loại : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].type ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Giá : ',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postList[index].price ?? '',
                                style: const TextStyle(fontSize: 20),
                              ),

                            ],
                          ),
                          Center(
                            child: SizedBox(
                              width: 200,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        context.read<PostBloc>().add(DeleteEvent( postList[index],
                                            postList[index].id,
                                            index));

                                      },
                                      icon: const Icon(Icons.delete,size: 50)),
                                  const SizedBox(width: 50),
                                  IconButton(
                                      onPressed: () {
                                        _showModalBottomSheet(context: context, postItem: postList[index]);
                                      },
                                      icon: const Icon(Icons.edit,size: 50))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        return Container();
      },
    );
  }

  Widget _buildTabBar() {
    return Expanded(
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
             TabBar(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(5),
              unselectedLabelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Colors.orange),
              onTap: (index){
                if(index==0){
                  _bloc.add(const LoadingEvent(type: 'cafe' ));
                }else if(index==1){
                  _bloc.add(const LoadingEvent(type: 'tea' ));
                }else if(index==2){
                  _bloc.add(const LoadingEvent(type: 'cookie'));
                }else if(index==3){
                  _bloc.add(const LoadingEvent(type: 'kem'));
                }
              },
              tabs: const [
                Tab(
                  icon: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.local_cafe,
                        size: 50,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Cà phê',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.local_cafe_sharp,
                        size: 50,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Trà',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.cookie,
                        size: 50,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Bánh',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.icecream,
                        size: 50,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Kem',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _itemCafe(),
                  _itemTea(),
                  _itemCookie(),
                  _itemKem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}


