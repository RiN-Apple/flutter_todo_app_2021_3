import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/main.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    Future<void> _LogInWithGoogle() async {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      final googleAuth = await googleUser!.authentication;
      // クレデンシャルを新しく作成
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //認証内容をFirebaseに登録
      await _auth.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => LoginCheck()), (_) => false);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('TODOアプリ'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('ログインしてください'),
          SignInButton(
            Buttons.GoogleDark,
            text: "Sign up with Google",
            onPressed: _LogInWithGoogle,
          ),
        ]),
      ),
    );
  }
}
