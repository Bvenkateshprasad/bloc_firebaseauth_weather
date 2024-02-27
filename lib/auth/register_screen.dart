import 'package:firebase_auth_bloc_weather/auth/login_screen.dart';
import 'package:firebase_auth_bloc_weather/blocs/bloc/auth_bloc.dart';
import 'package:firebase_auth_bloc_weather/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
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
        return Scaffold(
            appBar: AppBar(
              title: const Text("SignUp Screen"),
              centerTitle: true,
            ),
            body: Column(
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
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text("Have Account ? Sign In")),
                ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthSignUpRequested(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim()));
                    },
                    child: const Text("Login"))
              ],
            ));
      },
    );
  }
}
