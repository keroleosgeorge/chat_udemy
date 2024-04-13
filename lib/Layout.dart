import 'package:chat_udemy/firebase/fire_auth.dart';
import 'package:chat_udemy/models/user_model.dart';
import 'package:chat_udemy/provider/provider.dart';
import 'package:chat_udemy/screens/Home/Contacts.dart';
import 'package:chat_udemy/screens/Home/GroupHomeScreen.dart';
import 'package:chat_udemy/screens/Home/Setting.dart';
import 'package:chat_udemy/screens/Home/chat_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LayoutApp extends StatefulWidget {
  const LayoutApp({super.key});

  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  int currentindex = 0;
  PageController pagecontroller =PageController();
  @override

  void initState() {
    Provider.of<providerApp>(context,listen: false).getValuesPref();
    Provider.of<providerApp>(context,listen: false).getUserDetails();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if(message.toString() == 'AppLifecycleState.resumed'){
        FireAuth().updateActivated(true);
      }
      else if(message.toString() == 'AppLifecycleState.inactive' || message.toString() == 'AppLifecycleState.paused')
      {
        FireAuth().updateActivated(false);
      }
      return Future.value(message);
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ChatUser? me =Provider.of<providerApp>(context).me;
    List<Widget> screens=[

    ];
    return Scaffold(
      body:  me == null ? const Center(
        child: CircularProgressIndicator(),
      ):PageView(
        onPageChanged: (value) {
          setState(() {
            currentindex=value;
          });
        },
        controller: pagecontroller,
        children: const [
          ChatHomeScreen(),
          GroupHomeScreen(),
          ContactsHomeScreen(),
          SettingHomeScreen(),
        ],
      ),
      bottomNavigationBar:NavigationBar(selectedIndex: currentindex,
      onDestinationSelected: (value) {
        setState(() {
          currentindex=value;
          pagecontroller.jumpToPage(value);

        });
      },
      destinations: const [
        NavigationDestination(icon: Icon(Iconsax.message_2), label: "Chat",),
        NavigationDestination(icon: Icon(Iconsax.messages), label: "Groups",),
        NavigationDestination(icon: Icon(Iconsax.user), label: "Contacts",),
        NavigationDestination(icon: Icon(Iconsax.setting), label: "Setting",),
      ]),
    );
  }
}
