import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../net/flutterfire.dart';
import '../../widgets/bgcolorwidget.dart';

class Registration extends StatefulWidget {
  static const routeName = '/user-register';
  // const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _pwdField = TextEditingController();
  final AuthService _auth = AuthService();
  final _pwdFocusNode = FocusNode();
  final _repwdFocusNode = FocusNode();

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
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_repwdFocusNode);
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: ' Re enter Password',
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.teal,
              )),
          focusNode: _repwdFocusNode,
        ),
      ],
    );
  }

  Widget buildSigninRedirect(BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.of(ctx).pushNamed('/login-user'),
      child: RichText(
          text: const TextSpan(children: [
        TextSpan(
          text: 'Have an account? ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        TextSpan(
            text: ' Sign In',
            style: TextStyle(
              fontSize: 18,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            )),
      ])),
    );
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
          User? createdUser =
              await _auth.createUser(_emailField.text, _pwdField.text);
          if (createdUser != null) {
            final String emailsub = '@concorde.sg';
            print(createdUser.email);
            createdUser.email!.contains(emailsub)
                ? Navigator.of(ctx)
                    .pushNamed('/init_admin', arguments: createdUser.email)
                : Navigator.of(ctx)
                    .pushNamed('/init', arguments: createdUser.email);
          }
        },
        child: const Text('SIGN UP'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' User Registration'),
        // actions: [
        //   // IconButton(
        //   //   onPressed: () => Navigator.of(context).pushNamed('/'),
        //   //   icon: const Icon(Icons.home),
        //   // ),
        //   // IconButton(
        //   //   onPressed: () => Navigator.of(context).pushNamed('/test-auth'),
        //   //   icon: const Icon(Icons.textsms_sharp),
        //   // ),
        // ],
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
                buildLoginBtn(context),
                buildSigninRedirect(context),
              ],
            ))
          ]),
        ),
      ),
    );
  }
}
