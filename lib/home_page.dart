import 'admin_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'app_config.dart';

class HomePage extends StatefulWidget {
  final String accessToken;

  const HomePage({
    super.key,
    required this.accessToken,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {

  Map<String, dynamic>? user;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    getUser();
  }

  Future<void> getUser() async {
    try {
      final dio = Dio();

      final response = await dio.get(
        'https://pos.cicd.web.id/users/me?fields=*,role.*',
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${widget.accessToken}',
          },
        ),
      );

      setState(() {
        user =
            response.data['data'];

        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final name =
        user?['first_name'] ?? '-';

    final email =
        user?['email'] ?? '-';

    final role =
        user?['role']?['name'] ?? '-';

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Home'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              'Selamat datang!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              'Nama: $name',
            ),

            Text(
              'Email: $email',
            ),

            Text(
              'Role: $role',
            ),
            if (role == 'Administrator')
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const AdminPage(),
                ),
              );
            },
            child:
                const Text('Admin Page'),
          ),
          ],
        ),
      ),
    );
  }
}