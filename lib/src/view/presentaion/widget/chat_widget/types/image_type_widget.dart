import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/core/widget/photo_view.dart';

import '../../../../../core/widget/cache_image.dart';

class ImageTypeWidget extends StatelessWidget {
  final String? url;
  final Alignment alignment;
  const ImageTypeWidget({super.key,required this.url,required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: UnconstrainedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: sizeW(context)*0.02),
          child: Container(
            height: sizeH(context)*0.8,
            width: sizeW(context)*0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme(context).primaryColor,
                width: 2
              )
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: url != null 
                    ? InkWell(
                      onTap: () => context.navigation(context, PhotoViewWidget(image: url!)),
                      child: cachedImageWidget(context,url!,null,null))
                    : const CircularProgressIndicator()
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.check,size: 15,)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageLoadingTypeWidget extends StatelessWidget {
  final Alignment alignment;
  const ImageLoadingTypeWidget({super.key,required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: UnconstrainedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: sizeW(context)*0.02),
          child: Container(
            height: sizeH(context)*0.8,
            width: sizeW(context)*0.3,
            decoration: BoxDecoration(
              color: theme(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme(context).backgroundColor,
                width: 2
              )
            ),
            child: smallLoading(context,color: theme(context).backgroundColor)
          ),
        ),
      ),
    );
  }
}