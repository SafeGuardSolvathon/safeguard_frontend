import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeguard/screens/chat/chat_model.dart';
import 'package:safeguard/screens/chatlist/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  TextEditingController inputController = TextEditingController();
  UserModel user = UserModel(fullName: "Aswin Raaj", uid: 1);
  String selectedLanguage = 'English';
  String empId = ""; // Initialize with default language

  List<Chat> chatList = [];

  @override
  void initState() {
    // TODO: implement initState
    getEmpId();
    super.initState();
  }

  Future<void> getEmpId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var e = await prefs.getString("empId");
    setState(() {
      empId = e!;
    });
    await getAllChats();
  }

  void addText() {
    if (inputController.text != '') {
      addChat(inputController.text);
      setState(() {
        chatList.add(Chat(
            empId: empId,
            description: inputController.text,
            time: DateTime.now().toString()));
      });
      inputController.text = '';
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> getAllChats() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/complain/'));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final List<dynamic> jsonData = json.decode(response.body);
      // Map the JSON data to a list of Chat objects
      var li = jsonData.map((json) => Chat.fromJson(json)).toList();
      setState(() {
        chatList = li;
      });
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load chats');
    }
  }

  Future<void> addChat(String msg) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/complain/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'empid': empId,
        'description': msg,
        'time': DateTime.now().toString(),
      }),
    );
    if (response.statusCode == 201) {
      // If the server returns a 201 Created response, the chat was added successfully
      print('Chat added successfully');
    } else {
      // If the server did not return a 201 Created response, throw an exception
      throw Exception('Failed to add chat');
    }
  }

  Future<String> callGemini(String text, String language) async {
    final apiKey = "AIzaSyBc9DJ0jSt6ojoAciC9OnEp1DQ_apOvGUc";
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [Content.text('Translate $text into $language')];
    final response = await model.generateContent(content);
    print(response.text!);
    return response.text!;
  }

  Future<void> translate(String language) async {
    print("Hi");
    List<Chat> tempList =  [...chatList];
    tempList.forEach((element) async {
      element.description = await callGemini(element.description, language);
    });
    setState(() {
      chatList = tempList;
    });
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
            ListTile(
              title: Text('Action'),
              onTap: () {
                Navigator.pushNamed(context, "/action");
              },
            ),
            ListTile(
              title: Text('Notes'),
              onTap: () {
                Navigator.pushNamed(context, "/notes");
              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/splash", (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Select Language"),
                DropdownButton<String>(
                  value: selectedLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                    });
                  },
                  items: <String>[
                    'English',
                    'Hindi',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      onTap: () => translate(value),
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                itemCount: chatList.length,
                itemBuilder: (BuildContext context, int index) {
                  Chat message = chatList[index];
                  return Align(
                    alignment: (message.empId == empId)
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: (message.empId == empId)
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                              color: (message.empId == empId)
                                  ? const Color(0xFF59718F)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: (message.empId == empId)
                                  ? null
                                  : Border.all(
                                      width: 2,
                                      color: const Color(0xFF59718F))),
                          child: Text(
                            message.description,
                            style: GoogleFonts.poppins(
                                color: (message.empId == empId)
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -4),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputController,
                      decoration: InputDecoration(
                        hintText: "Type here...",
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0xFF8D8D8D),
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      onSubmitted: (_) {
                        //addText();
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Send button pressed...
                      addText();

                      FocusScope.of(context).unfocus();
                    },
                    icon: Icon(
                      Icons.send,
                      color: const Color(0xFF59718F),
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
