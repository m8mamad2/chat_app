// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_painter/image_painter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';



class BottomShetImagesWidget extends StatefulWidget {
  const BottomShetImagesWidget({super.key});

  @override
  State<BottomShetImagesWidget> createState() => _BottomShetImagesWidgetState();
}
class _BottomShetImagesWidgetState extends State<BottomShetImagesWidget> {

  AssetPathEntity? selectAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<AssetPathEntity> data = await PhotoManager.getAssetPathList(type: RequestType.image);
    setState(() {
      albumList = data;
      selectAlbum = data[0];
    });
    assetList = await selectAlbum!.getAssetListRange(start: 0, end: selectAlbum!.assetCount);
    setState((){});
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
      child: GridView.builder(
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
      child: AssetEntityImage(
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
        backgroundColor: theme(context).primaryColor,
        child: BlocBuilder<UserBloc,UserState>(
          builder: (context, state) {
            if(state is UserLoadingState)return smallLoading(context,color: theme(context).backgroundColor);
            if(state is UserSuccessState)return Icon(Icons.check,color: theme(context).backgroundColor,);
            if(state is UserFailState)   return Icon(Icons.error,color: theme(context).backgroundColor,);
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


class Editore extends StatefulWidget {
  final File path;
  const Editore({super.key,required this.path});

  @override
  State<Editore> createState() => _EditoreState();
}
class _EditoreState extends State<Editore> {

  final _imageKey = GlobalKey<ImagePainterState>();
  XFile? dddd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: ()async{await OpenFile.open(dddd!.path);}, icon: const Icon(Icons.open_in_browser))
        ],
        leading: IconButton(
          onPressed: ()async{
            Uint8List? data = await _imageKey.currentState!.exportImage();
            XFile? xfile = XFile.fromData(data!);
            log('${xfile.path}');
            setState(() {
              dddd = xfile;
            });
            // context.read<UserBloc>().add(UpdateUserPictureEvent(file));
          }, 
          icon: const Icon(Icons.check)),
      ),
      body: ImagePainter.file(
        width: sizeW(context),
        widget.path, 
        key: _imageKey,
        scalable: true,
        initialStrokeWidth: 2,
        initialColor: Colors.green,
        initialPaintMode: PaintMode.line,
        )
    );
  }
}

