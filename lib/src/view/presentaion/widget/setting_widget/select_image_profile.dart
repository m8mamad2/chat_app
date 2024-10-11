// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:photo_manager/photo_manager.dart' ;
import 'package:photo_view/photo_view.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart' as AssetImageWidget;


class BottomShetImagesWidget extends StatefulWidget {
  const BottomShetImagesWidget({super.key});

  @override
  State<BottomShetImagesWidget> createState() => _BottomShetImagesWidgetState();
}
class _BottomShetImagesWidgetState extends State<BottomShetImagesWidget> {

  AssetPathEntity? selectAlbum;
  List<AssetPathEntity> data = [];
  List<AssetEntity> assetList = [];
  bool loading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    try{
      data = await PhotoManager.getAssetPathList(type: RequestType.image);
      print(data);
      
      setState(() { selectAlbum = data[0]; });
      
      final int count = await PhotoManager.getAssetCount();
      assetList = await selectAlbum!.getAssetListRange(start: 0, end: count);
      
      setState((){});

      Future.delayed(const Duration(seconds: 3),()=>setState(()=> loading = false));
    }
    catch(e){ print('---> $e'); }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )
      ),
      width: sizeW(context),
      child: 
      loading 
        ? smallLoading(context)
        :GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: assetList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
          itemBuilder: (context, index) {
              return Padding( padding:const EdgeInsets.all(2), child: assetWidget(assetList[index]),);
            },
        ),
    );
  }
  
  Widget assetWidget(AssetEntity assetEntity)=> Padding(
    padding: const EdgeInsets.all(1),
    child: GestureDetector(
      onTap: () async{
        //! editor
        // log(assetEntity.relativePath!);
        // File? data = await assetEntity.file;
        // context.navigation(context, Editore(path: data!));
        File? data = await assetEntity.file;
        context.navigation(context, ShowImageWidget(file: data!));
      } ,
      // child: Container(
      //     decoration: BoxDecoration(color: Colors.red),
      //     child: FutureBuilder(
      //       future: assetEntity.file,
      //       builder: (context, snapshot) {
      //         switch(snapshot.connectionState){
      //           case ConnectionState.none:
      //           case ConnectionState.waiting: return CircularProgressIndicator();
      //           default:
      //             return snapshot.data == null ? Text('null') :  Image.file(snapshot.data!.absolute);
      //         }
      //       },),
      // ),
      child: AssetImageWidget.AssetEntityImage(
        assetEntity,
        isOriginal: false,
        thumbnailSize: const ThumbnailSize.square(250),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>const Center(child: Icon(Icons.error,color: Colors.red,),),
        ),
    ),
  );
}

class ShowImageWidget extends StatelessWidget {
  final File file;
  const ShowImageWidget({super.key,required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PhotoView(imageProvider:FileImage(file)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme(context).primaryColorDark,
        child: BlocBuilder<UserBloc,UserState>(
          builder: (context, state) {
            if(state is UserLoadingState)return smallLoading(context,color: theme(context).scaffoldBackgroundColor);
            if(state is UserSuccessState || state is UserInitialState)return Icon(Icons.check,color: theme(context).scaffoldBackgroundColor,);
            if(state is UserFailState)   return Icon(Icons.error,color: theme(context).scaffoldBackgroundColor,);
            return Container();
          },
        ),
        onPressed: ()async{
          XFile data = XFile(file.path);
          log(file.path);
          log(data.path);
          context.read<UserBloc>().add(UpdateUserPictureEvent(context,data));
        }),
    );
  }
}



