import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:practica1/credentials/credentials.dart';
import 'package:practica1/pages/home_page.dart';

class FormBodyFirebase extends StatelessWidget {
  const FormBodyFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      showAuthActionSwitch: false,
      headerBuilder: ((context, constraints, breakpoint) {
        return Text('Header');
      }),
      providerConfigs: [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(clientId: googleKey)
      ],
      footerBuilder: (context, action) {
        return Text('Footer');
      },
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }),
      ],
    );
  }
}
