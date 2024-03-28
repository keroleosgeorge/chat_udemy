import 'package:chat_udemy/firebase/fire_database.dart';
import 'package:chat_udemy/models/user_model.dart';
import 'package:chat_udemy/provider/darkcubit.dart';
import 'package:chat_udemy/provider/provider.dart';
import 'package:chat_udemy/settings/Qrcodescreen.dart';
import 'package:chat_udemy/settings/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';



class SettingHomeScreen extends StatefulWidget {
  const SettingHomeScreen({super.key});

  @override
  State<SettingHomeScreen> createState() => _SettingHomeScreenState();
}

class _SettingHomeScreenState extends State<SettingHomeScreen> {
  bool dark_mood=true;

  late final ChatUser user;
  @override
  Widget build(BuildContext context) {
      final prov = Provider.of<providerApp>(context);
    return  Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: ()
      {
        FireData().sendNotification(chatUser: prov.me!, context: context, msg: "msg");
      }
      ),
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
              children: [
                ListTile(
                  minVerticalPadding: 40,
                  leading: CircleAvatar(radius: 30),
                  title: Text(prov.me!.name.toString()),
                  trailing: IconButton(
                      onPressed: (){
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => QrcodeScreen(),),
                        );
                      },
                      icon: Icon(Iconsax.scan_barcode),
                  ),
                ),
            Card(
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(Iconsax.user),
                trailing: Icon(Iconsax.arrow_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),)),
              ),
            ),
                Card(
                  child: ListTile(
                    title: Text('Theme'),
                    leading: Icon(Iconsax.color_swatch),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: Color(prov.mainColor),
                                  onColorChanged: (value) {
                                  prov.changeColor(value.value);
                                  },
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: (){
                              Navigator.pop(context);
                            },
                                child: Text('Done'),
                            ),
                            ],
                          );
                          },
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Dark Mood'),
                    // leading: Icon(Icons.dark_mode),
                    trailing:
                    // IconButton(onPressed: (){
                    //   context.read<ThemeCubit>().toggleTheme();
                    //
                    // }, icon: Icon(Icons.dark_mode)),
                    Switch(
                      value: prov.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                      prov.ChangeMode(value);
                      print(value);
                      //final prov = Provider.of<providerApp>(context); define prov
                    },
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: ()async => await FirebaseAuth.instance.signOut(),
                    title: Text('Sign out'),
                    trailing: Icon(Iconsax.logout_1),
                  ),
                ),
          ],
          ),
        ),
      ),
    );
  }
}