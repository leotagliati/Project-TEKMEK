import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Função de login
  Future<String?> _authUser(BuildContext context, LoginData data) async {
    // Simula um atraso de rede
    await Future.delayed(const Duration(milliseconds: 800));

    // Lógica de login aqui.

    return null;
  }

  // Função de cadastro do cliente

  Future<String?> _handleSignup(BuildContext context, SignupData data) async {
    // Simula um atraso de rede
    await Future.delayed(const Duration(milliseconds: 800));

    // Lógica de cadastro (e login opcional) aqui.
  
    return null;
  }

 // Recuperação de senha 
  Future<String?> _recoverPassword(BuildContext context, String name) async {

    // Simula um atraso de rede
    await Future.delayed(const Duration(milliseconds: 800));

    // Vamos manter sem nada.
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/tekmek_logo.png'),
      title: 'Seja bem-vindo!',

    
      onLogin: (data) => _authUser(context, data),
      onSignup: (data) => _handleSignup(context, data),
      onRecoverPassword: (name) => _recoverPassword(context, name),

      onSubmitAnimationCompleted: () {
        // Logica apos login ou cadastro feitos (sucesso)
      
      },

      // ------------- Personalização do flutter Login -------------------
      theme: LoginTheme(
        primaryColor: const Color.fromARGB(255, 83, 83, 83),
        pageColorLight: const Color(0xFFF5F5F5),
        pageColorDark: const Color(0xFFF5F5F5),
        titleStyle: const TextStyle(
          color: Color.fromARGB(255, 83, 83, 83),
          fontSize: 28,
          height: 1.2,
        ),
        bodyStyle: const TextStyle(
          color: Color.fromARGB(255, 83, 83, 83),
        ),
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
        recoverPasswordDescription:
            'Enviaremos instruções para o seu e-mail.',
        recoverPasswordSuccess: 'E-mail enviado com sucesso!',
      ),
    );
  }
}