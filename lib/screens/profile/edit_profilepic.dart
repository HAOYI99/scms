import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scms/models/user.dart';
import 'package:scms/services/user_database.dart';
import 'package:scms/shared/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class changeProfilePicture extends StatefulWidget {
  const changeProfilePicture({Key? key}) : super(key: key);

  @override
  State<changeProfilePicture> createState() => _changeProfilePictureState();
}

class _changeProfilePictureState extends State<changeProfilePicture> {
  File? _imageFile;
  final ImagePicker imagePicker = ImagePicker();
  bool isLoading = false;
  final isSelected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<thisUser?>(context);
    return isLoading
        ? loadingIndicator()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context, 'Change Profile Picture'),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //for rounded rectangle clip
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blue)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: _imageFile == null
                                            ? const Center(
                                                child:
                                                    Text('Select Your Image'))
                                            : Image.file(_imageFile!,
                                                fit: BoxFit.contain)),
                                    ToggleButtons(isSelected: isSelected, children: [
                                      ElevatedButton(
                                          style: buildButtonStyle(context),
                                          onPressed: () => imagePickerFunction(
                                              ImageSource.gallery),
                                          child: buildButtonIcon(
                                              Icons.image, 'Image')),
                                      ElevatedButton(
                                          style: buildButtonStyle(context),
                                          onPressed: () => imagePickerFunction(
                                              ImageSource.camera),
                                          child: buildButtonIcon(
                                              Icons.camera_outlined, 'Camera')),
                                      ElevatedButton(
                                          style: buildButtonStyle(context),
                                          onPressed: () => _imageFile == null ? showFailedSnackBar('No File Selected', context) : cropImage() ,
                                          child: buildButtonIcon(
                                              Icons.crop_outlined, 'Crop')),
                                    ]),
                                    ElevatedButton(
                                        onPressed: () async {
                                          //upload only when the image has some values
                                          if (_imageFile != null) {
                                            setState(() => isLoading = true);
                                            await UserDatabaseService(
                                                    uid: user!.uid)
                                                .uploadImage(
                                                    _imageFile, context)
                                                .whenComplete(() {
                                              showSuccessSnackBar(
                                                  'Upload Successfully !',
                                                  context);
                                              Navigator.of(context).pop();
                                            }).catchError((e) =>
                                                    showFailedSnackBar(
                                                        e.toString(), context));
                                          } else {
                                            showFailedSnackBar(
                                                "Select Image First", context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              45),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                        ),
                                        child: const Text('Upload Image')),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  ButtonStyle buildButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      minimumSize: Size(MediaQuery.of(context).size.width * 0.27, 50),
    );
  }

  Column buildButtonIcon(IconData iconData, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(iconData), Text(text)],
    );
  }

  Future imagePickerFunction(ImageSource imageSource) async {
    final XFile? pickedImage = await imagePicker.pickImage(source: imageSource);
    setState(() {
      if (pickedImage != null) {
        setState(() {
          _imageFile = File(pickedImage.path);
        });
      } else {
        _imageFile == null
            ? showFailedSnackBar('No File Selected', context)
            : null;
      }
    });
  }

  Future cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _imageFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.blue,
            backgroundColor: Colors.blue,
            activeControlsWidgetColor: Colors.blue,
            cropFrameColor: Colors.blue,
            cropGridColor: Colors.blue[100],
            cropFrameStrokeWidth: 5,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _imageFile = File(croppedFile.path);
      });
    }
  }
}
