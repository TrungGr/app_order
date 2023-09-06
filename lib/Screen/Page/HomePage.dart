import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos01/bloc/events/eventOrder.dart';

import '../../bloc/blocs/blocMenu.dart';
import '../../bloc/blocs/blocOrder.dart';
import '../../bloc/events/eventMenu.dart';
import '../../bloc/states/stateMenu.dart';
import '../../bloc/states/stateOrder.dart';
import '../../db/repository.dart';
import '../../model/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late PostBloc _bloc;
  late OrderBloc _orderBloc;

  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _bloc = PostBloc(
      RepositoryProvider.of<Repository>(context),
    )..add(const LoadingEvent(type: 'cafe'));
    _orderBloc = OrderBloc();

  }

  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
        providers: [
          RepositoryProvider(
            create: (BuildContext context) => _bloc,
          ),
          BlocProvider(
            create: (BuildContext context) => _orderBloc,
          ),
        ],
        child:
      GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Row(
      children: [
        Expanded(flex: 28, child: _buildHome()),
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
            )),
        Expanded(flex: 10, child: _buildBill()),
      ],
    );
  }

  Widget _bill() {
    return BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state){
          if( state is LoadingOrderState){
          }
          if( state is LoadedOrderState){
            List<Post> postList = state.posts;
            return ListView.builder(
              itemCount: postList.length,
                itemBuilder: (_, index){
                return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                        border: Border.all(
                          color: Colors.orange,
                          width: 2,
                        )
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          postList[index].avatar ?? '',
                          errorBuilder: (BuildContext context,
                              Object exception, StackTrace? stackTrace) {
                            return  Image.asset('assets/images/NoImage.png',width: 90,height: 90,);
                          },
                          width: 90,
                          height: 90,
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Tên : ',
                                    style:
                                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    postList[index].name ?? '',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text(
                                    'Giá : ',
                                    style:
                                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    postList[index].price ?? '',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _orderBloc.add(DecrementEvent(postList,index));
                                      },
                                      icon: Image.asset('assets/icons/minus.png',
                                        width: 20,
                                        height: 20,
                                        color: Colors.orange,
                                      )),
                                  Text(
                                    ' ${postList[index].count}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _orderBloc.add(IncrementEvent(postList,index));
                                      },
                                      icon: Image.asset('assets/icons/plus.png',
                                        width: 23,
                                        height: 23,
                                        color: Colors.orange,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                );
              });
          }
          return Container();
        },
    );
  }
  Widget _itemCafe(){
    return BlocConsumer<PostBloc, PostState>(
        listener: (context,PostState state) {
          if(state is ChangeBackgroundSelectedState){
            _orderBloc.add(AddBillEvent(state.posts.where((element) => element.selected).toList()),
            );
          }else if(state is ChangeBackgroundUnSelectedState){
            _orderBloc.add(RemoveBillEvent(state.post));
          }
        },
      builder: (context, state){
        if (state is LoadingState){
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        if (state is LoadedState){
          List<Post> postList = state.posts;
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
              ),
              itemCount: postList.length,
              itemBuilder: (_, index){
                return InkWell(
                  onTap: (){
                   _bloc.add(ColorChangedEvent(index, postList));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      border: Border.all(
                        color:
                        postList[index].selected? Colors.orange : Colors.white,
                        width: 2,
                      ),
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
                                return  Image.asset('assets/images/NoImage.png',width: double.infinity,height: 135,);
                              },
                              width: double.infinity,
                              height: 135,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Tên : ',
                                  style: TextStyle(
                                      fontSize: 20,
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
                                      fontSize: 20,
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  postList[index].price ?? '',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    return BlocConsumer<PostBloc, PostState>(
      listener: (context,PostState state) {
        if(state is ChangeBackgroundSelectedState){
          _orderBloc.add(AddBillEvent(state.posts.where((element) => element.selected).toList()),
          );
        }else if(state is ChangeBackgroundUnSelectedState){
          _orderBloc.add(RemoveBillEvent(state.post));
        }
      },
      builder: (context, state){
        if (state is LoadingState){
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        else if(state is ChangeBackgroundSelectedState){
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
                      border: Border.all(
                        color: postList[index].selected? Colors.orange : Colors.white,
                        width: 2,
                      )
                  ),
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: (){
                      _bloc.add(ColorChangedEvent(index, postList));

                    },
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
                                return  Image.asset('assets/images/NoImage.png',width: double.infinity,height: 135,);
                              },
                              width: double.infinity,
                              height: 135,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Tên : ',
                                  style: TextStyle(
                                      fontSize: 20,
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
                                      fontSize: 20,
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  postList[index].price ?? '',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    return BlocConsumer<PostBloc, PostState>(
      listener: (context,PostState state) {
        if(state is ChangeBackgroundSelectedState){
          _orderBloc.add(AddBillEvent(state.posts.where((element) => element.selected).toList()),
          );
        }else if(state is ChangeBackgroundUnSelectedState){
          _orderBloc.add(RemoveBillEvent(state.post));
        }
      },
      builder: (context, state){
        if (state is LoadingState){
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        else if(state is ChangeBackgroundSelectedState){
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
                      border: Border.all(
                        color: postList[index].selected? Colors.orange : Colors.white,
                        width: 2,
                      )
                  ),
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: (){
                      _bloc.add(ColorChangedEvent(index, postList));
                    },
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
                                return  Image.asset('assets/images/NoImage.png',width: double.infinity,height: 135,);
                              },
                              width: double.infinity,
                              height: 135,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Tên : ',
                                  style: TextStyle(
                                      fontSize: 20,
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
                                      fontSize: 20,
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  postList[index].price ?? '',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    return BlocConsumer<PostBloc, PostState>(
      listener: (context,PostState state) {
        if(state is ChangeBackgroundSelectedState){
          _orderBloc.add(AddBillEvent(state.posts.where((element) => element.selected).toList()),
          );
        }else if(state is ChangeBackgroundUnSelectedState){
          _orderBloc.add(RemoveBillEvent(state.post));
        }
      },
      builder: (context, state){
        if (state is LoadingState){
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }
        else if(state is ChangeBackgroundSelectedState){
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
                      border: Border.all(
                        color: postList[index].selected? Colors.orange : Colors.white,
                        width: 2,
                      )
                  ),
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: (){
                      _bloc.add(ColorChangedEvent(index, postList));
                    },
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
                                return  Image.asset('assets/images/NoImage.png',width: double.infinity,height: 135,);
                              },
                              width: double.infinity,
                              height: 135,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Tên : ',
                                  style: TextStyle(
                                      fontSize: 20,
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
                                      fontSize: 20,
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  postList[index].price ?? '',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
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
  Widget _oderBill(){
    return Container(
      padding: const EdgeInsets.only(left: 3, right: 3),
      decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
          color: Colors.white),
      child: _bill()
    );
  }
  Widget _countMoney(){
    return BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if( state is LoadingOrderState){
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        Text(
                          '0.00',
                          style: TextStyle(fontSize: 20),),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount sales',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        Text('0.00',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total sales tax',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        Text('0.00',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 2,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        Text('0.00',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                        primary: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.print, size: 20),
                          SizedBox(width: 20),
                          Text(
                            'Print Bills',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if( state is LoadedOrderState){
            var total = 0.0;
            for(var post in state.posts){
              total += double.parse(post.price!)* post.count;
            }
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        Text(
                          '${total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20),),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text('Discount sales',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        Text('0.00',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text('Total sales tax',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        Text('0.00',
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 2,
                      width: double.infinity,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        Text('${total.toStringAsFixed(2)}',style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                        primary: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.print, size: 20),
                          SizedBox(width: 20),
                          Text(
                            'Print Bills',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          // );
         }
          return Container();
          },
    );
  }
  Widget _buildHome() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.black12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 10),
            _buildTabBar(),
          ],
        ),
      ),
    );
  }
  Widget _buildTitle() {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const Column(
                children: [
                  Text('Welcome, Gorry',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                    'Discover whatever you need easily',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              const SizedBox(
                width: 320,
                height: 40,
                child: TextField(
                  cursorColor: Colors.orange,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      hintText: 'Tìm kiếm...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      prefixIcon: Icon(Icons.search),
                      focusColor: Colors.orange),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    size: 30,
                  ))
            ],
          ),
        ],
      ),
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
              onTap: (index) {
                if (index == 0) {
                  _bloc.add(const LoadingEvent(type: 'cafe'));
                } else if (index == 1) {
                  _bloc.add(const LoadingEvent(type: 'tea'));
                } else if (index == 2) {
                  _bloc.add(const LoadingEvent(type: 'cookie'));
                } else if (index == 3) {
                  _bloc.add(const LoadingEvent(type: 'kem'));
                }
              },
              tabs: const [
                Tab(
                  icon: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.local_cafe,
                        size: 35,
                      ),
                      SizedBox(
                        width: 10,
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
                        width: 10,
                      ),
                      Icon(
                        Icons.local_cafe_sharp,
                        size: 35,
                      ),
                      SizedBox(
                        width: 10,
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
                        width: 10,
                      ),
                      Icon(
                        Icons.cookie,
                        size: 35,
                      ),
                      SizedBox(
                        width: 10,
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
                        width: 10,
                      ),
                      Icon(
                        Icons.icecream,
                        size: 35,
                      ),
                      SizedBox(
                        width: 10,
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
  Widget _buildBill() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Current Order',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.settings)),
              ),
            ],
          ),
          Expanded(
            flex: 3,
            child: _oderBill()),
          const SizedBox(height: 5),
          Expanded(
              flex: 2,
              child: _countMoney()
          ),
        ],
      ),
    );
  }
}
