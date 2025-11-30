import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceSpecs {
  final String deviceModel;
  final String osVersion;
  final int cpuCores;
  final double ramGB;
  final String architecture;

  DeviceSpecs({
    required this.deviceModel,
    required this.osVersion,
    required this.cpuCores,
    required this.ramGB,
    required this.architecture,
  });
}

class DeviceInfo {
  static final DeviceInfo _instance = DeviceInfo._internal();
  factory DeviceInfo() => _instance;
  DeviceInfo._internal();

  DeviceSpecs? _specs;

  Future<DeviceSpecs> getDeviceSpecs() async {
    if (_specs != null) return _specs!;

    final deviceInfo = DeviceInfoPlugin();
    
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      _specs = DeviceSpecs(
        deviceModel: '${androidInfo.brand} ${androidInfo.model}',
        osVersion: 'Android ${androidInfo.version.release}',
        cpuCores: _estimateCpuCores(),
        ramGB: _estimateRamGB(),
        architecture: _getArchitecture(androidInfo.supportedAbis),
      );
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _specs = DeviceSpecs(
        deviceModel: iosInfo.model,
        osVersion: '${iosInfo.systemName} ${iosInfo.systemVersion}',
        cpuCores: _estimateCpuCores(),
        ramGB: _estimateRamGB(),
        architecture: 'ARM64',
      );
    } else {
      _specs = DeviceSpecs(
        deviceModel: 'Desktop',
        osVersion: Platform.operatingSystem,
        cpuCores: Platform.numberOfProcessors,
        ramGB: 8.0,
        architecture: 'x64',
      );
    }

    return _specs!;
  }

  int _estimateCpuCores() {
    return Platform.numberOfProcessors;
  }

  double _estimateRamGB() {
    // Simplified RAM estimation
    if (Platform.isAndroid || Platform.isIOS) {
      return 6.0; // Typical mobile device
    }
    return 16.0; // Desktop default
  }

  String _getArchitecture(List<String> abis) {
    if (abis.contains('arm64-v8a')) return 'ARM64';
    if (abis.contains('armeabi-v7a')) return 'ARM32';
    return 'x64';
  }

  bool isOptimalForLLM() {
    if (_specs == null) return false;
    return _specs!.cpuCores >= 4 && _specs!.ramGB >= 4.0;
  }

  int getRecommendedThreads() {
    if (_specs == null) return 4;
    return (_specs!.cpuCores * 0.75).round().clamp(2, 8);
  }
}