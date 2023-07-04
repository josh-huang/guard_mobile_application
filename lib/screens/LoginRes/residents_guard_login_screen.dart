import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../net/flutterfire.dart';
import '../../pages/NavBar/admin_nav_bar.dart';
import '../../pages/NavBar/guards_nav_bar.dart';
import '../../widgets/Splash.dart';
import '../../widgets/bgcolorwidget.dart';

class LoginUser extends StatefulWidget {
  static const routeName = '/login-user';
  // const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _pwdField = TextEditingController();
  final _pwdFocusNode = FocusNode();
  final AuthService _auth = AuthService();

  Widget buildEmail() {
    return Column(
      children: [
        TextFormField(
          controller: _emailField,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: Colors.teal,
              )),
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_pwdFocusNode);
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      children: [
        TextFormField(
          controller: _pwdField,
          obscureText: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.teal,
              )),
          focusNode: _pwdFocusNode,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget buildForgetPwdRedirect(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(ctx).pushNamed('/forgot-pwd'),
          child: RichText(
              text: const TextSpan(children: [
            TextSpan(
                text: 'Forget Password?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                )),
          ])),
        ),
      ],
    );
  }

  void guardHomePage(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: ((_) => GuardsNav())));
  }

  void adminHomePage(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: ((_) => AdminNav())));
  }

  Widget buildLoginBtn(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () async {
          User? verifiedUser = await _auth.signInUser(
              _emailField.text.trim(), _pwdField.text.trim());
          print(verifiedUser!.email);
          if (verifiedUser != null) {
            const String emailsub = '007';
            // print(verifiedUser.email);
            verifiedUser.email!.contains(emailsub)
                ? adminHomePage(ctx)
                : guardHomePage(ctx);
          }
        },
        child: const Text('LOGIN'),
      ),
    );
  }

  Widget buildSignupRedirect(BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.of(ctx).pushNamed('/user-register'),
      child: RichText(
          text: const TextSpan(children: [
        TextSpan(
          text: ' Don\'t have an account? ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        TextSpan(
            text: ' Sign Up',
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            )),
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: () => Splash(),
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: BGColor(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Image(image: AssetImage('assets/images/vanimage.png')),
            const Image(image: AssetImage('assets/images/logobg.png')),
            const SizedBox(
              height: 10,
            ),
            Form(
                child: Column(
              children: [
                buildEmail(),
                buildPassword(),
                buildForgetPwdRedirect(context),
                buildLoginBtn(context),
                // buildSignupRedirect(context),
              ],
            ))
          ]),
        ),
      ),
    );
  }
}
