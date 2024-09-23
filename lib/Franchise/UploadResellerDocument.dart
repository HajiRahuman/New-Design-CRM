
import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:crm/service/reseller.dart' as resellerSrv;
import 'package:signature/signature.dart';
import '../../model/subscriber.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http_parser/http_parser.dart';


class ResellerDocUpload extends StatefulWidget {
  SubscriberFullDet? subscriberDet;
  final int resellerId;
  final bool? isLogo;
  final bool? isSign;
  ResellerDocUpload({Key? key, required this.resellerId,required this.isSign,required this.isLogo}) : super(key: key);

  @override
  State<ResellerDocUpload> createState() => _MainScreenState();
}

class _MainScreenState extends State<ResellerDocUpload> {
  TextEditingController docIdController = TextEditingController();
  final form = FormGroup({
    'doctype': FormControl<int>(validators: [Validators.required]),
  });

  bool isLogoValue = false;
  bool isSignValue = false;
  @override
  void initState() {
    super.initState();


    if (widget.isLogo!) {
      print('IsLogo-----${widget.isLogo}');
      form.control('doctype').value = 1;
      isLogoValue = true;
    }

    if (widget.isSign!) {
      print('IsSign-----${widget.isSign}');
      form.control('doctype').value = 2;
      isSignValue = false;
    }


  }

  @override
  FilePickerResult? result;
  int selectedFileIndex = -1;
  List<int> selectedFileIndices = [];
  List<PlatformFile>? images;

  bool showSpinner = false;

  Future<void> UploadDocuments(int resellerId, List<PlatformFile> platformFiles, Uint8List? signatureImage) async {
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
          'file': multiPartFiles,
          'doctype': form.value['doctype'],
        });

        final resp = await resellerSrv.uploadResellerDocument(
            resellerId, isLogoValue, isSignValue, formData);

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
    exportBackgroundColor: Colors.white,
  );

  bool isExpanded = false;
  Uint8List? exportedImage;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.width;
     final notifier = Provider.of<ColorNotifire>(context);
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      color: notifier.getbgcolor,
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
                            Text(
                              widget.isSign! ? 'Upload Signature' : 'Upload Logo',
                              style: TextStyle(
                          fontSize: screenWidth * 0.04,
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
                                                                          icon: Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color: notifier.getMainText,
                                                                          ),
                                                                        ),
                                                                      ),
                          ],
                        ),
                      ),
                   
                  const SizedBox(height: 20),
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
                            child:ElevatedButton(
                              onPressed: () async {
                                exportedImage = await controller.toPngBytes();
                                UploadDocuments(widget.resellerId, [], exportedImage);
                              },
                              style:  ElevatedButton.styleFrom(
                               backgroundColor: appMainColor
                              ),
                              child: const Text("Submit",
                                style: TextStyle(
                                    fontSize: 20,color:Colors.white),
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
                               backgroundColor: appMainColor
                              ),
                              child: const Text("Clear", style: TextStyle(
                                  fontSize: 20,color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (result != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                      icon: const Icon(Icons.clear, color: Colors.black),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appMainColor
                            ),
                            onPressed: () async {
                              if (form.valid) {} else {
                                form.markAllAsTouched();
                              }
                              UploadDocuments(widget.resellerId, result?.files ?? [],null);
                            },
                            child: const Text('Submit',
                                style: TextStyle(color: Colors.white)),
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
                ElevatedButton(
                  style:  ElevatedButton.styleFrom(
                  backgroundColor: appMainColor
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                ),
                const SizedBox(width: 10),
                if(widget.isSign!=true)
                  FloatingActionButton(
                    backgroundColor: appMainColor,
                    onPressed: () async {
                      if (await _checkPermission()) {
                        var pickedFiles = await FilePicker.platform.pickFiles(allowMultiple: true);
                        if (pickedFiles == null) {
                          print("No file selected");
                        } 
                        
                        else {
                           bool filesWithinLimit = true;

        pickedFiles.files.forEach((element) {
          int fileSizeInKB = element.size ~/ 1024;
          double fileSizeInMB = fileSizeInKB / 1024;
          if (fileSizeInMB > 2) {
            filesWithinLimit = false;
          }
        });

        if (!filesWithinLimit) {
         
          CherryToast.error(
      enableIconAnimation: false,
      
      description: Text('File size is too large. Maximum allowed size is 2 MB', style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      animationType: AnimationType.fromRight,
      animationDuration: Duration(milliseconds: 1000),
      autoDismiss: true, title:Text(''),
    ).show(context);
          return;
        }
                          if (widget.isLogo! == true ? pickedFiles.files.length == 1 : false)  {
                            setState(() {
                              result = pickedFiles;
                              selectedFileIndex = -1;
                            });
                            pickedFiles.files.forEach((element) {
                              print(element.name);
                            });
                          } else {
                            // Show error toast
          print('Maximum ${widget.isLogo != true ? '2 files' : '1 file'} can be selected.');
                          }
                        }
                      }
                    },
                    child: const Icon(Icons.attach_file),
                  ),
                 
              ],
            ),
              const Text('*** The file size is less than 2 MB ***',  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
  Future<bool> _checkPermission() async {
   
      // Requesting manageExternalStorage permission for Android 10 and above
      return await Permission.photos.request().isGranted;
    
  }




}

