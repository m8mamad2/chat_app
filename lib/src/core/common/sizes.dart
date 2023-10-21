// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

double sizeW(BuildContext context) => MediaQuery.of(context).size.height;
double sizeH(BuildContext context) => MediaQuery.of(context).size.width;

Widget sizeBoxH(double height)=> SizedBox(height: height,);
Widget sizeBoxW(double width)=> SizedBox(width: width,);