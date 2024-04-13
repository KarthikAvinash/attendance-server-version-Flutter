// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   String url = 'http://192.168.236.171:5000';
//   var data;
//   List<String> pred = []; // Changed to a list
//   File? _image;

//   Future<void> fetchData() async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       final decoded = jsonDecode(response.body);
//       setState(() {
//         pred = [decoded['pred'].toString()]; // Convert to a list
//       });
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   Future<void> uploadImage(File imageFile) async {
//     setState(() {
//       pred.clear(); // Clear predictions when uploading image
//     });
    
//     var request = http.MultipartRequest('POST', Uri.parse('$url/predict'));
//     request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       var responseBody = await response.stream.bytesToString();
//       var decodedResponse = jsonDecode(responseBody);
//       setState(() {
//         // Update UI with prediction result
//         // Assuming the response contains 'predicted_labels'
//         pred = List<String>.from(decodedResponse['predicted_labels']); // Convert to a list
//       });
//     } else {
//       print('Failed to upload image. Status code: ${response.statusCode}');
//     }
//   }

//   Future<void> getImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });

//     if (_image != null) {
//       await uploadImage(_image!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Attendify')),
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () => getImage(ImageSource.gallery),
//                 child: Text(
//                   'Upload Image',
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => getImage(ImageSource.camera),
//                 child: Text(
//                   'Take Picture',
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//               SizedBox(height: 20),
//               _image != null ? Container(
//                 height: 200, // Specify the height as needed
//                 child: Image.file(_image!, fit: BoxFit.cover),
//               ) : Container(),
//               SizedBox(height: 20),
//               if (pred.isNotEmpty) Text("Predictions: "), // Show "Predictions" only if pred is not empty
//               Column( // Use a column to display each prediction separately
//                 children: pred.isEmpty
//                     ? [Text("None detected", style: TextStyle(fontSize: 20, color: Colors.red))]
//                     : pred.map((prediction) {
//                         return Text(
//                           prediction,
//                           style: TextStyle(fontSize: 20, color: Colors.green),
//                         );
//                       }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: Home(),
//   ));
// }


//____________________________________________________________________________________________________

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String baseUrl = 'https://attendifydwd.pythonanywhere.com/'; // Default base URL
  TextEditingController ipController = TextEditingController(); // Controller for IP address TextField
  var data;
  List<String> pred = []; // Changed to a list
  File? _image;

  @override
  void initState() {
    super.initState();
    ipController.text = '192.168.236.171'; // Set default IP address
  }

  Future<void> fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final decoded = jsonDecode(response.body);
      setState(() {
        pred = [decoded['pred'].toString()]; // Convert to a list
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> uploadImage(File imageFile) async {
    setState(() {
      pred.clear(); // Clear predictions when uploading image
    });
    
    var request = http.MultipartRequest('POST', Uri.parse('https://attendifydwd.pythonanywhere.com/predict'));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);
      setState(() {
        // Update UI with prediction result
        // Assuming the response contains 'predicted_labels'
        pred = List<String>.from(decodedResponse['predicted_labels']); // Convert to a list
      });
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    if (_image != null) {
      await uploadImage(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendify')),
      body: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TextField(
                //   controller: ipController,
                //   decoration: InputDecoration(
                //     labelText: 'Enter IP Address',
                //   ),
                //   onChanged: (value) {
                //     baseUrl = 'http://attendifydwd.pythonanywhere.com/'; // Concatenate the port number
                //   },
                // ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => getImage(ImageSource.gallery),
                  child: Text(
                    'Upload Image',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => getImage(ImageSource.camera),
                  child: Text(
                    'Take Picture',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                _image != null ? Container(
                  height: 200, // Specify the height as needed
                  child: Image.file(_image!, fit: BoxFit.cover),
                ) : Container(),
                SizedBox(height: 20),
                if (pred.isNotEmpty) Text("Predictions: "), // Show "Predictions" only if pred is not empty
                Column( // Use a column to display each prediction separately
                  children: pred.isEmpty
                      ? [Text("None detected", style: TextStyle(fontSize: 20, color: Colors.red))]
                      : pred.map((prediction) {
                          return Text(
                            prediction,
                            style: TextStyle(fontSize: 20, color: Colors.green),
                          );
                        }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
