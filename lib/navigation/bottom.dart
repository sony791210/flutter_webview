import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final selectedIndex;
  BottomMenu({this.selectedIndex});

  //BottomNavigationBar 按下處理事件，更新設定當下索引值
  void _onItemClick(int index) {
    print(index);
    // Navigator.pushNamed(context, '/Home');
  }

  List screens =["/","/Home","/Self"];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.new_releases),
          label: 'Self',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_answer),
          label: 'Curiosities',
        )
      ],
      currentIndex: selectedIndex,
      onTap:(int index){
        Navigator.pushReplacementNamed(context,  screens.elementAt(index) );
      },
      selectedItemColor: Colors.red[800],
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
    );
  }
}