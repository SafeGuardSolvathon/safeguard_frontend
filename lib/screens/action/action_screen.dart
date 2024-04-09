import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen({super.key});

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    //FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }
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
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFF59718F),
                            borderRadius: BorderRadius.circular(10)),
                        child: MaterialButton(
                          onPressed: _pickImage,
                          child: Center(
                            child: Text(
                              "Upload Image",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )),
                    SizedBox(height: 20),
                    if (_selectedImage != null)
                      Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_selectedImage!.path),
                              height: 200,
                              fit: BoxFit.contain,
                            )),
                      )
                    else
                      Container(
                        height: 200,
                        child: Center(
                          child: IconButton(
                              onPressed: () {
                                _pickImage();
                              },
                              icon: Icon(
                                Icons.add_circle_outline_outlined,
                                color: Colors.grey,
                                size: 50,
                              )),
                        ),
                      ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Detected RegNo : 22BCE1621",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 150,
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF59718F),
                    ),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Center(
                          child: Text(
                        "Send",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 18),
                      )),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
