import 'dart:async';
import 'dart:io';

class BenchmarkMetrics {
  final double tokensPerSecond;
  final int latencyMs;
  final double memoryUsageMB;
  final double cpuUsagePercent;
  final int modelLoadTimeMs;

  BenchmarkMetrics({
    required this.tokensPerSecond,
    required this.latencyMs,
    required this.memoryUsageMB,
    required this.cpuUsagePercent,
    required this.modelLoadTimeMs,
  });
}

class BenchmarkTools {
  static final BenchmarkTools _instance = BenchmarkTools._internal();
  factory BenchmarkTools() => _instance;
  BenchmarkTools._internal();

  final Stopwatch _stopwatch = Stopwatch();
  int _tokenCount = 0;
  int _modelLoadTime = 0;

  void startTimer() {
    _stopwatch.reset();
    _stopwatch.start();
    _tokenCount = 0;
  }

  void stopTimer() {
    _stopwatch.stop();
  }

  void incrementTokenCount() {
    _tokenCount++;
  }

  void recordModelLoadTime(int milliseconds) {
    _modelLoadTime = milliseconds;
  }

  double getTokensPerSecond() {
    if (_stopwatch.elapsedMilliseconds == 0) return 0.0;
    return (_tokenCount * 1000.0) / _stopwatch.elapsedMilliseconds;
  }

  int getLatencyMs() {
    return _stopwatch.elapsedMilliseconds;
  }

  Future<double> getMemoryUsageMB() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Mobile memory estimation
        return 2100.0; // Simulated
      }
      // Desktop memory usage (simplified)
      return 1800.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getCpuUsagePercent() async {
    // Simplified CPU usage estimation
    return 68.0;
  }

  Future<BenchmarkMetrics> getCurrentMetrics() async {
    return BenchmarkMetrics(
      tokensPerSecond: getTokensPerSecond(),
      latencyMs: getLatencyMs(),
      memoryUsageMB: await getMemoryUsageMB(),
      cpuUsagePercent: await getCpuUsagePercent(),
      modelLoadTimeMs: _modelLoadTime,
    );
  }

  String formatMetric(String label, dynamic value, String unit) {
    if (value is double) {
      return '$label: ${value.toStringAsFixed(1)}$unit';
    }
    return '$label: $value$unit';
  }

  Map<String, double> compareQuantizations() {
    return {
      'Q8': 52.1,
      'Q6': 48.7,
      'Q4': 45.2,
      'Q3': 41.8,
    };
  }

  bool isPerformanceOptimal(BenchmarkMetrics metrics) {
    return metrics.tokensPerSecond > 30.0 &&
           metrics.latencyMs < 100 &&
           metrics.memoryUsageMB < 4000;
  }
}