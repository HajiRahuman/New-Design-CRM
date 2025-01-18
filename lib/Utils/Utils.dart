
import 'dart:math';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import 'package:reactive_forms/reactive_forms.dart';
ColorNotifire notifier = ColorNotifire();
/// Formats the given bytes into a human-readable string (e.g., KB, MB, GB).
String formatBytes(int bytes) {
  if (bytes <= 0) return "--"; // Handle invalid or zero values
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  
  // Determine the size index using logarithm
  final i = (log(bytes) / log(k)).floor();
  
  // Calculate the value in the determined size
  final value = bytes / pow(k, i);
  
  return "${value.toStringAsFixed(2)} ${sizes[i]}";
}


class ReactiveSpinBox extends ReactiveFormField<int, int> {

  ReactiveSpinBox({
    Key? key,
    required String formControlName,
    InputDecoration? decoration,
    double min = 0,
    double max = 100,
    double step = 1,
    double? value,
     Map<String, String Function(Object?)>? validationMessages,
    List<TextInputFormatter>? inputFormatters, // Add this parameter
  }) : super(
          key: key,
          formControlName: formControlName,
             validationMessages: validationMessages,
          builder: (field) {
            return InputDecorator(
              decoration: (decoration ?? InputDecoration())
                  .copyWith(errorText: field.errorText),
              child: SpinBox(
                min: min,
                max: max,
                step: step,
                value: field.value?.toDouble() ?? value ?? min,
                onChanged: (value) => field.didChange(value.toInt()),
                decoration: InputDecoration(border: InputBorder.none,),
                textStyle: mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),
                iconColor: MaterialStateProperty.all(notifier.geticoncolor),
              ),
            );
          },
        );
}
