import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: "Home"),
              Tab(text: "Teclados"),
              Tab(text: "Teclados Custom"),
              Tab(text: "Acessórios"),
            ],
          ),
        ),
      ),
    );
  }
}
