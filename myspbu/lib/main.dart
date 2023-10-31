import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myspbu/provider/user_points_provider.dart';
import 'package:myspbu/provider/login_provider.dart';
import 'package:myspbu/provider/news_api_provider.dart';
import 'package:provider/provider.dart';
import 'widget/bottom_navigation.dart';
import 'ui/pages/image_list_page.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/qrcodepage.dart';
import 'ui/pages/profile_page.dart';
import 'ui/pages/transaction_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserPointsProvider()),
      ChangeNotifierProvider(create: (context) => NewsApiProvider()),
      ChangeNotifierProvider(
          create: (_) => LoginProvider()), // Tambahkan LoginProvider
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  bool isLoggedIn = false;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? MyHomePage()
          : LoginPage(
              onTabTapped: (int) {},
            ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  final List<Widget> screens = [
    HomePage(currentIndex: 0),
    ImageListPage(),
    QRCodePage(
      currentIndex: 2,
      userId: 'user1',
    ),
    TransactionHistoryPage(),
    ProfilePageScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: currentIndex,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
