import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeguard/screens/chat/chat_model.dart';
import 'package:safeguard/screens/chatlist/user_model.dart';

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
  String selectedLanguage = 'English'; // Initialize with default language

  List<ChatModel> chatList = [
    ChatModel(isUser: true, message: "Hi"),
    ChatModel(isUser: false, message: "Hellow"),
    ChatModel(isUser: true, message: "How's it's going")
  ];

  void addText() {
    if (inputController.text != '') {
      setState(() {
        chatList.add(ChatModel(
          isUser: true,
          message: inputController.text,
        ));
      });
      inputController.text = '';
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4E4F7),
        title: Text(user.fullName),
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
                  items: <String>['English', 'Spanish', 'French', 'German']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
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
                  ChatModel message = chatList[index];
                  return Align(
                    alignment: (message.isUser)
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: (message.isUser)
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            color: (message.isUser)
                                ? const Color(0xFF59718F)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: (message.isUser)
                                ? null
                                : Border.all(
                                    width: 2,
                                    color: const Color(0xFF59718F))),
                          child: Text(
                            message.message,
                            style: GoogleFonts.poppins(
                                color: (message.isUser)
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
