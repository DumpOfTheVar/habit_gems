import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          child: Text('Gems'),
          onTap: () => context.go('/gems'),
        ),
        PopupMenuItem(
          child: Text('Statistics'),
          onTap: () => context.go('/statistics'),
        ),
        PopupMenuItem(
          child: Text('Settings'),
          onTap: () => context.go('/settings'),
        ),
      ],
    );
  }
}
