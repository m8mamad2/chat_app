// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'dart:io';
import 'package:p_4/src/view/presentaion/blocs/upload_bloc/upload_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/location_send.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/type_of_item.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../../../core/common/constance/lotties.dart';
import '../widget/chat_widget/chat_emoji_picker.dart';


class SaveMessageScreen extends StatefulWidget {

  const SaveMessageScreen({super.key});

  @override
  State<SaveMessageScreen> createState() => _SaveMessageScreenScreenState();
}
class _SaveMessageScreenScreenState extends State<SaveMessageScreen> with WidgetsBindingObserver{
  
  late TextEditingController _controller;
  late TextEditingController _searchController;
  late bool isEmojiSelected ;
  late bool isSearch;
  late ScrollController scrollController;
  late ListObserverController observerController;
  late String chatRoomId;
  int searchIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeW(context),
      height: sizeH(context),
      color: theme(context).backgroundColor,
      child: BlocBuilder<ChatBloc,ChatState>(
        builder: (context, state) {
          if(state is ChatLoadingState)return loading(context);
          if(state is ChatSuccessState){
            return GestureDetector(
                onTap: ()=>FocusScope.of(context).unfocus(),
                child: WillPopScope(
                  onWillPop: () {
                    if(isEmojiSelected){
                      setState(() => isEmojiSelected = !isEmojiSelected,);
                      return Future.value(false); }
                    else{ return Future.value(true);}
                  },
                  child: Scaffold(
                    appBar: isSearch ? searchingAppbar() : SaveMessageAppBar(onPress: onPress,currentUserId: currentUserId),
                    body: Column(
                      children: [
                        //* chat
                        Expanded(
                          child: StreamBuilder(
                            stream: state.messages,
                            builder: (context, snapshot) {
                              switch(snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.waiting:return loading(context);
                                case ConnectionState.active:
                                default:
                                  if(snapshot.data == null){return startConversitionLottie(context);}
                                  else{
                                    List<MessageModel> messages = snapshot.data!.reversed.toList();
                                    return ListViewObserver(
                                      controller: observerController,
                                      child: ListView.builder(
                                        controller: scrollController,
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: messages.length,
                                        itemBuilder: (context, index){
                                          return GestureDetector(
                                            onTap: () => log('in ListView -> $index'),
                                            onDoubleTap: ()async => showDeleteDialg(messages[index].uid),
                                            child: messageItemWidget(context, messages[index],));}),
                                    );}
                              }
                            },
                          )),
                        
                        //* button
                        isSearch
                         ? Container(
                            width: sizeW(context),
                            height: sizeH(context)*0.15,
                            decoration: BoxDecoration(border: Border(top: BorderSide(color: theme(context).primaryColor,width: sizeW(context)*0.001)),),
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
                         : SaveMessageButtonsWidget(
                            scrollController: observerController.controller!,
                            receiverId: currentUserId, 
                            chatRoomId: chatRoomId, 
                            isEmojiSelected: isEmojiSelected, 
                            controller: _controller),

                      ],
                    )
                ))
              );
          }
          if(state is ChatFailState)return FailBlocWidget(state.error);
          return const SizedBox.shrink();
        },
      
      ),
    );
    
  }

  onPress(){
    isSearch = !isSearch;
    searchingComingData.clear();
    _searchController.clear();
    searchIndex = 0;
    setState((){});
  }

  @override
  void initState() {

    super.initState();
    _controller =  TextEditingController();
    _searchController =  TextEditingController();
    isEmojiSelected = false;

    isSearch = false;
    searchingComingData = [];
    repo = ChatRepoBody();

    WidgetsBinding.instance.addObserver(this);
    context.read<ChatBloc>().add(IsOnlineStatusEvent(true));


    currentUserId = ChatRepoBody().currentUserId()!;
    BlocProvider.of<ChatBloc>(context).add(GetMessageEvent(context: context,receiverId: currentUserId));
    List<String> ids = [currentUserId,currentUserId];
    ids.sort();
    chatRoomId = ids.join('_');

    scrollController = ScrollController();
    observerController = ListObserverController(controller: scrollController);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){ context.read<ChatBloc>().add(IsOnlineStatusEvent(true)); }
    else { context.read<ChatBloc>().add(IsOnlineStatusEvent(false)); }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late ChatRepoBody repo;
  late List<int> searchingComingData;
  late String currentUserId;

  PreferredSizeWidget searchingAppbar()=> AppBar(
      backgroundColor: theme(context).backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          color: theme(context).primaryColor,
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
                          child: Text('cancel',style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).primaryColor),)),
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
          color: theme(context).primaryColor,
          height: sizeH(context)*0.002,
        ),
      ),
      actions: [ IconButton(onPressed: widget.onPress,icon: Icon(Icons.search,color: theme(context).cardColor,)) ], 
      title: InkWell(
        onTap: ()=> context.navigation(context, AppBarSaveMessage(currentUserId: widget.currentUserId,)),
        child: Row(
          children: [ 
            CircleAvatar(radius: sizeW(context)*0.03,backgroundColor: theme(context).primaryColor,child: Icon(Icons.save_outlined,color: theme(context).backgroundColor,),),
            sizeBoxW(sizeW(context)*0.013),
            Text('Save Messages',style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).cardColor,fontSize: sizeW(context)*0.02,fontFamily: 'header')),
          ],
        ),
      )
    );
  }
}



class SaveMessageButtonsWidget extends StatefulWidget {
  final ScrollController scrollController;
  final String receiverId;
  final String chatRoomId;
  bool isEmojiSelected;
  TextEditingController controller;
  SaveMessageButtonsWidget({super.key,required this.scrollController
,required this.receiverId,required this.chatRoomId,required this.isEmojiSelected,required this.controller});

  @override
  State<SaveMessageButtonsWidget> createState() => _SaveMessageButtonsWidgetState();
}
class _SaveMessageButtonsWidgetState extends State<SaveMessageButtonsWidget> {

  Widget oneItemBottomShet(IconData icon,String title,VoidCallback event)=> Padding(
    padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.015),
    child: GestureDetector(
      onTap: event,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: sizeW(context)*0.04,
              backgroundColor: theme(context).primaryColor,
              child: Icon(icon,color: theme(context).backgroundColor,),
          ),
          sizeBoxH(sizeH(context)*0.015),
          Text(title,style: TextStyle(color: theme(context).primaryColor),)
        ],
      ),
    ),
  );
  
  late bool isEmojiSelected;
  final FocusNode focusNode = FocusNode();
  bool isSendButton = false;
  late List kBottomShetEvent;

  @override
  void initState() {
    super.initState();
    isEmojiSelected = widget.isEmojiSelected;
    kBottomShetEvent = [
     ()=> context.read<UploadBloc>().add(UploadMediaEvent(widget.receiverId, widget.chatRoomId,null)),
     ()=> context.read<UploadBloc>().add(UploadFileEvent(widget.receiverId, widget.chatRoomId,null)),
     ()=> context.navigation(context, LocationSendWidget(receiverId: widget.receiverId,)),
    ];
  }

  @override
  void dispose() {
    audioRecord.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [

       //* button
      isRecording 
          ? Container(
            width: sizeW(context),
            height: sizeH(context)*0.15,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme(context).primaryColor,width: sizeW(context)*0.001)),
              color: theme(context).backgroundColor,
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: sizeW(context)*0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_result,style: TextStyle(color: theme(context).cardColor),),
                  IconButton(
                    onPressed: () async {setState(()=> isRecording = false);await stopRecording(widget.receiverId);}, 
                    icon: Icon(Icons.stop,color: theme(context).cardColor,))
                ],
              ),
            ),
          )
          : Container(
            width: sizeW(context),
            height: sizeH(context)*0.15,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme(context).primaryColor,width: sizeW(context)*0.001)),
              color: theme(context).backgroundColor,
            ),
            child: Row(
            children: [
              IconButton(
                onPressed: ()async {
                  FocusScope.of(context).unfocus();
                  isEmojiSelected = !isEmojiSelected;
                  setState(() { });  
                },
                icon:Icon(isEmojiSelected ? Icons.keyboard : Icons.emoji_emotions,color: theme(context).cardColor,)),
              Expanded(
                child:TextFormField(
                  focusNode: focusNode,
                  controller: widget.controller, 
                  onChanged: (value) => widget.controller.text.isNotEmpty ? setState(() => isSendButton = true) : setState(() => isSendButton = false),
                  onTap: () {
                    isEmojiSelected ? setState(() => isEmojiSelected = !isEmojiSelected,) : null;
                    
                    widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
                    // Timer(const Duration(milliseconds: 500),()=>scrollController.jumpTo(scrollController.position.maxScrollExtent));
                  },
                  decoration: InputDecoration( border: InputBorder.none,hintText: 'Enter message',hintStyle: TextStyle(color: theme(context).cardColor) ),
                  )),
              isSendButton 
                ? IconButton(onPressed: ()async{
                    if(widget.controller.text.isNotEmpty) {
                      context.read<ChatBloc>().add(SendMessageEvent(receiverId: widget.receiverId, message: widget.controller.text,replyMessage: null));
                      widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
                      widget.controller.clear();
                    }
                  }, 
                    icon:  Icon(Icons.send,color: theme(context).cardColor))
                : Row(children: [
                    IconButton(
                      onPressed: ()=> showBottomSheet(
                        context: context, 
                        builder: (context) => Container(
                          width: sizeW(context),
                          height: sizeH(context)*0.4,
                          padding: EdgeInsets.only(left: sizeW(context)*0.08),
                          decoration: BoxDecoration(
                            color:  theme(context).backgroundColor,
                            border: Border(top: BorderSide(color: theme(context).primaryColor,width: sizeW(context)*0.002)),
                          ),
                          child:ListView.builder(
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => oneItemBottomShet(kBottomShetIcon[index],kBottomShetTitle[index],kBottomShetEvent[index]),)
                      ),
                    ),
                    icon: Icon(Icons.perm_media_outlined,color: theme(context).cardColor,)),
                    IconButton(onPressed: ()async {
                      await startRecording();
                      setState(() => isRecording = true );
                    }, 
                    icon:  Icon(Icons.mic,color: theme(context).cardColor)),
                  ],)
              ],
            ),
          ),

      if(isEmojiSelected) ChatEmojiPickerWidget(controller: widget.controller)
                
     ],
   );
  }








  //! recording voice
  final Stopwatch stopwatch = Stopwatch();
  final Record audioRecord = Record();
  bool isRecording = false;
  late final Timer _timer;
  String _result = '00:00';
  
  //! methos for recording and playing voide
  Future<void> startRecording()async{
    try{
      if(await audioRecord.hasPermission()){
        String path = await getDir();
        await audioRecord.start(path: path);
        start();
      }
    }
    catch(e){ print('----Recordign Start Error : $e');}
  }
  
  Future<void> stopRecording(String receiverId,)async{
    try{
      String? path = await audioRecord.stop();
      stop();
      // await repo.uploadVoice(receiverId, path!).then((value) => print('_____AFter uplaod VOice'));
      context.read<UploadBloc>().add(UploadVoiceEvent(receiverId,path!,widget.chatRoomId,null));
    }
    catch(e){ print('in Stop VOice Error = $e');}
  }
  
  Future<String> getDir()async{
    final Directory? dir = await getExternalStorageDirectory();
    final String path = '${dir!.path}/${const Uuid().v1()}.m4a';
    return path;
  }
  
  start(){
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _result = '${stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });
    stopwatch.start();
  }
  
  stop(){
    _timer.cancel();
    stopwatch.stop();
    stopwatch.reset();
  }

}

List<IconData> kBottomShetIcon = [Icons.perm_media_outlined,Icons.file_copy_outlined,Icons.location_on_outlined];
List<String> kBottomShetTitle  = ['Media','Files','Location'];
// IconButton(onPressed: ()async => context.read<UploadBloc>().add(UploadMediaEvent(widget.receiverId,widget.chatRoomId)), icon:const Icon(Icons.image,color: Colors.white)),
// IconButton(onPressed: ()async => context.read<UploadBloc>().add(UploadFileEvent(widget.receiverId,widget.chatRoomId)), icon: const Icon(Icons.file_copy,color: Colors.white)),
                    



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
          color: theme(context).primaryColor,
          height: sizeH(context)*0.002,
        ),
      ),
      title: InkWell(
        child: Row(
          children: [ 
            CircleAvatar(radius: sizeW(context)*0.03,backgroundColor: theme(context).primaryColor,child: Icon(Icons.save_outlined,color: theme(context).backgroundColor,),),
            sizeBoxW(sizeW(context)*0.013),
            Text('Save Messages',style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).cardColor,fontSize: sizeW(context)*0.02,fontFamily: 'header')),
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
                  indicatorColor: theme(context).primaryColor,
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
                              if(snapshot.data == null || snapshot.data!.isEmpty) return const Center(child: Text('Empty'),);
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
                                  leading: CircleAvatar(radius: sizeW(context)*0.04,backgroundColor: theme(context).primaryColor,child: Icon(Icons.insert_drive_file_outlined,color: theme(context).backgroundColor,),),
                                  onTap: ()=>context.read<UploadBloc>().add(DownloadFileEvent(snapshot.data![index]!.messsage,snapshot.data![index]!.fileType!,snapshot.data![index]!.uid)),
                                  title:BlocBuilder<UploadBloc,UploadState>(
                                    builder: (context, state) {
                                      if(state is UploadInitialState)return const Text('initial File');
                                      if(state is UploadLoadingState)return const Text('Loading');
                                      if(state is UploadSuccessState){
                                      return StreamBuilder(
                                        stream: state.downlaodFile!.asBroadcastStream(),
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


