import 'package:flutter/material.dart';

import '../../widgets/bgcolorwidget.dart';

class ForgotPwd extends StatefulWidget {
  // const ForgotPwd({super.key});
  static const routeName = '/forgot-pwd';
  @override
  State<ForgotPwd> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  Widget buildEmail() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
              prefixIcon: Icon(
                Icons.email,
                color: Colors.teal,
              )),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildResetBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {},
        child: const Text('Reset Password'),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgotten Password'),
      ),
      body: BGColor(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Image(image: AssetImage('assets/images/forgetpwd.png')),
            Form(
                child: Column(
              children: [
                buildEmail(),
                buildResetBtn(),
                buildSigninRedirect(context),
              ],
            ))
          ]),
        ),
      ),
    );
  }
}
