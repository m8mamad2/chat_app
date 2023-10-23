
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/cubit/theme_cubit.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/blocs/setting_blocs/font_size_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/types/message_type_widget.dart';

class SettingChatSetting extends StatefulWidget {
  const SettingChatSetting({super.key});

  @override
  State<SettingChatSetting> createState() => SettingChatSettingState();
}
class SettingChatSettingState extends State<SettingChatSetting> {
 
  @override
  void initState() {
    context.read<FontSizeBloc>().add(GetFontSizeEvent());
    context.read<BorderRadiusBloc>().add(GetBorderRadiusEvent());
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Setting',style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
        leading: IconButton(icon:const Icon(Icons.arrow_back),onPressed:() => context.navigationBack(context),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(sizeH(context)*0.001),
          child: Container(
            height :sizeH(context)*0.001,
            width: sizeW(context),
            color: theme(context).cardColor,
          ),
        ),
      ),
      body: Column(
        children: [
          oneLIneWidget(context),
          fontSizeChangerWidget(context),
          oneLIneWidget(context),
          changeColorTheme(context),
          oneLIneWidget(context),
          borderRadiusChangerWidget(context),
          sizeBoxH(sizeH(context)*0.08),
          oneLIneWidget(context),
        ],
      ),
    );
  }
}

Container oneLIneWidget(BuildContext context)=> Container(
      margin: const EdgeInsets.only(top: 1),
      width: sizeW(context),
      height: sizeH(context)*0.005,
      color: theme(context).primaryColor,
    );

Container fontSizeChangerWidget(BuildContext context)=> Container(
  width: sizeW(context),
  color: theme(context).backgroundColor,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sizeBoxH(sizeH(context)*0.02),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.04,vertical: sizeH(context)*0.02),
        // child: Text('Message Text Size',style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).primaryColor,fontWeight: FontWeight.w400),),
        child: Text('Message Text Size',style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).primaryColor,fontWeight: FontWeight.w400),),
      ),
      BlocBuilder<FontSizeBloc,FontSizeState>(
        builder: (context, state) {
          if(state is LoadedFontSizeState){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: sizeW(context)*0.44,
                  child: Slider(
                    value: state.fontSize, 
                    min: 12.0,
                    max: 23.0,
                    divisions:11,
                    onChanged: (value) => context.read<FontSizeBloc>().add(ChangeFontSizeEvent(value)),),
                ),
                Text('${state.fontSize.toInt()}',style: theme(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),),
              ],
            );}
          return Container(width: 100,height: 100,color: Colors.amber,);
        },),
      sizeBoxH(sizeH(context)*0.03),
      Container(
        width: sizeW(context),
        height: sizeH(context)*0.5,
        decoration:const BoxDecoration(image:  DecorationImage(image:AssetImage('assets/image/bg_chat.jpg',),fit: BoxFit.cover )),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            sizeBoxH(sizeH(context)*0.04),
            MessageTypeWidget(aligment: Alignment.centerLeft, data: models[0], isMine: false),
            MessageTypeWidget(aligment: Alignment.centerRight, data: models[1], isMine: true)
          ],
        )
      ),
    ],
  ),
  
);
List<MessageModel> models = [
  MessageModel.create('uid', 'senderID', 'receiverID', 'Hi Man ! Whats up?', 'chatRoomID',null),
  MessageModel.create('uid', 'senderID', 'receiverID', 'Its AllWrith', 'chatRoomID',null)
];

Container changeColorTheme(BuildContext context)=> Container(
  width: sizeW(context),
  color: theme(context).backgroundColor,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    
    children: [
      sizeBoxH(sizeH(context)*0.02),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.02,vertical: sizeH(context)*0.04),
        child: Text('Change Color Theme',style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).primaryColor,fontWeight: FontWeight.w400),),
      ),
      Container(
        decoration: BoxDecoration(
          color: theme(context).backgroundColor,
          border: Border.symmetric(horizontal: BorderSide(color: theme(context).cardColor,width: sizeW(context)*0.0001))
        ),
        height: sizeH(context)*0.2,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: colors.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: ()=> context.read<ThemeBloc>().add(ChangeColorThemeEvent(colors[index])),
              child: CircleAvatar(backgroundColor: colors[index],),
            ),
            ),),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListTile(
          onTap: () => context.read<ThemeBloc>().add(ChangeLightDarkThemeEvent()),
          leading: Icon(Icons.color_lens,color: theme(context).primaryColor,),
          title: const Text('Switch Dark Light '),
        ),
      ),
    ],
  ),
);
List<Color> colors = [
  Colors.blue,
  Colors.amberAccent,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.red,
  Colors.pink,
  Colors.tealAccent,
];

Container borderRadiusChangerWidget(BuildContext context)=> Container(
  width: sizeW(context),
  color: theme(context).backgroundColor,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      sizeBoxH(sizeH(context)*0.02),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.04,vertical: sizeH(context)*0.02),
        child: const Text('Messages Corners'),
      ),
      BlocBuilder<BorderRadiusBloc,BorderRadiusState>(
        builder: (context, state) {
          if(state is LoadedBorderRadiusState){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: sizeW(context)*0.44,
                  child: Slider(
                    value: state.borderRadius, 
                    min: 0.0,
                    max: 20.0,
                    divisions:11,
                    onChanged: (value) => context.read<BorderRadiusBloc>().add(ChangeBorderRadiusEvent(value)),),
                ),
                Text('${state.borderRadius.toInt()}'),
              ],
            );}
          return Container(width: 100,height: 100,color: Colors.amber,);
        },),
    ],
  ),
  
);
