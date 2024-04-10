import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

class ActionScreen extends StatefulWidget {
  const ActionScreen({Key? key}) : super(key: key);

  @override
  State<ActionScreen> createState() => _ActionScreenState();
}

class _ActionScreenState extends State<ActionScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? _selectedImage;
  String regNo = "Upload Image";

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
        regNo = "Image Uploading";
      });
      await _uploadImageToCloudinary(File(image.path));
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

  Future<void> fetchOCRResponse(String imageUrl) async {
    final apiKey = 'K88481131888957';
    final url =
        'https://api.ocr.space/parse/imageurl?apikey=$apiKey&url=$imageUrl';

    final response = await http.get(Uri.parse(url));
    print(response.body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final parsedText = jsonResponse['ParsedResults'][0]['ParsedText'];

      final regNoRegExp = RegExp(r'\b\d{2}[A-Z]{3}\d{4}\b');
      final match = regNoRegExp.firstMatch(parsedText);
      if (match != null) {
        final detectedRegNo = match.group(0);
        print('Registration Number: $detectedRegNo');
        setState(() {
          regNo = detectedRegNo!;
        });
      } else {
        setState(() {
          regNo = "Reg No not found";
        });
        print('Reg No not found');
      }
    } else {
      setState(() {
        regNo = "Error: Failed to fetch OCR response";
      });
    }
  }

  Future<void> _uploadImageToCloudinary(File imageFile) async {
    final cloudinaryUrl =
        'https://api.cloudinary.com/v1_1/ddkpclbs2/image/upload';
    final uploadPreset = 'bisineimages';

    final uri = Uri.parse(cloudinaryUrl);

    // Resize image
    final image = img.decodeImage(await imageFile.readAsBytes());
    final resizedImage = img.copyResize(image!, width: 800);

    // Create a temporary file to store the resized image
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/resized_image.jpg')
      ..writeAsBytesSync(img.encodeJpg(resizedImage));

    // Create multipart request for uploading
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', tempFile.path));

    // Send request
    final response = await request.send();

    // Get response body as a Map
    final responseBody = await response.stream.bytesToString();
    final decodedResponse = json.decode(responseBody);

    // Extract the URL from the response
    final imageUrl = decodedResponse['secure_url'];
    print(imageUrl);
    fetchOCRResponse(imageUrl);
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        onPressed: _pickImage,
                        child: Center(
                          child: Text(
                            "Upload Image",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_selectedImage != null)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_selectedImage!.path),
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
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
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 25),
                    Text(
                      "Detected RegNo: $regNo",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 150),
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
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
