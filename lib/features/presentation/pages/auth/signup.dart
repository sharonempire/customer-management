import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/authentification/controller/auth_controller.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/consts/images.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrimPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.read(authControllerProvider.notifier);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(ImageConsts.logo)),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset(ImageConsts.logo),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    height10,
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    height10,
                    TextFormField(
                      controller: confrimPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password again';
                        }
                        return null;
                      },
                    ),
                    height20,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await authProvider.signUp(
                                email: usernameController.text,
                                password: passwordController.text,
                                context: context,
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.blue,
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            elevation: WidgetStatePropertyAll(4),
                            padding: WidgetStatePropertyAll(
                              const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 12,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        RichText(
                          text: TextSpan(
                            text: 'Click to ',
                            children: [
                              TextSpan(
                                text: 'login',
                                style: TextStyle(color: Colors.blue),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        context.go(RouterConsts().login.route);
                                      },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
