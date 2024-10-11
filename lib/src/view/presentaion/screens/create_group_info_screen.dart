import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/data/repo/group_repo_body.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';

import '../../../config/theme/theme.dart';
import '../../../core/common/constance/images.dart';
import '../../../core/common/sizes.dart';

class CreateGroupInfoScreen extends StatefulWidget {
  final UserModel myself;
  final List<UserModel>? data;
  const CreateGroupInfoScreen({super.key,required this.data,required this.myself});

  @override
  State<CreateGroupInfoScreen> createState() => _CreateGroupInfoScreenState();
}

class _CreateGroupInfoScreenState extends State<CreateGroupInfoScreen> {
  
  XFile? image;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

  UnderlineInputBorder border()=>UnderlineInputBorder(borderSide: BorderSide(color: theme(context).primaryColorDark,));
             
  return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: theme(context).primaryColorDark,
            height: sizeH(context)*0.001,
          ),
        ),
        title: Text('New Group'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
        leading: IconButton(icon:const Icon(Icons.arrow_back),onPressed: ()=>context.navigationBack(context),),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: ()async{
                        XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                        setState(() => file != null ? image = file : log('Choese Image null'),);
                      },
                      child: CircleAvatar(
                        backgroundColor: theme(context).primaryColorDark,
                        radius: sizeW(context)*0.052,
                        backgroundImage: image != null ? FileImage(File(image!.path)) : null,
                        child: Center(child: image != null ? null : Icon(Icons.add_a_photo,size: sizeW(context)*0.04,color: Colors.white,)),
                      ),
                    ),
                    SizedBox(
                      width: sizeW(context)*0.33,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller,
                            validator: (value) => value!.isEmpty ? 'Enter Something'.tr():null,
                            decoration: InputDecoration(
                              border: border(),
                              focusedBorder: border(),
                              hintText: 'Enter group Name'.tr(),),
                          ),
                          TextField(
                            controller: biocontroller,
                            decoration: InputDecoration(
                              border: border(),
                              focusedBorder: border(),
                              hintText: 'Enter Bio'.tr(),),
                          ),
                        ],
                      ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.035,vertical: sizeH(context)*0.02),
                width: sizeW(context),
                height: sizeH(context)*0.08,
                color: theme(context).primaryColor,
                child: Text('${widget.data?.length} memebers',style: theme(context).textTheme.bodySmall!.copyWith(color: theme(context).primaryColorDark),),
              ),
              sizeBoxH(sizeH(context)*0.02),
              ListView.separated(
                separatorBuilder: (context, index) => Divider(thickness: 0.4,indent: sizeW(context)*0.1,),
                shrinkWrap: true,
                itemCount: widget.data?.length ?? 0,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.01),
                  child: ListTile(
                    leading: widget.data?[index].image != null
                      ? Container(
                          width: sizeW(context)*0.066,
                          decoration: BoxDecoration(
                            color: theme(context).primaryColorDark,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) => setState(() => AssetImage(kLogoImage)),
                              image: NetworkImage(widget.data![index].image!))
                          ),
                        )
                      : CircleAvatar(
                        backgroundColor: theme(context).primaryColorDark,
                        radius: sizeW(context)*0.034,
                        child: Text(widget.data![index].name?[0].toUpperCase() ?? widget.data![index].uid![0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).scaffoldBackgroundColor),)),
                    title: Text(widget.data?[index].name ?? widget.data![index].uid![0].toUpperCase(),style: theme(context).textTheme.titleSmall!.copyWith(fontSize: sizeW(context)*0.018,fontFamily: 'body',fontWeight: FontWeight.w500)),
                  ),
                ),)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme(context).primaryColorDark,
        onPressed: ()async {
          if(formKey.currentState!.validate())context.read<GroupBloc>().add(CreateGroupEvent1(context: context,name: controller.text.trim(),bio: biocontroller.text.trim() ,users: widget.data!, file: image,mySelf: widget.myself));
        },
        child:BlocBuilder<GroupBloc,GroupState>(
        builder: (context, state) {
          log('$state');
          if(state is GroupLoadingState)return smallLoading(context,color: theme(context).scaffoldBackgroundColor);
          if(state is GroupSuccessState || state is GroupInitialState) return Icon(Icons.check,color: theme(context).scaffoldBackgroundColor,);
          if(state is GroupFailState)return FailBlocWidget(state.error);
          return Container(width: 100,height: 100,color: Colors.amber,);
        },
      
      ),
      
        
      ),
    );
  }
}

