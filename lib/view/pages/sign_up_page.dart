import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/components/authentication/auth_button.dart';
import 'package:intellistudy/view/components/authentication/auth_confirm_password_field.dart';
import 'package:intellistudy/view/components/authentication/auth_text_field.dart';
import '../../controllers/auth_method_status_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  //  GlobalKey is used to validate the Form
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer(builder: (context, ref, _) {
          final auth = ref.watch(authProvider);
          final isLoading = ref.watch(firstIsLoadingStateProvider);
          final emailText = ref.watch(emailTextProvider);
          final passwordText = ref.watch(passwordTextProvider);
          final authStatus = ref.watch(authStatusNotifierProvider);

          Future<void> onAuthPress() async {
            if (!formKey.currentState!.validate()) {
              return;
            }
            if (ref.read(authStatusNotifierProvider.notifier).status ==
                Status.login) {
              ref.read(firstIsLoadingStateProvider.notifier).state =
                  !ref.read(firstIsLoadingStateProvider.notifier).state;
              await auth.signInWithEmailAndPassword(
                  emailText.text, passwordText.text, context);
            } else {
              ref.read(firstIsLoadingStateProvider.notifier).state =
                  !ref.read(firstIsLoadingStateProvider.notifier).state;
              await auth.signUpWithEmailAndPassword(
                  emailText.text, passwordText.text, context);
            }
          }

          return Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(top: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: FlutterLogo(size: 81)),
                        const Spacer(flex: 1),
                        AuthTextField(
                          textController: emailText,
                          hintText: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboard: TextInputType.emailAddress,
                          obscureText: false,
                          validator: (value) {
                            // TODO: Create more conditional checks
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                        ),
                        AuthTextField(
                          textController: passwordText,
                          hintText: 'Password',
                          icon: Icons.lock,
                          keyboard: TextInputType.text,
                          obscureText: true,
                          validator: (value) {
                            // TODO: Create more conditional checks
                            if (value!.isEmpty || value.length < 8) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                        ),
                        if (ref.read(authStatusNotifierProvider) ==
                            Status.signUp)
                          AuthConfirmPasswordField(
                            validator: ref.read(authStatusNotifierProvider) ==
                                    Status.signUp
                                ? (value) {
                                    if (value != passwordText.text) {
                                      return 'Passwords do not match!';
                                    }
                                    return null;
                                  }
                                : null,
                          ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 32.0),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : AuthButton(
                                  onPressed: onAuthPress,
                                  statusText: authStatus == Status.login
                                      ? 'Log in'
                                      : 'Sign up',
                                ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: RichText(
                            text: TextSpan(
                              text: authStatus == Status.login
                                  ? 'Don\'t have an account? '
                                  : 'Already have an account? ',
                              style: const TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: authStatus == Status.login
                                      ? 'Sign up now'
                                      : 'Log in',
                                  style: TextStyle(color: Colors.blue.shade700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      ref
                                          .read(authStatusNotifierProvider
                                              .notifier)
                                          .changeStatus();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
