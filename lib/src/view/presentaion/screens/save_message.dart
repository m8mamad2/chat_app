import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/cubit/theme_cubit.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/cache_image.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/core/widget/photo_view.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';
import 'package:p_4/src/view/data/repo/helper/chat_helper_repo_body.dart';
import 'package:p_4/src/view/domain/usecase/chat_usecase.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/blocs/upload_bloc/upload_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/type_of_item.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../core/common/constance/lotties.dart';
import 'dart:developer';
import 'package:swipe_to/swipe_to.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/chat_button.dart';


class SaveMessageScreen extends StatefulWidget {
  const SaveMessageScreen({super.key,});

  @override
  State<SaveMessageScreen> createState() => _SaveMessageScreenState();
}
class _SaveMessageScreenState extends State<SaveMessageScreen> with WidgetsBindingObserver{

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
  late String currentUserId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeState>(
      builder: (context, state) {
        if(state is LoadedThemeState){
         return Container(
            width: sizeW(context),
            height: sizeH(context),
            decoration: BoxDecoration(
              image:  DecorationImage(image:AssetImage(state.isDark ?? false ? 'assets/image/bg_chat.jpg' : 'assets/image/bg_chat_light.jpg',),fit: BoxFit.cover ),
              color: theme(context).backgroundColor,
            ),
            child: GestureDetector(
              onTap: ()=>FocusScope.of(context).unfocus(),
              child: WillPopScope(
                onWillPop: () {
                  if(isEmojiSelected){
                    setState(() => isEmojiSelected = !isEmojiSelected,);
                    return Future.value(false); }
                  else{ 
                    return Future.value(true);}
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: isSearch ? searchingAppbar() : SaveMessageAppBar(currentUserId: currentUserId,onPress: onPress,),
                  body: Column(
                    children: [
        
                      //* caht
                      BlocBuilder<MessagesBloc,MessagesState>(
                      // BlocBuilder<ChatBloc,ChatState>(
                        builder: (context, state) {
                          if(state is LoadingMessagesState)return Expanded(child: smallLoading(context));
                          if(state is LoadedMessagesState){
                          // if(state is ChatLoadingState)return Expanded(child: smallLoading(context));
                          // if(state is ChatSuccessState ){
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
        
                                        onRightSwipe: (d) => reply(messages[index]),
                                        child: GestureDetector(
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
                                                gradient: LinearGradient(
                                                  colors: [
                                                    theme(context).primaryColorDark.withOpacity(0.7),
                                                    theme(context).primaryColorDark.withOpacity(0.7),
                                                    theme(context).primaryColorDark.withOpacity(0.2),
                                                  ]
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Center(child: Text('start point',style: theme(context).textTheme.bodySmall!.copyWith(color: theme(context).backgroundColor),)),
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
                          receiverId: currentUserId, 
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
          decoration: BoxDecoration(color: theme(context).backgroundColor,),
          child: FailBlocWidget('Error : Please Try Again'),
        );
      
      },
    );   
  }

  @override
  void initState() {

    super.initState();
    currentUserId = ChatRepoBody().currentUserId()!;
    _controller =  TextEditingController();
    _searchController =  TextEditingController();
    isEmojiSelected = false;
    focusNode = FocusNode();
    
    isSearch = false;
    searchingComingData = [];
    repo = ChatRepoBody();

    List<String> ids = [currentUserId,currentUserId];
    ids.sort();
    chatRoomId = ids.join('_');

    WidgetsBinding.instance.addObserver(this);
    context.read<ChatBloc>().add(IsOnlineStatusEvent(true));

    BlocProvider.of<MessagesBloc>(context).add(GetInitialMessageeEvent(context: context ,receiverId: currentUserId));


    scrollController.addListener(() => scrollListener());
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  PreferredSizeWidget searchingAppbar()=> AppBar(
      backgroundColor: theme(context).backgroundColor,
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
      actions: [ _searchController.text.isEmpty ? const SizedBox.shrink() : IconButton(onPressed: ()=>_searchController.clear(), icon: Icon(Icons.clear,color: theme(context).backgroundColor,)) ],
      title: TextField(
        autofocus: true,
        decoration:const InputDecoration(border: InputBorder.none),
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) async {
          Map<List<MessageModel>,List<int>> data = await repo.searching(currentUserId, _searchController.text);
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
        BlocProvider.of<MessagesBloc>(context).add(GetMessageEvent(context: context ,receiverId: currentUserId,limit: limit));
      }
  }

  reply(MessageModel message){
    replyMessage = message;
    log(message.messsage);
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




class AppBarSaveMessage extends StatefulWidget {
  final String currentUserId;
  const AppBarSaveMessage({super.key,required this.currentUserId});
  @override
  State<AppBarSaveMessage> createState() => AppBarSaveMessageState();
}
class AppBarSaveMessageState extends State<AppBarSaveMessage> {
  ChatUseCase repo = ChatUseCase(ChatHelperRepoBody(ChatRepoBody()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: theme(context).backgroundColor,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: theme(context).cardColor,),onPressed: ()=>context.navigationBack(context),),
      elevation: 0,
      foregroundColor: theme(context).backgroundColor,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          color: theme(context).primaryColorDark,
          height: sizeH(context)*0.002,
        ),
      ),
      title: InkWell(
        child: Row(
          children: [ 
            CircleAvatar(radius: sizeW(context)*0.03,backgroundColor: theme(context).primaryColorDark,child: Icon(Icons.save_outlined,color: theme(context).backgroundColor,),),
            sizeBoxW(sizeW(context)*0.013),
            Text('Save Messages'..tr(),style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).cardColor,fontSize: sizeW(context)*0.02,fontFamily: 'header')),
          ],
        ),
      )
    ),
      body: Column(
        children: [
          sizeBoxH(sizeH(context)*0.03),
          Expanded(
            child:  DefaultTabController(
            initialIndex: 0,
            length: 2,  
            child: Scaffold(
              backgroundColor: theme(context).backgroundColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(sizeH(context)*0.3),
                child: TabBar(
                  indicatorColor: theme(context).primaryColorDark,
                  indicatorWeight: sizeW(context)*0.002,
                  tabs: [
                    Tab(icon: Icon(Icons.chat,color: theme(context).cardColor,),),
                    Tab(icon: Icon(Icons.group,color: theme(context).cardColor,),),
                  ])) ,
              body: TabBarView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.02),
                      child: FutureBuilder(
                        future: repo.getImageMessage(context,widget.currentUserId),
                        builder: (context, snapshot) {
                          switch(snapshot.connectionState){
                            case ConnectionState.none:
                            case ConnectionState.waiting:return smallLoading(context);
                            default:
                              if(snapshot.data == null || snapshot.data!.isEmpty) return Center(child: Text('Empty'.tr()),);
                              return GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () => context.navigation(context, PhotoViewWidget(image: snapshot.data![index]!.messsage)),
                                  child: cachedImageWidget(context,snapshot.data![index]!.messsage,null,null)),
                                );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.02),
                      child: FutureBuilder(
                        future: repo.getFileMessage(context,widget.currentUserId),
                        builder: (context, snapshot) {
                          switch(snapshot.connectionState){
                            case ConnectionState.none:
                            case ConnectionState.waiting:return smallLoading(context);
                            default:
                              if(snapshot.data == null || snapshot.data!.isEmpty) return const Center(child: Text('Empty'),);
                              return ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  thickness: 0.4,
                                  indent: sizeW(context)*0.1,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => ListTile(
                                  leading: CircleAvatar(radius: sizeW(context)*0.04,backgroundColor: theme(context).primaryColorDark,child: Icon(Icons.insert_drive_file_outlined,color: theme(context).backgroundColor,),),
                                  onTap: ()=>context.read<UploadBloc>().add(DownloadFileEvent(snapshot.data![index]!.messsage,snapshot.data![index]!.fileType!,snapshot.data![index]!.uid)),
                                  title:BlocBuilder<UploadBloc,UploadState>(
                                    builder: (context, state) {
                                      if(state is UploadInitialState)return const Text('initial File');
                                      if(state is UploadLoadingState)return const Text('Loading');
                                      if(state is UploadSuccessState){
                                      return FutureBuilder(
                                        future: state.downlaodFile,
                                        builder: (context, snapshot) {
                                          switch(snapshot.connectionState){
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:return smallLoading(context);
                                            default:
                                              return snapshot.data == null 
                                                ? const Text('File')
                                                : const Text('File');
                                          }
                                        },);
                                      }
                                      if(state is UploadFailState)return const Text('Fail');
                                      return const Text('File');
                                    },
                                  ),
                                ),
                                );
                          }
                        },
                      ),
                    ),
                  ])
              )
            ))
        ],
      ),
    );
  }
}


class SaveMessageAppBar extends StatefulWidget implements PreferredSizeWidget{
  final double height;
  final String currentUserId;
  // bool isSearch;
  final VoidCallback onPress;
  const SaveMessageAppBar({super.key,this.height = kToolbarHeight,
  // required this.isSearch,
  required this.onPress,
  required this.currentUserId
  });

  @override
  State<SaveMessageAppBar> createState() => _SaveMessageAppBarState();
  
  @override
  Size get preferredSize => Size.fromHeight(height);
}
class _SaveMessageAppBarState extends State<SaveMessageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: theme(context).backgroundColor,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: theme(context).cardColor,),onPressed: ()=>context.navigationBack(context),),
      elevation: 0,
      foregroundColor: theme(context).backgroundColor,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          color: theme(context).primaryColorDark,
          height: sizeH(context)*0.002,
        ),
      ),
      actions: [ IconButton(onPressed: widget.onPress,icon: Icon(Icons.search,color: theme(context).cardColor,)) ], 
      title: InkWell(
        onTap: ()=> context.navigation(context, AppBarSaveMessage(currentUserId: widget.currentUserId,)),
        child: Row(
          children: [ 
            CircleAvatar(radius: sizeW(context)*0.03,backgroundColor: theme(context).primaryColorDark,child: Icon(Icons.save_outlined,color: theme(context).backgroundColor,),),
            sizeBoxW(sizeW(context)*0.013),
            Text('Save Messages',style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).cardColor,fontSize: sizeW(context)*0.02,fontFamily: 'header')),
          ],
        ),
      )
    );
  }
}


