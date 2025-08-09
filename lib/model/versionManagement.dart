

class VersionManagement {

 final String  current_version;
  final bool isUpdateAvailable;
    final bool isForceUpdate;
 

  VersionManagement({
    
    required this.current_version,
    required this.isUpdateAvailable,
    required this.isForceUpdate,
  });

  factory VersionManagement.fromJson(Map<String, dynamic> json) {
    return VersionManagement(
      current_version: json['current_version'] ?? "",
      isUpdateAvailable: json['isUpdateAvailable'] ?? false,
      isForceUpdate: json['isForceUpdate'] ?? false,
    );
  }
}
class VersionManagementResp {
  final bool error;
  final String msg;
  final String current_version;
  final bool isUpdateAvailable;
  final bool isForceUpdate; 
  

  VersionManagementResp({
    required this.error,
    required this.msg,
    required this.current_version,
    required this.isUpdateAvailable,
    required this.isForceUpdate,
  });

  factory VersionManagementResp.fromJson(Map<dynamic, dynamic> data) {
    return VersionManagementResp(
      error: data['error'] as bool? ?? false,
      msg: data['msg'] as String? ?? 'Unknown error',
      current_version: data['current_version'] as String? ?? '', 
      isUpdateAvailable: data['isUpdateAvailable'] as bool? ?? false, 
      isForceUpdate: data['isForceUpdate'] as bool? ?? false, 
    );
  }
}