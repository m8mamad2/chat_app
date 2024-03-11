import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

Widget cachedImageWidget( BuildContext context, String imageUrl, double? width, double? height) {

  return CachedNetworkImage(
    key: UniqueKey(),
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) => Shimmer.fromColors(
      // baseColor: theme(context).primaryColor.withOpacity(0.8),
      // highlightColor: theme(context).primaryColor,
      baseColor: Colors.grey.shade300,
      highlightColor: theme(context).primaryColorDark.withOpacity(0.7),
      child: Container(color: Colors.white24,),
    ),
  );
}
