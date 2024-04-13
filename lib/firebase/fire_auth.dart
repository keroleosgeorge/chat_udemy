import 'package:chat_udemy/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth
{
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore Firestore = FirebaseFirestore.instance;

  static User user = auth.currentUser!;


  static Future<void> createuser()async
  {
    ChatUser chatUser = ChatUser(
        id: user.uid,
        name: user.displayName ?? "",
        email: user.email ?? "",
        about: "Hell i'm new on chat now",
        image: '',
        createdAt: DateTime.now().toString(),
        lastActivated: DateTime.now().toString(),
        puchToken: '',
        online: false,
         // myUsers: [],
    );
  await Firestore.collection('users').doc(user.uid).set(chatUser.tojson());
  }



  // static Future createuser()async
  // {
  //   ChatUser chatUser =  ChatUser(
  //       id: user.uid,
  //       name: user.displayName ?? "",
  //       email: user.email ?? "",
  //       about: "Hello i'm new on chat now",
  //       image: '',
  //       createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
  //       lastActivated: DateTime.now().millisecondsSinceEpoch.toString(),
  //       puchToken: '',
  //       online: false,
  //       myUsers: [],
  //
  //   );
  //   await firebaseFirestore.collection('users').doc(user.uid).set(chatUser.tojson());
  // }

  Future getToken(String token)async
  {
await Firestore.collection('users').doc(auth.currentUser!.uid).update({
  'puch_token' : token,
});
  }

  Future updateActivated (bool online)async
  {
    Firestore.collection('users').doc(user.uid).update({
      'online' : online,
      'last_activated' : DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

}