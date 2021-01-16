import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_ar/helper_functions/shared_pre_helper.dart';

class DatabaseMethods {
  Future uploadUserInfo(String email, String username) {
    return FirebaseFirestore.instance.collection("users").add({
      "email": email,
      "username": username,
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<QuerySnapshot> searchUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  Future<DocumentSnapshot> getUserUsername(String uid) {
    return FirebaseFirestore.instance.collection("users").doc(uid).get();
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future checkIfChatRoomExists(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
  }

  Future createChatRoom(String chatRoomId, Map chatRoomData) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .set(chatRoomData)
        .catchError((onError) {
      print(onError);
    });
  }

  Future addMessage(String chatRoomId, Map messageData) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageData)
        .catchError((onError) {
      print(onError);
    });
  }

  createChatroom(String usernameSearching) async {
    // create chatroom
    String myUsername = await SharedPreferenceHelper().getUserName();

    FirebaseFirestore.instance.collection("chatrooms").add({
      "last_message": "Hey",
      "last_message_ts": DateTime.now(),
      "user": [usernameSearching, myUsername]
    });
  }

  Future<Stream> getChatMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Stream> getMyChats() async {
    String myName = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .where("users", arrayContains: myName)
        .snapshots();
  }

  updateLastMessage(String chatRoomId, Map updatedData) {
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(updatedData);
  }
}
