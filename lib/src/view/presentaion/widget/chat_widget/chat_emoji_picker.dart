import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:p_4/src/core/common/sizes.dart';

class ChatEmojiPickerWidget extends StatelessWidget {
  final TextEditingController controller;
  const ChatEmojiPickerWidget({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: sizeH(context)*0.7,
        child: EmojiPicker(
          textEditingController: controller,
          onBackspacePressed: (){},
          config: const Config(
            columns: 8,
            verticalSpacing: 10, 
            horizontalSpacing: 10,
            gridPadding: EdgeInsets.zero,
            initCategory: Category.RECENT,
            bgColor: Color(0xFFF2F2F2),
            indicatorColor: Color(0xff1b2028),
            iconColor: Colors.grey,
            iconColorSelected: Color(0xff1b2028),
            backspaceColor: Color(0xff1b2028),
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.grey,
            enableSkinTones: true,
            recentTabBehavior: RecentTabBehavior.RECENT,
            recentsLimit: 28,
            replaceEmojiOnLimitExceed: false,
            noRecents: Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: SizedBox.shrink(),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
            checkPlatformCompatibility: true,
          ),
        ),
    );
  } 
}