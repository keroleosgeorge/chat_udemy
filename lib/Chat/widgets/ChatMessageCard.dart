import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_udemy/firebase/fire_database.dart';
import 'package:chat_udemy/models/message_model.dart';
import 'package:chat_udemy/utill/colors.dart';
import 'package:chat_udemy/utill/photo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:video_player/video_player.dart';


class ChatMessageCard extends StatefulWidget {
  const ChatMessageCard({super.key, required this.index, required this.messageItem, required this.rromId, required this.selected});
  final int index;
  final String rromId;
  final Message messageItem;
  final bool selected;


  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {

  VideoPlayerController? _controller;
  Future<void>? _initializedVideoplayer;
  @override
  void initState() {
   if(widget.messageItem.toId == FirebaseAuth.instance.currentUser!.uid){
     FireData().readMessage(widget.rromId, widget.messageItem.id!);
   }

   _controller = VideoPlayerController.network(widget.messageItem.msg!);
   _initializedVideoplayer = _controller!.initialize();
   _controller!.setLooping(true);

    super.initState();
  }


  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isMe = widget.messageItem.fromId == FirebaseAuth.instance.currentUser!.uid;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.selected ? Colors.lightBlue : Colors.transparent,
      ),
      margin: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end:MainAxisAlignment.start,
        children: [
          isMe ? IconButton(onPressed: (){}, icon: Icon(Iconsax.message_edit)) :SizedBox(),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(isMe ? 10 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            color: isMe ? Colors.grey : kprimary.withOpacity(0.5) ,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width /2 ,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //to show image in chat
                   widget.messageItem.type == 'image' ? GestureDetector(onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => photoView(image: widget.messageItem.msg!),))
                       ,child: Container(child: CachedNetworkImage(fit: BoxFit.contain, imageUrl: '${widget.messageItem.msg!}',),))
                       :
                   widget.messageItem.type == 'text' ?  Text(widget.messageItem.msg!,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                       :
                   Container(child:FutureBuilder(
                       future: _initializedVideoplayer, builder: (context, snapshot) {
                         if(snapshot.connectionState == ConnectionState.done)
                         {
                           return AspectRatio(aspectRatio: _controller!.value.aspectRatio,child: GestureDetector(
                               onTap: () {
                             setState(() {
                               if(_controller!.value.isPlaying)
                               {
                                 _controller!.pause();
                               }
                               else
                               {
                                 _controller!.play();
                               }
                             });
                           },child: VideoPlayer(_controller!)),);
                         }
                         else{
                           return Center(child: CircularProgressIndicator(),);
                         }
                       },
                   ),
                   ),


                  // widget.messageItem.type == 'text' ?  Text(widget.messageItem.msg!,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                  //     : Container(child: PdfView(path: '${widget.messageItem.msg!}',gestureNavigationEnabled: true,),)
                  //   ,

                    SizedBox(height: 7),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isMe ? Icon(Iconsax.tick_circle,color:widget.messageItem.read =="" ? Colors.grey: Colors.blueAccent,):SizedBox(),
                        SizedBox(width: 10),
                        Text(
                          DateFormat.Hms().format(
                              DateTime.fromMillisecondsSinceEpoch(
                              int.parse(widget.messageItem.createdAt!)
                          )
                          ).toString()
                        ),//دي علشان الوقت
                        SizedBox(width: 4),
                        Text(
                            DateFormat.yMMMEd().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(widget.messageItem.createdAt!)
                                )
                            ).toString(),
                          style: TextStyle(fontSize: 10),
                        ),//دي علشان التاريخ بتاع اليوم والشهر والسنة
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
