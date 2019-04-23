import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tianyue/public.dart';

import 'package:tianyue/book_home/home_scene.dart';
import 'package:tianyue/comic_home/comic_home_scene.dart';
import 'package:tianyue/me/me_scene.dart';

class RootScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RootSceneState();
}

class RootSceneState extends State<RootScene> {
  int _tabIndex = 0;
  bool isFinishSetup = false;
  List<Image> _tabImages = [
    Image.asset('img/tab_comic_home_n.png'),
    Image.asset('img/tab_book_home_n.png'),
    Image.asset('img/tab_mine_n.png'),
  ];
  List<Image> _tabSelectedImages = [
    Image.asset('img/tab_home_comic_p.png'),
    Image.asset('img/tab_book_home_p.png'),
    Image.asset('img/tab_mine_p.png'),
  ];

  @override
  void initState() {
    super.initState();

    setupApp();

    eventBus.on(EventUserLogin, (arg) {
      setState(() {});
    });

    eventBus.on(EventUserLogout, (arg) {
      setState(() {});
    });

    eventBus.on(EventToggleTabBarIndex, (arg) {
      setState(() {
        _tabIndex = arg;
      });
    });
  }

  @override
  void dispose() {
    eventBus.off(EventUserLogin);
    eventBus.off(EventUserLogout);
    eventBus.off(EventToggleTabBarIndex);
    super.dispose();
  }

  setupApp() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isFinishSetup = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isFinishSetup) {
      return Container();
    }

    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          ComicHomeScene(),
          HomeScene(),
          MeScene(),
        ],
        index: _tabIndex,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: TYColor.primary,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: getTabIcon(0)),
          BottomNavigationBarItem(icon: getTabIcon(1)),
          BottomNavigationBarItem(icon: getTabIcon(2)),
        ],
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }

  Image getTabIcon(int index) {
    if (index == _tabIndex) {
      return _tabSelectedImages[index];
    } else {
      return _tabImages[index];
    }
  }
}