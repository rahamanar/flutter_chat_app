import 'package:flutter/material.dart';
import 'package:flutter_chat_ar/services/auth.dart';
import 'package:flutter_chat_ar/views/signup.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailtxtcontroller = TextEditingController();
  TextEditingController passwordtxtcontroller = TextEditingController();

  bool isLoding = false;

  onSignInBtnClick(BuildContext context) {
    if (emailtxtcontroller.text != "" && passwordtxtcontroller.text != "") {
      setState(() {
        isLoding = true;
      });
      AuthMethods()
          .signInWithEmailAndPassword(
              emailtxtcontroller.text, passwordtxtcontroller.text, context)
          .then((value) {
        setState(() {
          isLoding = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterChatApp"),
        elevation: 0,
      ),
      body: isLoding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: double.infinity,
                          child: Image.asset(
                            "Assets/images/signin.png",
                          )),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextField(
                            controller: emailtxtcontroller,
                            decoration: InputDecoration(hintText: "email"),
                          ),
                          TextField(
                            controller: passwordtxtcontroller,
                            obscureText: true,
                            decoration: InputDecoration(hintText: "password"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("forgot password"),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              onSignInBtnClick(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Color(0xffffffff)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUp(),
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Signup Now",
                                      style: TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
