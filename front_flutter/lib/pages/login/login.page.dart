import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '_compose/dashboard_screen.dart'; // Tela principal
// TODO: Crie e importe a tela de admin
// import '_compose/admin_dashboard_screen.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variáveis para guardar o estado do usuário logado
  bool _isAdmin = false;
  String _accountId = "";

  // URL base da sua API
  final String _apiBaseUrl = 'http://localhost:5315';

  // <<< Função de LOGIN (chama /login) >>>
  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    final url = Uri.parse('$_apiBaseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'username': data.name, // 'username' como esperado pelo backend
          'password': data.password,
        }),
      );

      if (response.statusCode == 200) {
        // Sucesso! Decodifica o JSON
        final responseData = json.decode(response.body);

        // Salva os dados no estado do Widget
        setState(() {
          _isAdmin = responseData['isAdmin'] ?? false;
          _accountId = responseData['idlogin']?.toString() ?? '';
        });

        return null; // Retorna null para indicar sucesso no login
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        // Erro de credenciais
        return 'Login e/ou senha inválidos.';
      } else {
        // Outro erro de servidor
        return 'Erro ao logar.';
      }
    } catch (e) {
      // Erro de conexão (API offline, etc)
      debugPrint(e.toString());
      return 'Erro ao conectar ao servidor.';
    }
  }

  // <<< Função de RECUPERAR SENHA (chama /recover-password) >>>
  Future<String?> _recoverPassword(String name) async {
    debugPrint('Recover Password for: $name');
    final url = Uri.parse('$_apiBaseUrl/recover-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'username': name,
        }),
      );

      if (response.statusCode == 200) {
        // Sucesso (backend iniciou o processo)
        return null; // Retorna null para o flutter_login mostrar sucesso
      } else if (response.statusCode == 404) {
        // Usuário não encontrado
        return 'Usuário não existe.';
      } else {
        // Outro erro
        return 'Erro no servidor.';
      }
    } catch (e) {
      debugPrint(e.toString());
      return 'Erro ao conectar ao servidor.';
    }
  }

  // <<< Função de REGISTRO (chama /register) >>>
  Future<String?> _signupUser(SignupData data) async {
    // O flutter_login não oferece um campo "token" por padrão.
    // Você precisará personalizar a tela de signup se quiser
    // registrar admins por aqui.
    // Por enquanto, esta função registrará apenas usuários normais.
    
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    final url = Uri.parse('$_apiBaseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'username': data.name,
          'password': data.password,
          'token': null, // Registrando como usuário normal
        }),
      );

      if (response.statusCode == 201) {
        // Criado com sucesso
        return null; // Retorna null para logar o usuário automaticamente
      } else if (response.statusCode == 409) {
        return 'Este usuário já existe.';
      } else {
        return 'Erro ao registrar.';
      }
    } catch (e) {
      debugPrint(e.toString());
      return 'Erro ao conectar ao servidor.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/tekmek_logo.png'),
      title: 'Seja bem-vindo!',
      onLogin: _authUser,
      onSignup: _signupUser, // Habilitado
      onRecoverPassword: _recoverPassword, // Habilitado
      
      onSubmitAnimationCompleted: () {
        // <<< Navegação condicional baseada no _isAdmin >>>
        if (_isAdmin) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              // TODO: Substitua pela sua tela de Admin
              // builder: (context) => AdminDashboardScreen(accountId: _accountId),
              builder: (context) => const DashboardScreen(), // Placeholder
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
              // Ex: builder: (context) => DashboardScreen(accountId: _accountId),
            ),
          );
        }
      },

      // ========= PERSONALIZAÇÃO (sem mudanças) =========
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