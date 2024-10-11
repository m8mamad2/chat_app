
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/cubit/theme_cubit.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/constance/lotties.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/chat_button.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/chat_app_bar.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/type_of_item.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:scrollview_observer/scrollview_observer.dart';


class ChatPage extends StatefulWidget {
  final UserModel data;
  const ChatPage({super.key,required this.data});

  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver{

  late TextEditingController _controller;
  late TextEditingController _searchController;
  late bool isEmojiSelected ;
  late bool isSearch;
  late ScrollController scrollController = ScrollController();
  late ListObserverController observerController = ListObserverController(controller: scrollController);
  late FocusNode focusNode;
  late String chatRoomId;
  late ChatRepoBody repo;
  late List<int> searchingComingData;
  MessageModel? replyMessage;
  int searchIndex = 0;
  int limit = 15;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeState>(
      builder: (context, state) {
        if(state is LoadedThemeState){

         return Container(
            width: sizeW(context),
            height: sizeH(context),
            decoration: BoxDecoration(
              image:DecorationImage(image:AssetImage(state.isDark ?? false ? 'assets/image/bg_chat.jpg' : 'assets/image/bg_chat_light.jpg',),fit: BoxFit.cover ),
              color: theme(context).scaffoldBackgroundColor,
            ),
            child: GestureDetector(
              onTap: ()=>FocusScope.of(context).unfocus(),
              child: WillPopScope(
                onWillPop: () {
                  if(isEmojiSelected){
                    setState(() => isEmojiSelected = !isEmojiSelected,);
                    return Future.value(false); }
                  else{ 
                    context.read<ChatBloc>().add(IsOnlineStatusEvent(false));
                    return Future.value(true);}
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: isSearch ? searchingAppbar() : ChatAppBar(data: widget.data,onPress: onPress),
                  body: Column(
                    children: [
        
                      //* caht
                      BlocBuilder<MessagesBloc,MessagesState>(
                        builder: (context, state) {
                          if(state is LoadingMessagesState)return Expanded(child: smallLoading(context));
                          if(state is LoadedMessagesState){
                            List<MessageModel>? messages = state.model;
                            
                            int? lenght = state.limit;
                            if(messages == null ||messages.isEmpty )return Expanded(child: Center(child: startConversitionLottie(context)));
                            return Expanded(
                              child: ListViewObserver(
                                controller: observerController,
                                child: ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemCount: messages.length + 1,
                                  itemBuilder: (context, index){
                                    if(index < messages.length){
                                      return SwipeTo(
                                        onRightSwipe: (details) => reply(messages[index]),
                                        child: GestureDetector(
                                          onTap: () => log(index.toString()),
                                          onDoubleTap: ()async => showDeleteDialg(messages[index].uid),
                                          child: messageItemWidget(context, messages[index],)),
                                      );
                                    }
                                    else {
                                      return 
                                        limit == lenght || lenght! <= limit
                                          ? Center(child: Padding(
                                            padding:const EdgeInsets.symmetric(vertical: 32),
                                            child: Container(
                                              width: sizeW(context)*0.11,
                                              height: sizeH(context)*0.08,
                                              decoration: BoxDecoration(
                                                color: theme(context).primaryColorDark,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(child: Text('start point',style: theme(context).textTheme.bodySmall!.copyWith(color: theme(context).scaffoldBackgroundColor),)),
                                            ),))
                                          : const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 32),
                                            child: Center(child: CircularProgressIndicator(),),
                                            );
                                    }
                                  }
                                ),
                              )
                            );
                          }
                          if(state is FailMessagesState)return Expanded(child: Text(state.error));
                          return Container(width: 100,height: 100,color:Colors.amber);
                        },
                      ),
                      
                      //* button
                      isSearch
                        ? Container(
                          width: sizeW(context),
                          height: sizeH(context)*0.15,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: theme(context).primaryColorDark,width: sizeW(context)*0.001)
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed:(){
                                        observerController.animateTo(index: searchingComingData[searchIndex],curve: Curves.fastOutSlowIn,duration: const Duration(seconds: 1));
                                        setState(()=>searchIndex ++);
                                      } , 
                                      icon:Icon(Icons.arrow_upward,color: theme(context).cardColor,)),
                                    IconButton(onPressed:(){
                                        observerController.animateTo(index: searchingComingData[searchIndex != 0 ? searchIndex - 1 : searchIndex],curve: Curves.fastOutSlowIn,duration: const Duration(seconds: 1));
                                        if(searchIndex != 0) setState(()=>searchIndex --);
                                    } , icon:Icon(Icons.arrow_downward,color: theme(context).cardColor,)),
                                  ],
                                ),
                                Text('$searchIndex of ${searchingComingData.length}',style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).cardColor),)
                              ],
                            ),
                          ),
                          )
                        : ChatButtonsWidget(
                            scrollController: observerController.controller!,
                            receiverId: widget.data.uid!, 
                            chatRoomId: chatRoomId, 
                            isEmojiSelected: isEmojiSelected, 
                            controller: _controller,
                            focusNode:focusNode ,
                            onCancelReply: replyCancel,
                            replayMessage: replyMessage),
        
                    ],
                  )
              ))
            )
          );
        }
        return Container(
          width: sizeW(context),
          height: sizeH(context),
          decoration: BoxDecoration(color: theme(context).scaffoldBackgroundColor,),
          child: FailBlocWidget('Error : Please Try Again'),
        );
      },
    );   
  }

  @override
  void initState() {

    super.initState();
    _controller =  TextEditingController();
    _searchController =  TextEditingController();
    isEmojiSelected = false;
    focusNode = FocusNode();
    
    isSearch = false;
    searchingComingData = [];
    repo = ChatRepoBody();

    WidgetsBinding.instance.addObserver(this);
    context.read<ChatBloc>().add(IsOnlineStatusEvent(true));

    // BlocProvider.of<ChatBloc>(context).add(GetMessageEvent(context: context ,receiverId: widget.data.uid!,limit: limit ));
    BlocProvider.of<MessagesBloc>(context).add(GetInitialMessageeEvent(context: context ,receiverId: widget.data.uid!));

    String currentUserId = ChatRepoBody().currentUserId()!;
    List<String> ids = [currentUserId,widget.data.uid!];
    ids.sort();
    chatRoomId = ids.join('_');

    scrollController.addListener(() => scrollListener());

    log(widget.data.uid.toString());


  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){ context.read<ChatBloc>().add(IsOnlineStatusEvent(true)); }
    else { context.read<ChatBloc>().add(IsOnlineStatusEvent(false)); }
  }
  
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  PreferredSizeWidget searchingAppbar()=> AppBar(
      backgroundColor: theme(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          color: theme(context).primaryColorDark,
          height: sizeH(context)*0.002,
        ),
      ),
      toolbarHeight: sizeH(context)*0.16,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: theme(context).cardColor,),onPressed: onPress,),
      actions: [ _searchController.text.isEmpty ? const SizedBox.shrink() : IconButton(onPressed: ()=>_searchController.clear(), icon: Icon(Icons.clear,color: theme(context).scaffoldBackgroundColor,)) ],
      title: TextField(
        autofocus: true,
        decoration:const InputDecoration(border: InputBorder.none),
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) async {
          Map<List<MessageModel>,List<int>> data = await repo.searching(widget.data.uid!, _searchController.text);
            log(data.entries.first.toString());
            log(data.values.first.toString());

            setState(()=> searchingComingData = data.values.first);
        },
      ),
    );

  showDeleteDialg(String uid)async{
    await showDialog(
      context: context, 
      builder:(context)=> AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Delte Message',style:theme(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Padding(
                      padding:const EdgeInsets.only(bottom: 10),
                      child: Text('Are you sure you want to delete this message?',style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'body'),)),
                    Row(
                      children: [
                        TextButton(
                          onPressed: ()=>context.navigationBack(context), 
                          child: Text('cancel',style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).primaryColorDark),)),
                        TextButton(
                          onPressed: ()async{
                            log('Delete');
                            context.read<ChatBloc>().add(DeleteMessageEvent(uid));
                            context.navigationBack(context);
                          }, 
                          child: Text('Delete',style: theme(context).textTheme.titleSmall!.copyWith(color: Colors.red),)),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
  
  scrollListener()async{
    if(scrollController.hasClients && scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange){
        setState(()=>limit += 7);
        // BlocProvider.of<ChatBloc>(context).add(GetMessageEvent(context: context ,receiverId: widget.data.uid!,limit: limit));
        BlocProvider.of<MessagesBloc>(context).add(GetMessageEvent(context: context ,receiverId: widget.data.uid!,limit: limit));
      }
  }

  reply(MessageModel message){
    // file, image, voice, location
    log(message.type);
    replyMessage = message;
    setState(() {});
    focusNode.requestFocus();
  }
  replyCancel()=>setState(() => replyMessage = null);

  onPress(){
    isSearch = !isSearch;
    searchingComingData.clear();
    _searchController.clear();
    searchIndex = 0;
    setState((){});
  }

}
