import 'dart:math';

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