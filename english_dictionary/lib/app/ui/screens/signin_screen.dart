import '../../core/assets.dart';
import '../../core/extensions.dart';
import '../../core/helpers/preferences_helper.dart';
import '../../core/mixins/validators_mixin.dart';
import '../../routes/app_routes.dart';
import '../widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../core/constants.dart';
import '../../core/helpers/session_helper.dart';
import '../../core/snackbar.dart';
import '../../data/repositories/auth_repository.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> with ValidatorsMixin {
  final authRepository = GetIt.I<AuthRepository>();
  final preferencesHelper = GetIt.I<PreferencesHelper>();

  final formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isLoading = ValueNotifier(false);
  final revealText = ValueNotifier(false);
  final rememberMe = ValueNotifier(true);

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();

    isLoading.dispose();
    revealText.dispose();
    rememberMe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).height * .9,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SvgPicture.asset(
                          Assets.loginIllustration,
                          height: MediaQuery.of(context).height * .25,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Welcome',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'To enter the app, please enter your credentials',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF333333)),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailCtrl,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                ),
                                validator: (value) => combine([
                                  () => isNotEmpty(value),
                                  () => isValidEmail(value),
                                ]),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              ValueListenableBuilder(
                                valueListenable: revealText,
                                builder: (context, value, child) {
                                  return TextFormField(
                                    controller: passwordCtrl,
                                    textInputAction: TextInputAction.send,
                                    onFieldSubmitted: (_) => _signin(),
                                    obscureText: !revealText.value,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          revealText.value = !revealText.value;
                                        },
                                        icon: Icon(revealText.value
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                    ),
                                    validator: (value) => combine([
                                      () => isNotEmpty(value),
                                      () => isValidPassword(value),
                                    ]),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: rememberMe,
                          builder: (context, value, child) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  child: Checkbox(
                                    value: value,
                                    onChanged: (val) {
                                      _toggleRememberMe(value: val);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                GestureDetector(
                                    onTap: _toggleRememberMe,
                                    child: const Text('Remember me')),
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _signin,
                            child: const Text(
                              'Enter',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _signup,
                            style: ButtonStyle(
                              elevation: const MaterialStatePropertyAll(0),
                              backgroundColor:
                                  MaterialStatePropertyAll(colorScheme.surface),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: BorderSide(
                                    width: 3,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              'Register now',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: colorScheme.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

  void _signin() async {
    if (formKey.currentState?.validate() ?? false) {
      if (!(await checkConnection())) {
        if (context.mounted) {
          AlertSnackbar(context,
              message:
                  'You need to be connected to the internet, check your connection');
        }
        return;
      }
      isLoading.value = true;
      var result = await authRepository.signIn(
        emailCtrl.text,
        passwordCtrl.text,
      );

      if (result.isSuccess && result.data != null) {
        var sessionHelper = GetIt.I<SessionHelper>();
        await sessionHelper.saveSession(
          result.data!,
          rememberMe: rememberMe.value,
        );
        isLoading.value = false;

        if (context.mounted) {
          var alreadySavedWords =
              preferencesHelper.getBool(Constants.alreadySavedWords);

          alreadySavedWords
              ? Navigator.pushReplacementNamed(context, AppRoutes.dashboard)
              : Navigator.pushReplacementNamed(context, AppRoutes.prepare);
        }
      } else {
        if (context.mounted) {
          ErrorSnackbar(
            context,
            message: result.error?.message,
          );
        }
      }

      isLoading.value = false;
    }
  }

  void _signup() {
    Navigator.pushNamed(context, AppRoutes.signup);
  }

  void _toggleRememberMe({bool? value}) {
    rememberMe.value = value ?? !rememberMe.value;
  }

  Future<bool> checkConnection() {
    var checker = InternetConnectionCheckerPlus.createInstance();
    return checker.hasConnection;
  }
}
