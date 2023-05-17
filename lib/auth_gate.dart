import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart ';
import 'package:flutterfire_ui/auth.dart';

import 'helpers/bt/bluetooth_connection.dart';
import 'home.dart';
import 'home_screen.dart';

final BleServiceReader bleServiceReader = BleServiceReader();

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: const [
              EmailProviderConfiguration(),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 0.5,
                  child: SvgPicture.asset('assets/images/Logo.svg'),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text(
                        'Bem vindo ao Angel Care, por favor faça login!')
                    : const Text(
                        'Bem vindo ao Angel Care, por favor crie uma conta!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Ao Entrar você concorda com nossos termos e condições',

                  ///style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 0.5,
                  child: SvgPicture.asset('assets/images/Logo.svg'),
                ),
              );
            },
          );
        }
        return HomeScreenn(
          bleServiceReader: bleServiceReader,
        );
      },
    );
  }
}
