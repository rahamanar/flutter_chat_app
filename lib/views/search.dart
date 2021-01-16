import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ar/helper_functions/shared_pre_helper.dart';
import 'package:flutter_chat_ar/services/database.dart';
import 'package:flutter_chat_ar/views/chat_screen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController usernamecontroller = TextEditingController();

  QuerySnapshot querySnapshot;

  onSearchIconClick() async {
    querySnapshot =
        await DatabaseMethods().searchUserByUsername(usernamecontroller.text);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Search"),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(hintText: "username"),
                )),
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                    onTap: () {
                      onSearchIconClick();
                    },
                    child: Icon(Icons.search)),
              ],
            ),
            querySnapshot != null
                ? ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SearchUserTile(
                        email: querySnapshot.docs[index]["email"],
                        username: querySnapshot.docs[index]["username"],
                      );
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class SearchUserTile extends StatelessWidget {
  final String email, username;

  SearchUserTile({this.email, this.username});

  Future<String> getChatRoomId(String searchUsername) async {
    String myUsername = await SharedPreferenceHelper().getUserName();
//codeUnitAt(0) is used here to compare the characters like r>c
    print("$myUsername");

    if (myUsername.substring(0).codeUnitAt(0) >
        searchUsername.substring(0).codeUnitAt(0)) {
      return "${searchUsername}_$myUsername";
    } else {
      return "${myUsername}_$searchUsername";
    }
  }

  Future createChatRoom(
      String username, String chatRoomId, BuildContext context) async {
    String myUsername = await SharedPreferenceHelper().getUserName();

    List<String> users = [username, myUsername];

    Map<String, dynamic> chatRoomData = {"users": users};
    if (username != myUsername) {
      await DatabaseMethods()
          .createChatRoom(await getChatRoomId(username), chatRoomData);
      sendMessage(myUsername, chatRoomId);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoomId),
          ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          content: Text(
            "You Want to chat with your self or what!?😄",
            style: TextStyle(color: Colors.black),
          )));
    }
  }

  sendMessage(String myusername, String chatRoomId) async {
    Map<String, dynamic> messageData = {
      "message": "Hey",
      "sendBy": myusername,
      "time": DateTime.now().microsecondsSinceEpoch
    };
    await DatabaseMethods().addMessage(chatRoomId, messageData);

    Map<String, dynamic> updatedData = {
      "last_message": "hey",
      "sendBy": myusername,
      "last_message_ts": DateTime.now().microsecondsSinceEpoch
    };

    await DatabaseMethods().updateLastMessage(chatRoomId, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            email,
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              String chatRoomId = await getChatRoomId(username);
              DatabaseMethods()
                  .checkIfChatRoomExists(chatRoomId)
                  .then((value) async {
                DocumentSnapshot documentSnapshot = value;
                if (documentSnapshot.data() != null) {
                  print(documentSnapshot.data());
                  print("chat room exists");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chatRoomId),
                      ));
                } else {
                  print("chat room does not exists");
                  await createChatRoom(username, chatRoomId, context);
                  //send user to chat screen

                }
              });
            },
            child: Icon(
              Icons.message,
            ),
          ),
        ],
      ),
    );
  }
}
