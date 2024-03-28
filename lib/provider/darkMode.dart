import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeModeEnum { light, dark }

class ThemeDarkModeNotifier extends StateNotifier<ThemeModeEnum> {
  ThemeDarkModeNotifier() : super(ThemeModeEnum.light);

  void selectMode() {
    state = state == ThemeModeEnum.light ? ThemeModeEnum.dark : ThemeModeEnum.light;
  }
}

final themeDarkMode = StateNotifierProvider<ThemeDarkModeNotifier, ThemeModeEnum>((ref) {
  return ThemeDarkModeNotifier();
});

class HomeScreenPro extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark Mode Example2'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(themeDarkMode.notifier).selectMode();
          },
          child: Text('Toggle Theme'),
        ),
      ),
    );
  }
}

class Ho2 extends StatelessWidget {
  const Ho2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

class App3 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _themeDarkMode = ref.watch(themeDarkMode);
    return MaterialApp(
      theme: ThemeData(
        brightness: _themeDarkMode == ThemeModeEnum.light ? Brightness.light : Brightness.dark,
        // Define your light mode theme colors here
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // Define your dark mode theme colors here
      ),
      home: HomeScreenPro(),
    );
  }
}