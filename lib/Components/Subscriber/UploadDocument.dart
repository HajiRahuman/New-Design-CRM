
import 'dart:io';

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:signature/signature.dart';
import '../../model/subscriber.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class DocUpload extends StatefulWidget {
  SubscriberFullDet? subscriberDet;
  final int subscriberId;
  final bool? isProfile;
  final bool? isDocum1;
  final bool? isDocum2;
  final bool? isSign;
  DocUpload({Key? key, required this.subscriberId, required this.isProfile,required this.isDocum1,required this.isDocum2,required this.isSign}) : super(key: key);

  @override
  State<DocUpload> createState() => _MainScreenState();
}

class _MainScreenState extends State<DocUpload> {
  TextEditingController docIdController = TextEditingController();
  final form = FormGroup({
    'docid': FormControl<String>(validators: [Validators.required]),
    'doctype': FormControl<int>(validators: [Validators.required]),
    'typeid': FormControl<int>(validators: [Validators.required],),
  });


  @override
  void initState() {
    super.initState();


    if (widget.isDocum1!) {
      docTypeOpt = {
        'Aadhaar': 1,
      };
      form.control('doctype').value = 1;
      form.control('typeid').value = 1;
    } else {
      docTypeOpt = {
        'Passport': 2,
        'Driving License': 3,
        'Election Commission ID Card': 4,
        'Ration Card': 5,
        'Passbook of Post Office': 6,
        'Electricity Bill': 7,
        'Telephone Bill': 8,
        'Water Bill': 9,
        'GST RC': 10,
        'Gas Card': 11,
        'Passbook of Bank': 12,
        'Photo': 13,
      };
      if (result != null && result!.files.length == 2) {
        form.control('typeid').value = 2;
      }
    }

    if (widget.isSign!) {
      print('IsProfile-----${widget.isSign}');
      form.control('doctype').value = 14;
      form.control('typeid').value = 6;
    }
    if (widget.isProfile!) {
      print('IsProfile-----${widget.isProfile}');
      form.control('doctype').value = 13;
      form.control('typeid').value = 3;
    }

    if (widget.isDocum2!) {
      print('IsDocum1-----${widget.isDocum1}');
      form.control('typeid').value = 4;
    } else {
      if (result != null && result!.files.length == 2) {
        form.control('typeid').value = 5; 
      }
    }
  }

  Map<String, int> docTypeOpt = {

  };

  FilePickerResult? result;
  int selectedFileIndex = -1;
  List<int> selectedFileIndices = [];
  List<PlatformFile>? images;

  bool showSpinner = false;

  Future<void> UploadDocuments(int subscriberId, List<PlatformFile> platformFiles, Uint8List? signatureImage) async {
    try {
      setState(() {
        showSpinner = true;
      });
      print('Upload------> $platformFiles');

      if (platformFiles.isNotEmpty || signatureImage != null) {
        List<MultipartFile> multiPartFiles = [];

        for (PlatformFile platformFile in platformFiles) {
          File file = File(platformFile.path ?? '');
          String fileName = platformFile.name ?? 'file';
          String fileExtension = fileName
              .split('.')
              .last
              .toLowerCase();
          String contentType;
          if (fileExtension == 'pdf') {
            contentType = 'application/pdf';
          } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
            contentType = 'image/jpeg';
          } else if (fileExtension == 'png') {
            contentType = 'image/png';
          } else {
            // Default to application/octet-stream for unknown types
            contentType = 'application/octet-stream';
          }
          multiPartFiles.add(
            MultipartFile.fromFileSync(
              file.path,
              filename: fileName,
              contentType: MediaType.parse(contentType),
            ),
          );
        }

        // Add signature image if available
        if (signatureImage != null) {
          multiPartFiles.add(
            MultipartFile.fromBytes(
              signatureImage,
              filename: 'signature.png', // Provide a filename for the signature image
              contentType: MediaType.parse('image/png'),
            ),
          );
        }

        FormData formData = FormData.fromMap({
          'docid': form.value['docid'],
          'doctype': form.value['doctype'],
          'typeid': form.value['typeid'],
          'file': multiPartFiles,
        });

        final resp = await subscriberSrv.uploadDocument(
            subscriberId, false, false, formData);

        if (resp['error'] == false) {
          alert(context, resp['msg'], resp['error']);
          Navigator.pop(context, true);
        }
      }
    } catch (error) {
      print('Error uploading documents: $error');
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

//Signature

  SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor:Colors.white,
  );


  bool isExpanded = false;
  Uint8List? exportedImage;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
      final notifier = Provider.of<ColorNotifire>(context);
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      color:notifier.getbgcolor,
      child: Scaffold(
        backgroundColor: notifier.getbgcolor,
        body: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           Text((widget.isProfile != true && widget.isSign != true)
                                ? 'Upload Document'
                                : (widget.isProfile != true && widget.isSign == true)
                                ? 'Upload Signature'
                                : 'Upload Profile Pic',
                              style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                        ),
                            ),
                           CircleAvatar(
                                                                        radius: 20,
                                                                        child: IconButton(
                                                                          onPressed: () {
                                                                            Navigator.of(
                                                                                context)
                                                                                .pop();
                                                                          },
                                                                          icon: const Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                          ],
                        ),
                      ),
                   
                  const SizedBox(height: 25),
                  if(widget.isProfile != true && widget.isSign != true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ReactiveDropdownField<int>(
                        formControlName: 'doctype',
                       
                        isExpanded: true,
                        items: docTypeOpt.keys.map<DropdownMenuItem<int>>(
                              (String key) {
                            final value = docTypeOpt[key];
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(key),
                              ),
                            );
                          },
                        ).toList(),
                       dropdownColor: notifier.getcontiner,
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                            suffixIconColor: notifier.getMainText,
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Select Document Type',
                                                                            enabledBorder: OutlineInputBorder(
                                  borderRadius:BorderRadius .circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                                                      border: OutlineInputBorder(
                                  borderRadius:BorderRadius .circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                                                                            ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if(widget.isProfile != true && widget.isSign != true)
                    // if(widget.isSign != true)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ReactiveTextField<String>(
                        formControlName: 'docid',
                        controller: docIdController,
                     
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                            suffixIconColor: notifier.getMainText,
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Document ID',
                                                                            enabledBorder: OutlineInputBorder(
                                  borderRadius:BorderRadius .circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                                                      border: OutlineInputBorder(
                                  borderRadius:BorderRadius .circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                                                                            ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if(widget.isSign!)
                  ClipRect(
                    child: Signature(
                      controller: controller,
                      width: screenWidth,
                      height: 300,
                      backgroundColor:
                      Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if(widget.isSign!)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              exportedImage = await controller.toPngBytes();
                              UploadDocuments(widget.subscriberId, [], exportedImage);
                            },
                            style:  ElevatedButton.styleFrom(
                              backgroundColor: appMainColor,
                            ),
                            child: const Text("Submit",
                              style: TextStyle(
                                  fontSize: 20,
                                 fontWeight:  FontWeight.bold,color: Colors.white),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child:
                          ElevatedButton(
                            onPressed: () {
                              controller.clear();
                            },
                            style:  ElevatedButton.styleFrom(
                             backgroundColor: appMainColor,
                            ),
                            child: const Text("Clear", style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (result != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth,
                          height: 50,
                          decoration: BoxDecoration(
                            color: notifier.getbgcolor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'SELECTED FILES',
                              textAlign: TextAlign.center,
                               style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                        ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: result?.files.length ?? 0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFileIndex = index;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    title: Text(
                                      result?.files[index].name ?? '',
                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          result?.files.removeAt(index);
                                          selectedFileIndex = -1;
                                        });
                                      },
                                      icon: Icon(Icons.clear, color:notifier.getMainText),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style:  ElevatedButton.styleFrom(
                               backgroundColor: appMainColor,
                              ),
                              onPressed: () async {
                                if (form.valid) {} else {
                                  form.markAllAsTouched();
                                }
                                UploadDocuments(widget.subscriberId, result?.files ?? [],null);
                              },
                              child: const Text('Submit',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style:  ElevatedButton.styleFrom(
                     backgroundColor: appMainColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                if(widget.isSign!=true)
               // Inside the FloatingActionButton onPressed for selecting files
FloatingActionButton(
  backgroundColor: appMainColor,
  onPressed: () async {
    if (await _checkPermission(forCamera: false)) {
      var pickedFiles = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (pickedFiles == null) {
        print("No file selected");
      } else {
        if (widget.isProfile != true ? pickedFiles.files.length <= 2 : pickedFiles.files.length <= 1) {
          setState(() {
            result = pickedFiles;
            selectedFileIndex = -1;
          });
          pickedFiles.files.forEach((element) {
            print(element.name);
          });
        } else {
          // Show error toast
          print('Maximum ${widget.isProfile != true ? '2 files' : '1 file'} can be selected.');
        }
      }
    }
  },
  child: const Icon(Icons.attach_file, color: Colors.white),
),

                const SizedBox(width: 10),
                if(widget.isProfile!)
                  FloatingActionButton(
                    backgroundColor:appMainColor,
                    onPressed: () async {
                      // Capture photo from the camera
                      await _capturePhoto();
                    },
                    child: const Icon(Icons.camera_alt, color: Colors.white,),
                  ),
              ],
            ),
            // const Text('*** The file size is less than 2 MB ***',  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
 Future<bool> _checkPermission({required bool forCamera}) async {
  if (forCamera) {
    return await Permission.camera.request().isGranted;
  } else {
    return await Permission.photos.request().isGranted;
  }
}


 
Future<void> _capturePhoto() async {
  if (await _checkPermission(forCamera: true)) {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (photo != null) {
        setState(() {
          if (result != null) {
            result!.files.add(PlatformFile(path: photo.path, name: 'captured_photo.jpg', size: 0));
          } else {
            result = FilePickerResult([PlatformFile(path: photo.path, name: 'captured_photo.jpg', size: 0)]);
          }
          selectedFileIndex = -1;
        });
      }
    } catch (e) {
      print('Error capturing photo: $e');
    }
  } else {
    // Handle permission denied
    print('Camera permission denied');
  }
}

  final ImagePicker _imagePicker = ImagePicker();

}

