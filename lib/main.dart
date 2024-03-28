import 'package:chat_udemy/Layout.dart';
import 'package:chat_udemy/firebase_options.dart';
import 'package:chat_udemy/provider/provider.dart';
import 'package:chat_udemy/screens/auth_scrrens/Name_screen.dart';
import 'package:chat_udemy/screens/auth_scrrens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  // runApp(ProviderScope(child: MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>providerApp() ,
      child: Consumer<providerApp>(
        builder:(context,value,child) =>MaterialApp(
              themeMode:value.themeMode,
              title: 'Chat Now',
              theme: ThemeData(
                // brightness: Brightness.light,
                 colorScheme: ColorScheme.fromSeed(
                     seedColor: Color(value.mainColor),brightness: Brightness.light),
                 useMaterial3: true,
              ),
              darkTheme: ThemeData(
                // brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Color(value.mainColor),brightness: Brightness.dark),
                useMaterial3: true,
              ),

              debugShowCheckedModeBanner: false,
              home: StreamBuilder(stream: FirebaseAuth.instance.userChanges(),//دي فيدة دي علشان لو كنت عامل تسجيل دخول قبل كدة وخرجت من الاب من غير تسجيل الخروج اول لما افتح الاب تاني هيفتح علي الصفحة الاساسية ولو عملت تسجيل الخروج لما اجي افتح الاب تاني هيفتح علي صفحة login دي فايدة stream
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      if(FirebaseAuth.instance.currentUser!.displayName == "" ||
                          FirebaseAuth.instance.currentUser!.displayName == null  ){
                        return Name_screen();
                      }
                      else{
                        return LayoutApp();
                      }

                    }
                    else{
                      return Login_chat();
                    }

                  },
              ),
            ),
      ),
    );
  }
}


