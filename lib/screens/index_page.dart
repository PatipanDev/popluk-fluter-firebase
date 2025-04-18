import 'package:flutter/material.dart';
import 'package:popluk/screens/home_page.dart';
import 'package:popluk/screens/messages_page.dart';
import 'package:popluk/screens/notifications_page.dart';
import 'package:popluk/screens/proflie_page.dart';
import 'package:popluk/theme/colors.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  //value page
  int currentPageIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    NotificationsPage(),
    MessagesPage(),
    // ProfliePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //bottomnavigationbar main app
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_carousel_outlined),
            activeIcon: Icon(Icons.view_carousel),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Badge(child: Icon(Icons.notifications_none), backgroundColor: Colors.green),
            activeIcon: Badge(child: Icon(Icons.notifications), backgroundColor: Colors.green),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Badge(label: Text('2'), child: Icon(Icons.message_outlined), backgroundColor: Colors.green,),
            activeIcon: Badge(label: Text('2'), child: Icon(Icons.message), backgroundColor: Colors.green),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: '',
          ),
        ],
      ),
      body: _pages[currentPageIndex],
      
    );
  }
}
