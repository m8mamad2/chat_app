import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewWidget extends StatelessWidget {
  final String image;
  const PhotoViewWidget({super.key,required this.image});

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: NetworkImage(image),
    );
  }
}