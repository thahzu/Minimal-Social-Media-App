 import 'package:flutter/material.dart';

class ConstrainedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;

  const ConstrainedScaffold({
    super.key,
     this.appBar,
    required this.body,
     this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: ConstrainedBox(
             constraints: const BoxConstraints(
               maxWidth: 430,
             ),
          child: body,
      ),
      ),
    );
  }
}
