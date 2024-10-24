
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/app.dart';
import 'package:social_media/responsive/constrained_scaffold.dart';
import 'package:social_media/themes/theme_cubit.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // theme cubit
    final themeCubit = context.watch<ThemeCubit>();

    // is dark mode
    bool isDarkMode = themeCubit.isDarkMode;
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const  Text("Settings"),
      ),
      body: Column(
        children: [
          // dark mode tile
          ListTile(
            title: Text("Dark Mode"),
            trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value){
                  themeCubit.toggleTheme();
                }
            ),
          )
        ],
      ),
    );
  }
}
