import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  // const Splash({super.key});

  void Residents(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('/login-user');
  }

  // void Guards(BuildContext ctx) {
  //   Navigator.of(ctx).pushNamed('/login-guard');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concorde Security'),
        // actions: [
        //   IconButton(
        //     onPressed: () => Navigator.of(context).pushNamed('/welcome_page'),
        //     icon: const Icon(Icons.home_work_outlined),
        //   )
        // ],
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Image(image: AssetImage('assets/images/vanimage.png')),
            const Image(image: AssetImage('assets/images/logobg.png')),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 40),
                    backgroundColor: Color.fromARGB(223, 250, 250, 250),
                    foregroundColor: Colors.black87),
                icon: const Icon(Icons.people),
                onPressed: () => Residents(context),
                label: const Text('Residents/Tenants/Guards'),
              ),
            ),
            // SizedBox(
            //   width: 180,
            //   child: ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //         minimumSize: const Size(100, 40),
            //         backgroundColor: Color.fromARGB(223, 250, 250, 250),
            //         foregroundColor: Colors.black87),
            //     icon: const Icon(Icons.person),
            //     onPressed: () => Guards(context),
            //     label: const Text('Guards'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
