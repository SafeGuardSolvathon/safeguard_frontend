import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PDAScreen extends StatefulWidget {
  const PDAScreen({super.key});

  @override
  State<PDAScreen> createState() => _PDAScreenState();
}

class _PDAScreenState extends State<PDAScreen> {
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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        currentIndex: 2,
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
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: NetworkImage(
                    "https://www.yourtango.com/sites/default/files/image_blog/30-best-marriage-proposal-stories-all-time.png"),
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 25,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "AB1 6th floor",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.videocam_rounded,
                  size: 25,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "C101",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time_filled,
                  size: 25,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "07:00 PM",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF59718F),
                ),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/action");
                  },
                  child: Center(
                      child: Text(
                    "Take Action",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18),
                  )),
                )),
          ],
        ),
      )),
    );
  }
}
