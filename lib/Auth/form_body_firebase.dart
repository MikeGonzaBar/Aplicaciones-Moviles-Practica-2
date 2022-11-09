import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:practica1/credentials/credentials.dart';
import 'package:practica1/pages/home_page.dart';

class FormBodyFirebase extends StatelessWidget {
  const FormBodyFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    // return SignInScreen(
    //   showAuthActionSwitch: false,
    //   headerBuilder: ((context, constraints, breakpoint) {
    //     return Image.asset('assets/images/listening.gif');
    //   }),
    //   providerConfigs: [GoogleProviderConfiguration(clientId: googleKey)],
    //   actions: [
    //     AuthStateChangeAction<SignedIn>((context, state) {
    //       Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(
    //           builder: (context) => HomePage(),
    //         ),
    //       );
    //     }),
    //   ],
    // );
    return Stack(
      children: <Widget>[
        Container(
          width: (MediaQuery.of(context).size.width),
          height: (MediaQuery.of(context).size.height),
          color: Colors.red,
        ),
        SignInScreen(
          showAuthActionSwitch: false,
          headerBuilder: ((context, constraints, breakpoint) {
            return Image.asset('assets/images/listening.gif');
          }),
          providerConfigs: const [
            GoogleProviderConfiguration(clientId: googleKey)
          ],
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
