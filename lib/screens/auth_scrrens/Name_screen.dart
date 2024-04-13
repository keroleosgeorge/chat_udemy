import 'package:chat_udemy/firebase/fire_auth.dart';
import 'package:chat_udemy/utill/colors.dart';
import 'package:chat_udemy/utill/logoapp.dart';
import 'package:chat_udemy/utill/custom_text_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../firebase/fire_database.dart';

class Name_screen extends StatefulWidget {
  const Name_screen({super.key});

  @override
  State<Name_screen> createState() => _Name_screenState();
}

class _Name_screenState extends State<Name_screen> {
  TextEditingController Namecon = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () async{
    await FirebaseAuth.instance.signOut();
    },
            icon:const Icon(Iconsax.logout_1,color: Colors.black87,),
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   height: 150,
              //  width: 150,
              //   decoration:  BoxDecoration(
              //     image: DecorationImage(image:AssetImage("assets/chat_image_com.jpg"),)
              //   ),
              // ),
              const logoapp(),
              const SizedBox(height: 20,),
              const Text("Create Email",style: TextStyle(fontSize: 35),),
              const SizedBox(height: 10,),
              const  Text("Please enter your name ",style: TextStyle(fontSize: 15),),


              custum_text_field(
                lable: "Name",
                Hinttext: "Enter your name",
                icon: Iconsax.user,
                controller: Namecon,
              ),


              const SizedBox(height: 15),




              ElevatedButton(
                onPressed: () async {
                  if (Namecon.text.isNotEmpty) {
                    try {
                      // Update display name in Firebase Authentication
                      await FirebaseAuth.instance.currentUser!.updateDisplayName(Namecon.text);

                      // After successfully updating display name, create user in Firestore
                      await FireAuth.createuser();

                      // Update user profile in Firestore
                      await FireData().editProfile(Namecon.text, "Hello, I'm new on chat now");

                      // Optionally, you can add setState here if you need to update UI state
                      // setState(() {
                      //   Namecon =false;
                      //   aboutEdit = false;
                      // });

                    } catch (error) {
                      print('Error updating display name or creating user: $error');
                      // Handle error appropriately (e.g., show error message to user)
                    }
                  } else {
                    // Handle case where Namecon.text is empty
                    print('Namecon text is empty');
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: kprimary),
                child: const Center(
                  child: Text(
                    "Continue!",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),



              // ElevatedButton(
              //   onPressed: () async {
              //     if (Namecon.text.isNotEmpty) {
              //       try {
              //         // Update display name in Firebase Authentication
              //         await FirebaseAuth.instance.currentUser!.updateDisplayName(Namecon.text);
              //
              //         // After successfully updating display name, create user in Firestore
              //         await FireAuth.createuser();
              //
              //         if(Namecon.text.isNotEmpty )
              //         {
              //
              //           FireData().editProfile(Namecon.text, "Hell i'm new on chat now").then(
              //                   (value)
              //               {
              //                 // setState(() {
              //                 //   Namecon =false;
              //                 //   aboutEdit = false;
              //                 // });
              //               }
              //           );
              //
              //         }
              //       } catch (error) {
              //         print('Error updating display name or creating user: $error');
              //         // Handle error appropriately (e.g., show error message to user)
              //       }
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(backgroundColor: kprimary),
              //   child:const Center(child: Text(" Continue! ",style: TextStyle(color: Colors.black87),)
              //   ),
              // ),


            ],
          ),
        ),
      ) ,
    );

  }

}
