import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    try {
      final dio = Dio();

      final response = await dio.post(
        'https://pos.cicd.web.id/auth/login',
        data: {
          'email':
              emailController.text,
          'password':
              passwordController.text,
        },
      );

      final data =
          response.data['data'];

      final accessToken =
          data['access_token'];

      print(
        'ACCESS TOKEN: $accessToken',
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            accessToken:
                accessToken,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Login gagal'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Login'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          children: [

            TextField(
              controller:
                  emailController,
              decoration:
                  const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : login,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'LOGIN',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}