import 'package:english_dictionary/app/core/helpers/session_helper.dart';
import 'package:english_dictionary/app/core/mixins/validators_mixin.dart';
import 'package:english_dictionary/app/core/snackbar.dart';
import 'package:english_dictionary/app/data/models/register_model.dart';
import 'package:english_dictionary/app/routes/app_routes.dart';
import 'package:english_dictionary/app/ui/widgets/loader_widget.dart';
import 'package:english_dictionary/app/ui/widgets/title_wrapper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../data/repositories/auth_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with ValidatorsMixin {
  final authRepository = GetIt.I<AuthRepository>();
  final sessionHelper = GetIt.I<SessionHelper>();

  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  final isLoading = ValueNotifier(false);
  final obscurePass = ValueNotifier(true);
  final obscureConfPass = ValueNotifier(true);

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();

    isLoading.dispose();
    obscurePass.dispose();
    obscureConfPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Signup'),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: _signup,
                child: const Text('Register'),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TitleWrapperWidget(
                      title: 'Nome',
                      child: TextFormField(
                        controller: nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Digit a name',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: isNotEmpty,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TitleWrapperWidget(
                      title: 'Email',
                      child: TextFormField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Digit a email',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) => combine([
                          () => isNotEmpty(value),
                          () => isValidEmail(value),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ValueListenableBuilder(
                      valueListenable: obscurePass,
                      builder: (context, value, child) {
                        return TitleWrapperWidget(
                          title: 'Password',
                          child: TextFormField(
                            controller: passwordCtrl,
                            obscureText: obscurePass.value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key),
                              suffixIcon: IconButton(
                                icon: value
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  obscurePass.value = !obscurePass.value;
                                },
                              ),
                              hintText: 'Digit a password',
                            ),
                            textInputAction: TextInputAction.send,
                            onFieldSubmitted: (_) => _signup(),
                            validator: (value) => combine([
                              () => isNotEmpty(value),
                              () => isValidPassword(value),
                            ]),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ValueListenableBuilder(
                      valueListenable: obscureConfPass,
                      builder: (context, value, child) {
                        return TitleWrapperWidget(
                          title: 'Confirm password',
                          child: TextFormField(
                            controller: confirmPassCtrl,
                            obscureText: value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key),
                              suffixIcon: IconButton(
                                icon: value
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  obscureConfPass.value =
                                      !obscureConfPass.value;
                                },
                              ),
                              hintText: 'Re-enter the password',
                            ),
                            textInputAction: TextInputAction.send,
                            onFieldSubmitted: (_) => _signup(),
                            validator: (value) => combine([
                              () => isNotEmpty(value),
                              () => isValidPassword(value),
                            ]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, value, child) {
            return Visibility(
              visible: value,
              child: const LoaderWidget(),
            );
          },
        ),
      ],
    );
  }

  void _signup() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (passwordCtrl.text != confirmPassCtrl.text) {
      if (context.mounted) {
        AlertSnackbar(context, message: 'The passwords don\'t match');
      }
      return;
    }
    if (!(await checkConnection())) {
      if (context.mounted) {
        AlertSnackbar(context,
            message:
                'You need to be connected to the internet, check your connection');
      }
      return;
    }

    isLoading.value = true;
    var registerInfo = RegisterModel(
      nameCtrl.text,
      emailCtrl.text,
      passwordCtrl.text,
      '',
    );
    var response = await authRepository.signUp(registerInfo);
    if (response.isSuccess) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.signin, (route) => false);
        SuccessSnackbar(context,
            message: 'Registration successfully completed');
      }
    } else {
      if (context.mounted) {
        ErrorSnackbar(context, message: response.error?.message);
      }
    }

    isLoading.value = false;
  }

  Future<bool> checkConnection() {
    var checker = InternetConnectionCheckerPlus.createInstance();
    return checker.hasConnection;
  }
}
