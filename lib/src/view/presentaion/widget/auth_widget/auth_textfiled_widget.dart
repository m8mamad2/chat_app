import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/sizes.dart';

class AuthTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obsucreText;
  final bool isHide;
  final VoidCallback onPressHide;
  final bool isPassword;
  final String validatorType;
  const AuthTextFieldWidget({
    super.key, 
    required this.controller, 
    required this.hintText, 
    required this.obsucreText,
    required this.icon,
    required this.isHide,
    required this.onPressHide,
    required this.isPassword,
    required this.validatorType
    });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border (Color color) => OutlineInputBorder(
         borderRadius: BorderRadius.circular(10), 
         borderSide:BorderSide(color: color, width: 0.4));
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.06,vertical: sizeH(context)*0.012),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? isHide ? true : false : false,
        textInputAction: TextInputAction.next,
        style: theme(context).textTheme.bodyMedium!.copyWith(fontFamily: 'body'),
        validator: (value) {
          switch(validatorType){
            case 'email':if(!(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!))) return 'Enter valid Email';break;
            case 'phone': if(value!.isEmpty)return 'Enter someThing ...';break;
            case 'password':if(value!.isEmpty)return 'Enter someThing ...' ;break;
            default : return null;
          }
        },
        decoration: InputDecoration(
          labelText: hintText.tr(),
          labelStyle: theme(context).textTheme.bodySmall,
          prefixIcon:Icon(icon,color: theme(context).primaryColor,) ,
          suffixIcon:  isPassword ? IconButton(onPressed: ()=> onPressHide(), icon : isHide ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off_rounded)): null,
          fillColor: theme(context).canvasColor,
          filled: true,
          errorStyle: theme(context).textTheme.labelSmall!.copyWith(
            color: Colors.red,
            fontSize: sizeW(context)*0.01
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: sizeW(context)*0.021),
          focusedErrorBorder: border(Colors.red),
          enabledBorder: border(Colors.grey.shade400),
          errorBorder: border(Colors.red),
          focusedBorder: border(theme(context).primaryColor),
        ),
      ),
    );
  }
}