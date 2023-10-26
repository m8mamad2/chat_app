// ignore_for_file: camel_case_types, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';

import '../../../../config/theme/theme.dart';
import '../../../../core/common/sizes.dart';
import '../../../../core/widget/loading.dart';

//! delay in search
// class Debouncer {
//   final int milliseconds;
//   late VoidCallback action;
//   late Timer _timer;
//   Debouncer({required this.milliseconds,});
//   run(VoidCallback action) {
//     if (null != _timer) {
//       _timer.cancel();
//     }
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }
// final _debouncer = Debouncer(milliseconds: 500);
// onChanged: (string) {
//   _debouncer.run(() {
//     print(string);
//     //perform search here
//   }
// );



class ChatSearchWidget extends StatefulWidget {
  ChatSearchWidget({super.key});

  @override
  State<ChatSearchWidget> createState() => _ChatSearchWidgetState();
}

class _ChatSearchWidgetState extends State<ChatSearchWidget> {
  
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if(state is ChatLoadingState)return loading(context);
            if (state is ChatSuccessState ) {
              
              List<MessageModel> megs = state.messages!;
              List<MessageModel> ulist = [];
              // megs.listen((event) {
                setState(() {ulist.addAll(megs);});
              //   });
              // },);
              
              return Container(
                  decoration: BoxDecoration(
                      color: theme(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                  width: sizeW(context) * 0.828,
                  height: sizeH(context) * 0.1,
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon:const Icon(Icons.search),
                        onPressed: (){
                          
                          String query = controller.text;

                          List<String> strings = ulist.map((e) => e.messsage).toList();
                          strings.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
                          print(strings);

                        },
                      )
                    ),
                  ));
            }
            if (state is ChatFailState) return  Text(state.error);
            return const SizedBox();
          },
        ),
      );
  }

}


