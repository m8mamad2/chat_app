// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/constance/lotties.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/upload_bloc/upload_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/type_of_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import '../../data/model/create_group_model.dart';
import 'dart:developer';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/group_button_widget.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../widget/chat_widget/group_app_bar.dart';



// class GroupScreen extends StatefulWidget {
//   final CreateGroupModel groupModel;
//   const GroupScreen({super.key,required this.groupModel});

//   @override
//   State<GroupScreen> createState() => _GroupScreenState();
// }
// class _GroupScreenState extends State<GroupScreen> with WidgetsBindingObserver{

//   final Stopwatch stopwatch = Stopwatch();
//   final Record audioRecord = Record();
//   bool isRecording = false;
//   late final Timer _timer;
//   String _result = '0:0';
  
//   Future<void> startRecording()async{
//     try{
//       if(await audioRecord.hasPermission()){
//         String path = await getDir();
//         await audioRecord.start(path: path);
//         start();
//       }
//     }
//     catch(e){ print('----Recordign Start Error : $e');}
//   }
  
//   Future<void> stopRecording(String groupUid,)async{
//     try{
//       String? path = await audioRecord.stop();
//       stop();
//       context.read<UploadBloc>().add(UploadVoiceEvent(chatRoomId,path!,chatRoomId));
//     }
//     catch(e){ print('in Stop VOice Error = $e');}
//   }
  
//   Future<String> getDir()async{
//     final Directory? dir = await getExternalStorageDirectory();
//     final String path = '${dir!.path}/${const Uuid().v1()}.m4a';
//     return path;
//   }
  
//   start(){
//     _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
//       setState(() {
//         _result = '${stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
//       });
//     });
//     stopwatch.start();
//   }
  
//   stop(){
//     _timer.cancel();
//     stopwatch.stop();
//     stopwatch.reset();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: ()=>FocusScope.of(context).unfocus(),
//       child: WillPopScope(
//         onWillPop: () {
//           if(isEmojiSelected){
//             setState(() => isEmojiSelected = !isEmojiSelected,);
//             return Future.value(false);
//           }
//           else{ return Future.value(true);}
//         },
//         child: Scaffold(
//           // appBar: chatAppBar(widget.groupModel,context),
//           body: BlocBuilder<GroupBloc,GroupState>(
//             builder: (context, state) {
//               if(state is GroupLoadingState)return loading();
//               if(state is GroupSuccessState){
//                 return Column(
//                 children: [
          
//                   //* chat
//                   Expanded(
//                     child: StreamBuilder(
//                       stream: state.messages,
//                       builder: (context, snapshot) {
//                         switch(snapshot.connectionState){
//                           case ConnectionState.none:
//                           case ConnectionState.waiting:
//                           case ConnectionState.active:
//                           default:
//                             if(snapshot.data == null){return const Text('Start');}
//                             else{
//                               List<MessageModel> messages = snapshot.data!;
//                               return ListView.builder(
//                                 shrinkWrap: true,
//                                 controller: scrollController,
//                                 itemCount: messages.length,
//                                 itemBuilder: (context, index) {
//                                   return GestureDetector(
//                                     // onDoubleTap: ()async => context.read<GroupBloc>().add(DeleteMessageEvent(messages[index].uid)),
//                                     child: messageItemWidget(context, messages[index],));});}
//                         }
//                       },
//                     )),
                  
//                   //* buttons
//                   isRecording 
//                     ? Container(
//                       width: sizeW(context),
//                       height: sizeH(context)*0.14,
//                       color: Colors.green.shade200,
//                       child: Row(
//                         children: [
//                           Text(_result),
//                           IconButton(
//                             onPressed: () async {
//                               setState(()=> isRecording = false);
//                               await stopRecording(chatRoomId);
//                             }, 
//                             icon: const Icon(Icons.stop))
//                         ],
//                       ),
//                     )
//                     : Container(
//                       width: sizeW(context),
//                       height: sizeH(context)*0.14,
//                       color: Colors.grey.shade300,
//                       child: Row(
//                       children: [
//                         IconButton(
//                           onPressed: ()async {
//                             // isEmojiSelected ? focusNode.requestFocus() : FocusScope.of(context).unfocus() ;
//                             FocusScope.of(context).unfocus();
//                             isEmojiSelected = !isEmojiSelected;
//                             setState(() { });  
//                           },
//                           icon:Icon(isEmojiSelected ? Icons.keyboard : Icons.emoji_emotions)),
//                         Expanded(
//                           child:TextFormField(
//                             focusNode: focusNode,
//                             controller: _controller, 
//                             onTap: () {
//                               isEmojiSelected ? setState(() => isEmojiSelected = !isEmojiSelected,) : null;
//                               Timer(const Duration(milliseconds: 500),()=>scrollController.jumpTo(scrollController.position.maxScrollExtent));
                              
//                             },
//                             decoration: const InputDecoration( hintText: 'Enter message', ),
//                             )),
//                         IconButton(onPressed: ()async{
//                           if(_controller.text.isNotEmpty) {
// context.read<GroupBloc>().add(
// SendGroupMessageEvent(
// message: _controller.text,
// groupUid: chatRoomId));
//                             _controller.clear();
//                           }
//                         }, 
//                           icon: const Icon(Icons.send)),
//                         IconButton(onPressed: ()async => context.read<UploadBloc>().add(UploadMediaEvent(chatRoomId,chatRoomId)), icon:const Icon(Icons.image)),
//                         IconButton(onPressed: ()async => context.read<UploadBloc>().add(UploadFileEvent(chatRoomId,chatRoomId)), icon:const Icon(Icons.file_copy)),
//                         IconButton(onPressed: ()async {
//                           await startRecording();
//                           setState(() => isRecording = true );
//                         }, icon:const Icon(Icons.mic)),
//                         ],
//                       ),
//                     ),
                    
//                   //* emoji
//                   if(isEmojiSelected) SizedBox(
//                     height: 250,
//                     child: EmojiPicker(
//                       textEditingController: _controller,
//                       onBackspacePressed: (){},
//                       config: const Config(
//                         columns: 7,
//                         verticalSpacing: 0, 
//                         horizontalSpacing: 0,
//                         gridPadding: EdgeInsets.zero,
//                         initCategory: Category.RECENT,
//                         bgColor: Color(0xFFF2F2F2),
//                         indicatorColor: Colors.blue,
//                         iconColor: Colors.grey,
//                         iconColorSelected: Colors.blue,
//                         backspaceColor: Colors.blue,
//                         skinToneDialogBgColor: Colors.white,
//                         skinToneIndicatorColor: Colors.grey,
//                         enableSkinTones: true,
//                         recentTabBehavior: RecentTabBehavior.RECENT,
//                         recentsLimit: 28,
//                         replaceEmojiOnLimitExceed: false,
//                         noRecents: Text(
//                           'No Recents',
//                           style: TextStyle(fontSize: 20, color: Colors.black26),
//                           textAlign: TextAlign.center,
//                         ),
//                         loadingIndicator: SizedBox.shrink(),
//                         tabIndicatorAnimDuration: kTabScrollDuration,
//                         categoryIcons: CategoryIcons(),
//                         buttonMode: ButtonMode.MATERIAL,
//                         checkPlatformCompatibility: true,
//                       ),
//                     ),
//               ),
                
//                 ],
//               );
            
//               }
//               if(state is GroupFailState)return FailBlocWidget(state.error);
//               return Container();
//             },
//           )),
//       ),
//     );
//   }


//   // late ChatRepoBody repo;
//   late TextEditingController _controller;
//   late int indexSelected ;
//   late bool isEmojiSelected ;
//   final FocusNode focusNode = FocusNode();
//   final ScrollController scrollController = ScrollController();
//   late String chatRoomId;

  

//   @override
//   void initState() {
//     super.initState();
//     _controller =  TextEditingController();
//     isEmojiSelected = false;

//     WidgetsBinding.instance.addObserver(this);

//     context.read<GroupBloc>().add(GetGroupMessagesEvent(widget.groupModel.uid));
//     chatRoomId = widget.groupModel.uid;

//   }


//   @override
//   void dispose() {
//     focusNode.dispose();
//     audioRecord.dispose();
//     super.dispose();
//   }


// }



class GroupScreen extends StatefulWidget {
  final CreateGroupModel groupModel;
  const GroupScreen({super.key,required this.groupModel});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}
class _GroupScreenState extends State<GroupScreen> with WidgetsBindingObserver{
  
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
      child: BlocBuilder<GroupBloc,GroupState>(
        builder: (context, state) {
          if(state is GroupLoadingState)return loading(context);
          if(state is GroupSuccessState){
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
                    appBar: isSearch ? searchingAppbar() : GroupAppBar(data: widget.groupModel,onPress: onPress),
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
                                  if(snapshot.data == null || snapshot.data!.isEmpty){return startConversitionLottie(context);}
                                  else{
                                    List<MessageModel> messages = snapshot.data!.reversed.toList();
                                    log(messages.toString());
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
                                            onDoubleTap: ()async => context.read<ChatBloc>().add(DeleteMessageEvent(messages[index].uid)),
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
                            decoration:BoxDecoration(
                              border: Border( top: BorderSide(color: theme(context).primaryColor,width: sizeW(context)*0.001)),),
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
                         : GroupButtonsWidget(
                            scrollController: observerController.controller!,
                            groupUid: widget.groupModel.uid,
                            isEmojiSelected: isEmojiSelected, 
                            controller: _controller),

                      ],
                    )
                ))
              );
          }
          if(state is GroupFailState)return FailBlocWidget(state.error);
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

    WidgetsBinding.instance.addObserver(this);

    BlocProvider.of<GroupBloc>(context).add(GetGroupMessagesEvent(widget.groupModel.uid));

    scrollController = ScrollController();
    observerController = ListObserverController(controller: scrollController);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // late ChatRepoBody repo;
  late List<int> searchingComingData;

  PreferredSizeWidget searchingAppbar()=> AppBar(
      backgroundColor: theme(context).backgroundColor,
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          color: theme(context).primaryColor,
          height: sizeH(context)*0.002,
        ),
      ),
      elevation: 0,
      toolbarHeight: sizeH(context)*0.16,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: theme(context).cardColor,),onPressed: onPress,),
      actions: [ _searchController.text.isEmpty ? const SizedBox.shrink() : IconButton(onPressed: ()=>_searchController.clear(), icon: Icon(Icons.clear,color: theme(context).backgroundColor,)) ],
      title: TextField(
        autofocus: true,
        decoration:const InputDecoration(border: InputBorder.none),
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) async {
          //! searching
          // Map<List<MessageModel>,List<int>> data = await repo.searching(widget.groupModel.uid, _searchController.text);
            // log(data.entries.first.toString());
            // log(data.values.first.toString());

            // setState(()=> searchingComingData = data.values.first);
        },
      ),
    );
}
