import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'utils/routes_handler.dart';
import 'package:provider/provider.dart';
import 'package:front_flutter/utils/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
  final authProvider = AuthProvider();
  final router = AppRouter.createRouter(authProvider); 
  runApp(App(authProvider: authProvider, router: router));
}

class App extends StatelessWidget {
 
  const App({super.key, required this.authProvider, required this.router});


  final AuthProvider authProvider;
  final GoRouter router;


  @override
  Widget build(BuildContext context) {
  
    return ChangeNotifierProvider.value(
      value: authProvider,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "Tekmek",
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),

        routerConfig: router,
      ),
    );
  }
}
