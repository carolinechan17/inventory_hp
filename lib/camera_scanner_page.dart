import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraScannerPage extends StatefulWidget {
  const CameraScannerPage({super.key});
  @override
  State<CameraScannerPage> createState() => _CameraScannerPageState();
}

class _CameraScannerPageState extends State<CameraScannerPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras!.first, ResolutionPreset.medium);
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _scanIMEI() async {
    setState(() {
      isLoading = true;
    });
    final picture = await controller!.takePicture();
    final inputImage = InputImage.fromFilePath(picture.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final recognizedText = await textRecognizer.processImage(inputImage);

    String? foundIMEI;
    final imeiRegex = RegExp(r'\d{15}'); // 15 consecutive digits

    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        if (line.text.toUpperCase().contains("IMEI")) {
          final match = imeiRegex.firstMatch(line.text);
          if (match != null) {
            foundIMEI = match.group(0); // extract only the digits
            break;
          }
        }
      }
      if (foundIMEI != null) break;
    }

    setState(() {
      isLoading = false;
      if (foundIMEI != null) {
        Navigator.pop(context, foundIMEI);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Belum berhasil scan IMEI')));
      }
    });

    await textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Scan IMEI")),
      body: Stack(
        children: [
          CameraPreview(controller!),
          if (isLoading)
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                color: Colors.black54.withAlpha(125),
                height: double.infinity,
                width: double.infinity,
                child: Text(
                  'Sedang dalam proses scan',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanIMEI,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
