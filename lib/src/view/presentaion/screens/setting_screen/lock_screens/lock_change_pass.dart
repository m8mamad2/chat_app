
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/constance/lotties.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/repo/lock_repo_body.dart';
import 'package:p_4/src/view/presentaion/blocs/lock_bloc/lock_bloc.dart';

import '../../../../../config/theme/theme.dart';
import '../../../../../core/common/is_english.dart';
import '../../../../../core/common/sizes.dart';

class LockChangePass extends StatefulWidget {
  const LockChangePass({super.key});

  @override
  State<LockChangePass> createState() => _LockChangePassState();
}
class _LockChangePassState extends State<LockChangePass> {

  @override
  void initState() {
    super.initState();
    context.read<LockBloc>().add(GetLockEvent());
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0.0),
                    child: Container(
                      color: theme(context).primaryColorDark,
                      height: sizeH(context)*0.001,
                    ),
                  ),
        title: Text('Change Lock'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
        leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: (){
          context.navigationBack(context);
          
        },),),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kLockLottier(context),
              sizeBoxH(sizeH(context)*0.037),
              Text('Please Enter new Password'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header',fontSize: sizeW(context)*0.023),),
              SizedBox(
                height: sizeH(context)*0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(var i = 0 ; i < actives.length ; i++) AnimatedBoxItem( clear: clears[i],active: actives[i], ),
                  ],
                ),
              ),
            ],
          ),
          Text(message),
          const Spacer(),
          Expanded(
            flex: 1,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
                crossAxisCount: 3,),
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                return index == 9 
                  ? const SizedBox.shrink()
                  : InkWell(
                    onTap: ()async {
    
                      //! for delete
                      if(index == 11){
                        if(input.isNotEmpty) input = input.substring(0, input.length - 1);
                        clears = clears.map((e) => true).toList();
                        curretnIndex--;
    
                        if(curretnIndex >= 0){ 
                          log('if');
                          setState(() {
                            clears[curretnIndex] = true;
                            actives[curretnIndex] = false;
                        });}
                        else{ 
                          log('else');
                          curretnIndex = 0; return; }
    
                        return;}
                        
                      else{ input += numbers[index == 10 ? index - 1 : index]; }
    
                      //! if completed
                      if(input.length == 5){
                        
                        setState(() {
                          clears = clears.map((e) => true).toList();
                          actives = clears.map((e) => false).toList();
                        });

                        context.read<LockBloc>().add(DeleteLockEvent());
                        context.read<LockBloc>().add(SavePasswordLockEvent(input));
                        context.navigationBack(context);

                        input = '';
                        curretnIndex = 0;
                        return;
                      }
    
                      //! refresh data
                        context.read<LockBloc>().add(DeleteLockEvent());
                        context.read<LockBloc>().add(SavePasswordLockEvent(input));
                        context.navigationBack(context);

                      clears = clears.map((e) => true).toList();
                      setState(() {
                          actives[curretnIndex] = true;
                          curretnIndex++;
                      });
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:  theme(context).primaryColorDark ,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: index == 11 ? Icon(Icons.backspace,color: theme(context).scaffoldBackgroundColor,) : Text(
                        numbers[index == 10 ? index - 1 : index].tr(),style: theme(context).textTheme.titleMedium!.copyWith(
                          fontSize: isEnglish(context) ? sizeW(context)*0.021 : sizeW(context)*0.028,
                          color: theme(context).scaffoldBackgroundColor))),
                      ),
                  );
              },
            ),
          ),
        ],
      )
    );
  }


  String input = '';
  String secondInpt = '';
  int curretnIndex = 0;
  String message = '';

  lockChangePass(String input){
    context.read<LockBloc>().add(DeleteLockEvent());
    context.read<LockBloc>().add(SavePasswordLockEvent(input));
    context.navigationBack(context);
  }

}

List<String> numbers = ['1','2','3','4','5','6','7','8','9','0',];
List<bool> actives = [false,false,false,false,false,];
List<bool> clears = [false,false,false,false,false,];
 
class AnimatedBoxItem extends StatefulWidget {
  final clear;
  final active;
  const AnimatedBoxItem({super.key,this.clear = false,this.active = false});

  @override
  State<AnimatedBoxItem> createState() => _AnimatedBoxItemState();
}
class _AnimatedBoxItemState extends State<AnimatedBoxItem> with TickerProviderStateMixin{

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this,duration: const Duration(milliseconds: 1)); 
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => Container(
        margin: const EdgeInsets.all(10),
        color: theme(context).scaffoldBackgroundColor,
        child: Stack(
          children: [
            Container(),
            AnimatedContainer(
              duration: const Duration(milliseconds:1 ),
              width: sizeW(context)*0.05,
              height: sizeH(context)*0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all( color: widget.active ? theme(context).primaryColorDark:Colors.black,)
              ),
              child: widget.active 
                ? Padding(padding: const EdgeInsets.all(15.0),child: CircleAvatar(backgroundColor: theme(context).primaryColorDark,)) 
                : const SizedBox.shrink(),
            ),
          ],
        ),
      )
        
    );
  }
}
