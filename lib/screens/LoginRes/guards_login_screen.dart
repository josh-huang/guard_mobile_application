import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const routeName = '/login-guard';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _guardId = TextEditingController();
  // const Login({super.key});

  Widget buildId() {
    return Column(
      children: [
        TextFormField(
          controller: _guardId,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Guard ID',
              prefixIcon: Icon(
                Icons.person,
                color: Colors.teal,
              )),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: () {},
        child: const Text('LOGIN'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guard Login'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/'),
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.teal,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
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
                buildId(),
                buildLoginBtn(),
              ],
            ))
          ]),
        ),
      ),
    );
  }
}
