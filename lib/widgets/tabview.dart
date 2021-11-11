import 'package:flutter/material.dart';
import 'package:uchet/screens/HomeScreen.dart';
import 'package:uchet/screens/LiverAddScreen.dart';
import 'package:uchet/screens/ConvertScreen.dart';

class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ConvertScreen(),
    LiverAddScreen(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.add_chart),
                title: Text('Проверка'),
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
              icon: Icon(Icons.rotate_90_degrees_ccw_rounded),
              title: Text('Конверт'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              title: Text('Добавить жителя'),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
          selectedFontSize: 13.0,
          unselectedFontSize: 13.0,
          unselectedItemColor: Color(0xff7481a3),
          selectedItemColor: Color(0xff3d4b73),
        ));
  }
}
