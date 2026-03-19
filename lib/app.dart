import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/task_store.dart';
import 'theme/app_theme.dart';
import 'widgets/blur_tab_bar_shell.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskStore(),
      child: MaterialApp(
        title: 'SpacedRep',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const _AppLoader(),
      ),
    );
  }
}

class _AppLoader extends StatelessWidget {
  const _AppLoader();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TaskStore>();
    if (!store.isLoaded) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }
    return const BlurTabBarShell();
  }
}
