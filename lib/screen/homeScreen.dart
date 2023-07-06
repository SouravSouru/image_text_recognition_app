import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_text_recognition_app/utilities/appConstant.dart';
import 'package:image_text_recognition_app/contoller/homePageContoller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? gg;
  chooseImage(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              Provider.of<HomePageController>(context, listen: false)
                  .pickImage(ImageSource.gallery);
              Navigator.pop(context);

              //await pickImage(ImageSource.gallery);
            },
            child: Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppConstant.textColor, width: 2)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: AppConstant.textColor,
                          ),
                          Text(
                            "Gallery",
                            style: TextStyle(color: AppConstant.textColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Provider.of<HomePageController>(context, listen: false)
                          .pickImage(ImageSource.gallery);
                      Navigator.pop(context);

                      // await pickImage(ImageSource.camera);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppConstant.textColor, width: 2)),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: AppConstant.textColor,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(color: AppConstant.textColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        tooltip: "Copy",
        child: Icon(Icons.copy, color: AppConstant.textColor),
        onPressed: () async {
          var generatedText =
              Provider.of<HomePageController>(context, listen: false)
                  .generatedText;
          if (generatedText != null) {
            await Clipboard.setData(ClipboardData(text: generatedText));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Copied")));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("No Text Found")));
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Consumer<HomePageController>(builder: (context, value, _) {
                  if (value.pickedImage == null) {
                    return GestureDetector(
                      onTap: () async {
                        await chooseImage(context);
                      },
                      child: Container(
                        height: 200,
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: AppConstant.textColor,
                            size: 40,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 200,
                      width: _mediaQuery.width,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<HomePageController>(context,
                                      listen: false)
                                  .removePickedImage(null);
                            },
                            child: Icon(
                              Icons.close,
                              size: 40,
                            ),
                          )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          image: DecorationImage(
                              image: FileImage(value.pickedImage!),
                              fit: BoxFit.fill)),
                    );
                  }
                }),
              ),
              Consumer<HomePageController>(builder: (context, value, _) {
                if (value.generatedText == null) {
                  return Center(
                    child: Text("No Text Found !"),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: _mediaQuery.height - 200,
                      child: ListView(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontFamily: 'Agne',
                                    color: AppConstant.textColor),
                                child: AnimatedTextKit(
                                  totalRepeatCount: 1,
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                        value.generatedText!),
                                  ],
                                  onTap: () {
                                    print("Tap Event");
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
