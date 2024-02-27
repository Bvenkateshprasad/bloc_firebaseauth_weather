import 'package:firebase_auth_bloc_weather/auth/register_screen.dart';
import 'package:firebase_auth_bloc_weather/blocs/bloc/auth_bloc.dart';
import 'package:firebase_auth_bloc_weather/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign In Screen"),
          centerTitle: true,
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              snackbar(context, state.error);
            }
            if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text("No Account yet ? Sign Up")),
                ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLoginRequested(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim()));
                    },
                    child: const Text("Login"))
              ],
            );
          },
        ));
  }
}
