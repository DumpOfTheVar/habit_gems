import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/menu.dart';

abstract class BasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var actions = getActions(context);
    actions.add(Menu());
    return Scaffold(
      appBar: AppBar(
        leading: _getLeading(context),
        title: getTitle(context),
        backgroundColor: theme.colorScheme.primary,
        actions: actions,
      ),
      body: WillPopScope(
        onWillPop: () {
          _goBack(context);
          return Future.value(false);
        },
        child: getBody(context),
      ),
      floatingActionButton: getButton(context),
      backgroundColor: theme.colorScheme.background,
    );
  }

  Widget _getLeading(BuildContext context) {
    final previous = getPrevious(context);
    if (previous == null) {
      return const Icon(Icons.home);
    }
    return TextButton(
      onPressed: () => _goBack(context),
      child: Icon(Icons.arrow_back, color: Theme
          .of(context)
          .colorScheme
          .onPrimary),
    );
  }

  String? getPrevious(BuildContext context);
  Widget getTitle(BuildContext context);
  Widget getBody(BuildContext context);
  List<Widget> getActions(BuildContext context);
  Widget? getButton(BuildContext context);

  void _goBack(BuildContext context) {
    final previous = getPrevious(context);
    if (previous != null) {
      context.go(previous);
    }
  }
}
