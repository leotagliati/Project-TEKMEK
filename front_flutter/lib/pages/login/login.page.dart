import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '_compose/dashboard_screen.dart';

const users = {'a@gmail.com': '12345', 'hunter@gmail.com': 'hunter'};

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/tekmek_logo.png'),
      title: 'Seja bem-vindo!',
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      },
      onRecoverPassword: _recoverPassword,

      // ========= INÍCIO DA PERSONALIZAÇÃO =========
      theme: LoginTheme(
        primaryColor: const Color.fromARGB(255, 83, 83, 83),
        // Cor principal, usada nos botões e destaques
        pageColorLight: const Color(0xFFF5F5F5),
        pageColorDark: const Color(0xFFF5F5F5),

        // Estilo do título "Tekmek"
        titleStyle: const TextStyle(
          color: const Color.fromARGB(255, 83, 83, 83),
          fontSize: 28,
          height: 1.2,
        ),

        bodyStyle: const TextStyle(
      
         color:const Color.fromARGB(255, 83, 83, 83),
        ),



        // Estilo dos campos de texto (email, senha)
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),

        // Estilo do texto do botão
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

      // Para mudar os textos (labels, botões, etc.)
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
        recoverPasswordDescription: 'Você receberá um e-mail com instruções',
        recoverPasswordSuccess: 'Senha recuperada com sucesso',
      ),

      // ========= FIM DA PERSONALIZAÇÃO =========
    );
  }
}
