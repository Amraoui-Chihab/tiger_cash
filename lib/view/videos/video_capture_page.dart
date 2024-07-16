import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tigercashiraq/Api%20Server/apidata.dart';
import 'package:video_player/video_player.dart';

class VideoCapturePage extends StatefulWidget {
  const VideoCapturePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoCapturePageState createState() => _VideoCapturePageState();
}

class _VideoCapturePageState extends State<VideoCapturePage> {
  File? _videoFile;
  VideoPlayerController? _videoController;
  final picker = ImagePicker();
  bool _isUploading = false;
  var trxtcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pickVideo();
  }

  Future<void> _pickVideo() async {
    final pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
      // maxDuration: const Duration(seconds: 30),
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final length = await file.length();
      if (length > 50 * 1024 * 1024) {
        Get.snackbar(
          "  ",
          ' حجم الفيديو أكبر من 50 ميغابايت',
          backgroundColor: Colors.green,
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('حجم الفيديو أكبر من 50 ميغابايت')),
        // );
        return;
      }

      setState(() {
        _videoFile = file;
        _videoController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.play();
          });
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) return;

    setState(() {
      _isUploading = true;
    });
    GetStorage box = GetStorage();
    String tokrn = box.read("token");

    try {
      var postUri = Uri.parse('${ApiData.baseUrl}/api/reel/create');
      http.MultipartRequest request = http.MultipartRequest("POST", postUri);
      request.headers.addAll(
          {"Accept": "application/json", "Authorization": "Bearer $tokrn"});
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('video', _videoFile!.path);
      request.fields.addAll({
        "title": trxtcontroller.text.toString(),
      });

      request.files.add(multipartFile);
      var x = await request.send();
      switch (x.statusCode) {
        case 200:
        case 201:
          Get.back();
          Get.snackbar(
            "تمت الاضافة بنجاح",
            "تمت الاضافة بنجاح",
            backgroundColor: Colors.green,
          );
          break;
        default:
          Get.snackbar(
            "حدث خطأ",
            jsonDecode(await x.stream.bytesToString())["message"],
            backgroundColor: Colors.red,
          );
      }
    } catch (e) {
      Get.snackbar(
        "حدث خطأ",
        e.toString(),
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('اختيار الفيديو ومعاينته'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _videoController != null && _videoController!.value.isInitialized
              ? Expanded(
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    // height: double.maxFinite,
                    color: Colors.grey,
                    child: const Center(
                      child: Text('لا يوجد فيديو'),
                    ),
                  ),
                ),
          _isUploading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 15, right: 15, top: 5),
                          child: TextFormField(
                            controller: trxtcontroller,
                            decoration: const InputDecoration(
                              hintText: 'اسم الفديو',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'يجب ادخال اسم الفديو';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _videoController!.pause();
                            _uploadVideo();
                          }
                        },
                        icon: const Icon(Icons.send))
                  ],
                ),
        ],
      ),
    );
  }
}
