import 'package:flutter/material.dart';
import 'package:safeguard/screens/chatlist/user_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<UserModel> users = [
    UserModel(fullName: "Aswin Raaj P S", uid: 1),
    UserModel(fullName: "Marushka", uid: 2)
  ];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  void navigate(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/");
        break;
      case 1:
        Navigator.pushNamed(context, "/emergency");
        break;
      case 2:
        Navigator.pushNamed(context, "/pda");
        break;
      case 3:
         Navigator.pushNamed(context, "/chatlist");
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFD4E4F7),
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color(0xFFD4E4F7),
          title: Text('SafeGuard'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Menu'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Bus Status'),
                onTap: () {
                  Navigator.pushNamed(context, "/busstatus");
                },
              ),
              
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFD4E4F7),
          currentIndex: 3,
          type: BottomNavigationBarType.fixed,
          onTap: (value) => navigate(value),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emergency),
              label: 'Emergency',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_police),
              label: 'PDA',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      hintText: "Search",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      fillColor: Colors.white,
                      filled: true),
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: ListTile(
                          onTap: () => Navigator.pushNamed(context, "/chat"),
                          tileColor: const Color(0xFF56779F),
                          leading: Icon(Icons.account_circle_rounded),
                          title: Text(users[index].fullName),
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
