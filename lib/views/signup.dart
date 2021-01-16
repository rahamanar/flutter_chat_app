import 'package:flutter/material.dart';
import 'package:flutter_chat_ar/services/auth.dart';
import 'package:flutter_chat_ar/views/signin.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernametxtcontroller = TextEditingController();
  TextEditingController emailtxtcontroller = TextEditingController();
  TextEditingController passwordtxtcontroller = TextEditingController();

  bool showPass = true;
  //give showpass in the obscureText
  //on click of the icon make it to true using setstate

  bool isLoding = false;

  onSignUpBtnClick(BuildContext context) {
    setState(() {
      isLoding = true;
    });
    AuthMethods()
        .signUpWithEmailAndPassword(usernametxtcontroller.text,
            emailtxtcontroller.text, passwordtxtcontroller.text, context)
        .then((isSuccess) {
      if (!isSuccess) {
        setState(() {
          isLoding = false;
        });
      }
    });
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
                height: MediaQuery.of(context).size.height - 80,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: double.infinity,
                          child: Image.asset(
                            "Assets/images/signup.png",
                          )),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextField(
                            controller: usernametxtcontroller,
                            decoration: InputDecoration(
                              hintText: "username",
                            ),
                          ),
                          TextField(
                            controller: emailtxtcontroller,
                            decoration: InputDecoration(hintText: "email"),
                          ),
                          TextField(
                            obscureText: showPass,
                            controller: passwordtxtcontroller,
                            decoration: InputDecoration(
                              hintText: "password",
                              //suffixIcon: Icon(Icons.remove_red_eye),
                            ),
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
                              onSignUpBtnClick(context);
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
                                "Sign Up",
                                style: TextStyle(color: Color(0xffffffff)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have account?",
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
                                          builder: (context) => SignIn(),
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "SignIn Now",
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
