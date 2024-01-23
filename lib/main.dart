// import 'package:flutter/material.dart';
// import 'package:printing/printing.dart';
// import 'package:pdf/widgets.dart' as pw;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Printer App')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               final pdf = pw.Document();
//               pdf.addPage(
//                 pw.Page(
//                   build: (pw.Context context) => pw.Center(
//                     child: pw.Text(
//                         'Hello World!'), // Replace with your receipt layout
//                   ),
//                 ),
//               );
//               await Printing.layoutPdf(onLayout: (format) => pdf.save());
//             },
//             child: Text('Print Receipt'),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as widgets;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Uploader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // Creating the pdf/reciept
  Future<File> createPdf() async {
    final pdf = widgets.Document();
    pdf.addPage(
      widgets.Page(
          build: (widgets.Context context) => widgets.Center(
                child: widgets.Column(
                  children: [
                    widgets.Text('Thank you for buying from Diligent Global!'),
                    widgets.Text('Tomatoes 2.33 /-')
                  ],
                ),
              )),
    );
    const output =
        '/home/vijay/projects/flutter_print/printing/printing_without_dialogue_box';
    final file = File("$output/example.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Function to send the generated file to the server
  Future<void> sendPdfToServer(File file) async {
    var uri = Uri.parse('http://127.0.0.1:5000/upload');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('pdf', file.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('PDF sent to server successfully');
    } else {
      print('Failed to send PDF to server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Uploader'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            File pdfFile = await createPdf();
            await sendPdfToServer(pdfFile);
          },
          child: const Text('Print!'),
        ),
      ),
    );
  }
}
