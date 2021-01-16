import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ar/helper_functions/shared_pre_helper.dart';
import 'package:flutter_chat_ar/services/auth.dart';
import 'package:flutter_chat_ar/services/database.dart';
import 'package:flutter_chat_ar/views/chat_screen.dart';
import 'package:flutter_chat_ar/views/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username;
  Stream chatStream;

  getUserName() async {
    username = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  getMyChats() async {
    chatStream = await DatabaseMethods().getMyChats();

    setState(() {});
  }

  @override
  void initState() {
    getUserName();
    getMyChats();
    super.initState();
  }

  Widget chatList() {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data.documents.length == 0) {
          return noDataTile();
        } else {
          return snapshot.hasData
              ? ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 4,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return chatTile(ds.id, ds["last_message"],
                        ds["last_message_ts"].toString());
                  },
                )
              : Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget noDataTile() {
    return Center(
      child: Text("No chats yet!"),
    );
  }

  Widget chatTile(String chatRoomId, String lastMessage, String ts) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(chatRoomId),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(6)),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade100,
              child: Text(
                chatRoomId
                    .replaceAll(username, "")
                    .replaceAll("_", "")
                    .substring(0, 1)
                    .toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${chatRoomId.replaceAll(username, "").replaceAll("_", "")[0].toUpperCase()}${chatRoomId.replaceAll(username, "").replaceAll("_", "").substring(1).toLowerCase()}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          ts,
                          //  ts.replaceRange(4, ts.length, ""),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //${this[0].toUpperCase()}${this.substring(1)} use this to make the first letter of word caps
        title: Text("Hey ${username[0].toUpperCase()}${username.substring(1)}"),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
