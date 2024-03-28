import 'dart:io';

import 'package:chat_udemy/Chat/widgets/ChatMessageCard.dart';
import 'package:chat_udemy/firebase/fire_database.dart';
import 'package:chat_udemy/firebase/fire_storage.dart';
import 'package:chat_udemy/models/message_model.dart';
import 'package:chat_udemy/models/user_model.dart';
import 'package:chat_udemy/utill/colors.dart';
import 'package:chat_udemy/utill/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class Chat_screen extends StatefulWidget {
  final String roomId;
  final ChatUser chatUser;
  const Chat_screen({super.key, required this.roomId, required this.chatUser});

  @override
  State<Chat_screen> createState() => _Chat_screenState();
}

class _Chat_screenState extends State<Chat_screen> {
  TextEditingController msgcon = TextEditingController();
  List<String> selectedMsg = [];
  List<String> copyMsg = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatUser.name!,style: TextStyle(fontSize: 20)),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').
              doc(widget.chatUser.id).snapshots(),
              builder: (context, snapshot) {
               if(snapshot.hasData)
               {
                 return Text(snapshot.data!.data()!['online'] ? 'Online' : "Last activated ${myDateTime.dateAndTime(widget.chatUser.lastActivated!)} at ${myDateTime.timeDate(widget.chatUser.lastActivated!)}",style: TextStyle(
                   fontSize: 15,
                 ),);
               }else{
                 return Container();
               }
              }
            ),
          ],
        ),
        actions: [
         selectedMsg.isNotEmpty ? IconButton(
              onPressed: (){
            FireData().deleteMsg(widget.roomId, selectedMsg);
            setState(() {
              selectedMsg.clear();
              copyMsg.clear();
            });
          }, icon: Icon(Iconsax.trash)) : Container(),
          copyMsg.isNotEmpty ? IconButton(
              onPressed: (){
                Clipboard.setData(ClipboardData(text: copyMsg.join(' \n ')));
                setState(() {
                  copyMsg.clear();
                  selectedMsg.clear();
                });
          }, icon: Icon(Iconsax.copy)) : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child:
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('rooms').
                doc(widget.roomId).collection('messages').
                snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<Message> messageItems = snapshot.data!.docs.map(
                            (e) => Message.fromjson(e.data())
                    ).toList()..sort(
                      (a, b) => b.createdAt!.compareTo(a.createdAt!),
                    );
                    return messageItems.isNotEmpty ? ListView.builder(
                      itemCount: messageItems.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return  GestureDetector(
                          onTap: () {
                           setState(() {
                             selectedMsg.isNotEmpty ? selectedMsg.contains(messageItems[index].id) ?
                             selectedMsg.remove(messageItems[index].id)
                                 :
                             selectedMsg.add(messageItems[index].id!)
                                 : null ;

                             copyMsg.isNotEmpty ?
                             messageItems[index].type == 'text' ?
                             copyMsg.contains(messageItems[index].msg) ?
                             copyMsg.remove(messageItems[index].msg!)
                                 :
                             copyMsg.add(messageItems[index].msg!) : null : null ;
                           });
                          },
                          onLongPress: () {
                            setState(() {
                              selectedMsg.contains(messageItems[index].id) ?
                              selectedMsg.remove(messageItems[index].id)
                                  :
                              selectedMsg.add(messageItems[index].id!);

                              messageItems[index].type == 'text' ?
                              copyMsg.contains(messageItems[index].msg) ?
                                  copyMsg.remove(messageItems[index].msg!)
                                  :
                                  copyMsg.add(messageItems[index].msg!) : null;



                            });
                          },
                          child: ChatMessageCard(
                            selected:  selectedMsg.contains(messageItems[index].id),
                            rromId: widget.roomId,
                            messageItem: messageItems[index],
                            index: index,
                          ),
                        );
                      },
                    ) :
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Fluttertoast.showToast(
                          //   msg: "This is a toast To Say Hi",
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.BOTTOM,
                          //   backgroundColor: Colors.white,
                          //   textColor: Colors.black87,
                          // );
                          FireData().sendMessage(widget.chatUser.id!, 'Say Hi For first Meessage 👋', widget.roomId,widget.chatUser,context);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('👋',style: TextStyle(fontSize: 50),),
                                Text('Say Hi'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();

                }
              ),

            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: TextField(
                      controller: msgcon,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        suffix: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton.filledTonal(onPressed: () async{
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                              allowedExtensions: ['pdf','mp4','word','jpg','png','jpeg','ppt','wav','mp3',]);

                              if (result != null) {
                                File file = File(result.files.single.path!);
                                FireStorage().sendfile(file: File(file.path), roomId: widget.roomId,
                                    uid: widget.chatUser.id!, chatUser: widget.chatUser, context: context);
                                // PdfView(path: file.path);
                              }
                            }, icon: Icon(Iconsax.emoji_happy5)),
                            SizedBox(width: 5),
                            IconButton.filledTonal(
                              onPressed: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? image = await picker.pickImage(source: ImageSource.gallery);

                                if(image != null)
                                {
                                  FireStorage().sendimage(
                                      file: File(image.path), roomId: widget.roomId,uid: widget.chatUser.id!,
                                      context: context,chatUser: widget.chatUser);
                                }
                            }, icon: Icon(Iconsax.camera),),
                          ],
                        ),
                        border: InputBorder.none,
                        hintText: "Message",
                        contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                IconButton.filled(onPressed: (){
                  if(msgcon.text.isNotEmpty){
                    FireData().sendMessage(widget.chatUser.id!, msgcon.text, widget.roomId,widget.chatUser,context).then(
                            (value) {
                              msgcon.text = "";
                            }
                    );
                  }
                }, icon: Icon(Iconsax.send_1)),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void openFile(PlatformFile file)
  {
    OpenFile.open(file.path!);
  }

}
