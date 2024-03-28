
import 'package:chat_udemy/Chat/Chat_screen.dart';
import 'package:chat_udemy/Chat/widgets/Chat_card.dart';
import 'package:chat_udemy/firebase/fire_database.dart';
import 'package:chat_udemy/models/room_model.dart';
import 'package:chat_udemy/utill/custom_text_filed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            showBottomSheet(context: context,
                builder: (context) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text("Enter your friend email 😘",style: TextStyle(fontSize: 16)),
                            Spacer(),
                            IconButton.filled(onPressed: (){}, icon: Icon(Iconsax.scan_barcode)),
                          ],
                        ),
                        custum_text_field(
                          lable: "Email",
                          icon: Iconsax.direct,
                            controller: emailcontroller,
                            Hinttext: ' Enter the email ',
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if(emailcontroller.text.isNotEmpty){
                              FireData().createRoom(emailcontroller.text).then(
                                      (value){
                                        setState(() {
                                          emailcontroller.text="";
                                        });
                                        Navigator.pop(context);
                                      });

                            }

                          },
                          child: Center(child: Text('create chat'),),
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            padding: EdgeInsets.symmetric(vertical:15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                        ),
                        ),
                      ],
                    ),
                  );
                },
            );
          },
        child: const Icon(Iconsax.message_add),
      ),
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body:  Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('rooms').
                where('members',arrayContains: FirebaseAuth.instance.currentUser!.uid).
                snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<ChatRoom> items = snapshot.data!.docs.map(
                            (e) => ChatRoom.fromjson(e.data())).toList()..
                    sort((a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!),);
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Chat_Card(
                          item: items[index],
                        );
                      },
                    );
                  }
                  else{
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.onBackground,
                      ),
                    );
                  }

                }
              ),
            ),

          ],
        ),
      ),
    );
  }
}
