import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NotInternetScreen extends StatefulWidget {
  const NotInternetScreen({super.key});

  @override
  State<NotInternetScreen> createState() => _NotInternetScreenState();
}

class _NotInternetScreenState extends State<NotInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('not INternt'),),
    );
  }
}