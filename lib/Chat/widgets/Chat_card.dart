import 'package:chat_udemy/Chat/Chat_screen.dart';
import 'package:chat_udemy/models/message_model.dart';
import 'package:chat_udemy/models/room_model.dart';
import 'package:chat_udemy/models/user_model.dart';
import 'package:chat_udemy/utill/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';

class Chat_Card extends StatelessWidget {
  final ChatRoom item;
  const Chat_Card({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    List member =item.members!.where(

            (element) => element != FirebaseAuth.instance.currentUser!.uid).toList();


    String userId = member.isEmpty ? FirebaseAuth.instance.currentUser!.uid : member.first;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          ChatUser chatUser = ChatUser.fromjson(snapshot.data!.data()!);
          return Card(
            child: ListTile(
              onTap: () =>
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      Chat_screen(
                        chatUser: chatUser,
                        roomId: item.id!,
                      ),)),
              leading:chatUser.image == "" ? FullScreenWidget(disposeLevel: DisposeLevel.High,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/chat_image_com.jpg"),
              )
              )
                  :
              FullScreenWidget(disposeLevel: DisposeLevel.High,
              child: CircleAvatar(backgroundImage: NetworkImage(chatUser.image!), )),
              title: Text(chatUser.name!),
              subtitle: Text(item.lastMessage! == "" ? chatUser.about! : item.lastMessage!,maxLines: 1,overflow: TextOverflow.ellipsis),
              trailing: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('rooms').
                  doc(item.id).collection('messages').
                  snapshots(),
                  builder: (context, snapshot) {
                    final unReadList = snapshot.data?.docs.
                    map((e) => Message.fromjson(e.data())).
                    where((element) => element.read == "").
                    where((element) => element.fromId != FirebaseAuth.instance.currentUser!.uid) ?? [];
                    return unReadList.length != 0 ?
                    Badge(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      largeSize: 30,
                      label: Text(unReadList.length.toString()),
                    ) :Text(myDateTime.dateAndTime(item.lastMessageTime!));
                  },
              ),
            ),
          );
        }
        else{
          return Container();
        }
      }
    );;
  }
}
