import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:front_flutter/api/auth_service.dart';
import 'package:front_flutter/utils/auth_provider.dart';
import 'package:front_flutter/utils/request_handler.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<String?> _authUser(BuildContext context, LoginData data) async {
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.login(data.name, data.password);
      return null;
    } on ApiException catch (e) {
      return e.message;
    } on NetworkException catch (e) {
      return e.toString();
    } catch (e) {
      return 'Ocorreu um erro inesperado: ${e.toString()}';
    }
  }

  Future<String?> _handleSignup(BuildContext context, SignupData data) async {
    final authService = AuthService();

    final authProvider = context.read<AuthProvider>(); // //

    if (data.name == null || data.password == null) {
      return 'Email e Senha são obrigatórios';
    }

    try {
      await authService.register(data.name!, data.password!);

      await authProvider.login(data.name!, data.password!); // //

      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 409) {
        return 'Este usuário já existe.';
      }

      return e.message;
    } on NetworkException catch (e) {
      return e.toString();
    } catch (e) {
      return 'Ocorreu um erro inesperado: ${e.toString()}';
    }
  }

  Future<String?> _recoverPassword(BuildContext context, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return 'Função de recuperação de senha não está disponível no momento.';
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('images/tekmek_logo.png'),

      title: 'Seja bem-vindo!',

      onLogin: (data) => _authUser(context, data),

      onSignup: (data) => _handleSignup(context, data),

      onRecoverPassword: (name) => _recoverPassword(context, name),

      onSubmitAnimationCompleted: () {
        GoRouter.of(context).pushReplacement('/');
      },

      theme: LoginTheme(
        primaryColor: const Color.fromARGB(255, 83, 83, 83),

        pageColorLight: const Color(0xFFF5F5F5),

        pageColorDark: const Color(0xFFF5F5F5),

        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 83, 83, 83),

          fontSize: 28,

          height: 1.2,
        ),

        bodyStyle: const TextStyle(color: Color.fromARGB(255, 83, 83, 83)),

        inputTheme: InputDecorationTheme(
          filled: true,

          fillColor: Colors.white.withOpacity(0.5),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),

        buttonTheme: LoginButtonTheme(
          splashColor: const Color.fromARGB(255, 118, 205, 245),

          backgroundColor: const Color.fromARGB(255, 36, 100, 238),

          highlightColor: Colors.lightBlue,

          elevation: 9.0,

          highlightElevation: 6.0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      messages: LoginMessages(
        userHint: 'E-mail',

        passwordHint: 'Senha',

        loginButton: 'Acessar a plataforma',

        signupButton: 'Criar Conta',

        forgotPasswordButton: 'Esqueceu a senha?',

        recoverPasswordButton: 'Enviar',

        goBackButton: 'Cancelar',

        confirmPasswordHint: 'Confirmar Senha',

        recoverPasswordIntro: 'Digite seu e-mail para recuperar sua senha',

        recoverPasswordDescription: 'Enviaremos instruções para o seu e-mail.',

        recoverPasswordSuccess: 'E-mail enviado com sucesso!',
      ),
    );
  }
}
