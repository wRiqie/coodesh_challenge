import 'package:english_dictionary/app/core/assets.dart';
import 'package:english_dictionary/app/core/extensions.dart';
import 'package:english_dictionary/app/core/mixins/validators_mixin.dart';
import 'package:english_dictionary/app/routes/app_routes.dart';
import 'package:english_dictionary/app/ui/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

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
                          'Seja bem vindo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Para entrar no app, por favor informe suas credenciais',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF333333)),
                        ),
                        const SizedBox(
                          height: 12,
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
                                      hintText: 'Senha',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                        child: const Text('Lembre-se de mim')),
                                  ],
                                );
                              },
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Esqueceu a senha?',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _signin,
                            child: const Text(
                              'Entrar',
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
                              backgroundColor: MaterialStatePropertyAll(
                                  colorScheme.background),
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
                              'Cadastre-se agora mesmo',
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
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        if (context.mounted) {
          ErrorSnackbar(
            context,
            message: result.error?.message ?? 'Ocorreu um erro inesperado',
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
}
