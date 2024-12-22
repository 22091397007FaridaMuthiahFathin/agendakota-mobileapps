import 'dart:convert';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'features/articles/article_list_screen.dart';
import 'qr_view_example.dart';
import 'home_page.dart';
import 'auth/login_screen.dart';
import 'auth/auth_service.dart';
import 'features/admin/admin_dashboard.dart';
import 'features/penulis/penulis_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Kota',
      initialRoute: '/',
      routes: {
        '/': (context) => ArticleListScreen(),
        /*
        '/adminDashboard': (context) => AdminDashboard(),
        '/penulisDashboard': (context) => AuthorDashboard(),
         */
      },
    );
  }
}


class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomePage(username: 'user'),
    ArticleListScreen(),
    QRViewExample(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xffca0c64),
        unselectedItemColor: Colors.grey,
        /*backgroundColor: Colors.white,*/
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
        ],
      ),
    );
  }
}
