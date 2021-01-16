import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ar/helper_functions/shared_pre_helper.dart';
import 'package:flutter_chat_ar/services/database.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  ChatScreen(this.chatRoomId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String myName = "";
  Stream chatMessagedStream;

  TextEditingController messagetxtcontroller = TextEditingController();

  getMyInfoFromSharedPreferences() async {
    myName = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  getChats() async {
    chatMessagedStream =
        await DatabaseMethods().getChatMessages(widget.chatRoomId);
    setState(() {});
  }

  Widget messageList() {
    return StreamBuilder(
      stream: chatMessagedStream,
      builder: (context, snapshot) {
        print(snapshot.data);
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(top: 12, bottom: 70),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];

                  return messageTile(ds["message"], ds["sendBy"]);
                },
              )
            : Container(child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget messageTile(String message, String sendBy) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.only(
              left: sendBy == myName ? 50 : 12,
              right: sendBy == myName ? 12 : 50),
          alignment:
              sendBy == myName ? Alignment.centerRight : Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Container(
            //margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
                color: Color(0xfff1f0f0),
                gradient: LinearGradient(
                  colors: sendBy == myName
                      ? [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC),
                        ]
                      : [
                          const Color(0xff888888),
                          const Color(0xfff1f0f0),
                        ],
                ),
                borderRadius: sendBy == myName
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23))),
            child: Text(
              message,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: sendBy == myName ? Colors.white : Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  sendMessage() async {
    var ts = DateTime.now();
    DateTime now = ts;
    String formattedTime = DateFormat.jm().format(now);
    print(formattedTime);

    Map<String, dynamic> messageData = {
      "message": messagetxtcontroller.text,
      "sendBy": myName,
      "time": formattedTime
    };

    await DatabaseMethods().addMessage(widget.chatRoomId, messageData);

    Map<String, dynamic> updatedData = {
      "last_message": messagetxtcontroller.text,
      "sendBy": myName,
      "last_message_ts": formattedTime
    };

    await DatabaseMethods().updateLastMessage(widget.chatRoomId, updatedData);

    messagetxtcontroller.text = "";
  }

  @override
  void initState() {
    getMyInfoFromSharedPreferences();
    getChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.chatRoomId.replaceAll(myName, "").replaceAll("_", "")),
      ),
      body: Container(
        child: Stack(
          children: [
            messageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.blue.shade200,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messagetxtcontroller,
                        decoration: InputDecoration(
                          hintText: "enter a message",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (messagetxtcontroller.text != null) {
                          sendMessage();
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(6),
                          color: Colors.blue,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
