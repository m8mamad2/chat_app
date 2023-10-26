import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/is_english.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/cache_image.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/core/widget/photo_view.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';
import 'package:p_4/src/view/data/repo/helper/chat_helper_repo_body.dart';
import 'package:p_4/src/view/domain/usecase/chat_usecase.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';

import '../../../data/model/message_model.dart';
import '../../../data/model/user_model.dart';
import '../../blocs/upload_bloc/upload_bloc.dart';

class AppBarInfoScreen extends StatefulWidget {
  final UserModel data;
  const AppBarInfoScreen({super.key,required this.data,});

  @override
  State<AppBarInfoScreen> createState() => AppBarInfoScreenState();
}
class AppBarInfoScreenState extends State<AppBarInfoScreen> {
  ChatUseCase repo = ChatUseCase(ChatHelperRepoBody(ChatRepoBody()));

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          
          IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline,color: theme(context).cardColor,))
        ],
        leading: IconButton(icon:const Icon(Icons.arrow_back),onPressed: () => context.navigationBack(context),),),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                  width: sizeW(context),
                  height: sizeH(context)*0.27,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: theme(context).primaryColorDark,width: sizeW(context)*0.0015)),
                    color: theme(context).backgroundColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.019,vertical: 10),
                    child: Center(
                      child: Row(
                        children: [
                          widget.data.image != null && widget.data.image!.isNotEmpty 
                            ? CircleAvatar(
                                radius: sizeW(context)*0.045,
                                backgroundColor: theme(context).primaryColorDark,
                                backgroundImage: NetworkImage(widget.data.image!),
                              )
                            : CircleAvatar(
                                radius: sizeW(context)*0.045,
                                backgroundColor: theme(context).primaryColorDark,
                                child: Text(widget.data.name![0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor)),
                              ),
                          sizeBoxW(sizeW(context)*0.02),
                          Text(widget.data.name ?? 'no Name',style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header',color: theme(context).cardColor,fontSize: sizeW(context)*0.024))
                        ],
                      ),
                    ),
                  ),
                ),
                  SizedBox(
                  width: sizeW(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(title: Text('Info'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).primaryColorDark),),),
                      ListTile(
                        title: Text(widget.data.phone!),
                        subtitle: Text('Mobile'.tr()),
                      ),
                      ListTile(
                        title: Text(widget.data.info ?? 'Nothing'.tr()),
                        subtitle: Text('Bio'.tr()),
                      ),
                      Container(color: theme(context).primaryColorDark,height: sizeW(context)*0.0015,width: sizeW(context),)
                    ],
                  ),
                )
                ],
              ),
              Padding(
                padding: EdgeInsets.only( 
                  right:isEnglish(context) ? sizeW(context)*0.03 : 0,
                  left:isEnglish(context) ? 0 : sizeW(context)*0.03,
                  bottom: sizeH(context)*0.25),
                child: Align(
                  alignment:isEnglish(context) ? Alignment.centerRight : Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => context.navigationBack(context),
                    child: CircleAvatar(
                      radius: sizeW(context)*0.04,
                      backgroundColor: theme(context).primaryColorDark,
                      child: Icon(Icons.chat,color: theme(context).backgroundColor,),
                    ),
                  ),
                ),
              )
            ],
          ),
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
                        future: repo.getImageMessage(context,widget.data.uid!),
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
                        future: repo.getFileMessage(context,widget.data.uid!),
                        builder: (context, snapshot) {
                          switch(snapshot.connectionState){
                            case ConnectionState.none:
                            case ConnectionState.waiting:return smallLoading(context);
                            default:
                              if(snapshot.data == null || snapshot.data!.isEmpty) return Center(child: Text('Empty'.tr()),);
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