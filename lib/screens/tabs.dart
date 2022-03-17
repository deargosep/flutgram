import 'package:flutgram/components/drawer.dart';
import 'package:flutgram/screens/chats.dart';
import 'package:flutgram/screens/feed.dart';
import 'package:flutgram/screens/music.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class TabScreen extends HookWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);

    useEffect(() {
      if (Get.parameters['tabs'] != null) {
        selectedIndex.value = int.parse(Get.parameters['tabs'].toString());
      }
      return () {};
    }, []);
    final List<BottomNavigationBarItem> tabs = [
      BottomNavigationBarItem(
        icon: Icon(Icons.send),
        label: 'Messenger',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.image),
        label: 'Feed',
      ),
      // no music for now :(
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.music_note),
      //   label: 'Music',
      // ),
    ];
    final List<Widget> _widgetOptions = <Widget>[
      ChatsScreen(),
      FeedScreen(),
      // no music for now :(
      // MusicScreen()
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(tabs.elementAt(selectedIndex.value).label!),
      ),
      drawer: ProfileDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex.value,
        onTap: (index) {
          selectedIndex.value = index;
        },
        items: tabs,
      ),
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex.value),
      ),
    );
  }
}
