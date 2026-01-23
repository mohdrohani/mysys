import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerController {
  late MobileScannerController mobileScannerController;

  BarcodeScannerController() {
    mobileScannerController = MobileScannerController(
      autoStart: true,
      torchEnabled: false,
    );
  }

  /// Start the scanner
  void startScanning() {
    mobileScannerController.start();
  }

  /// Stop the scanner
  void stopScanning() {
    mobileScannerController.stop();
  }

  /// Toggle the torch/flashlight
  Future<void> toggleTorch() async {
    await mobileScannerController.toggleTorch();
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    await mobileScannerController.switchCamera();
  }

  /// Dispose of the controller
  void dispose() {
    mobileScannerController.dispose();
  }

  /// Get the controller instance
  MobileScannerController getController() {
    return mobileScannerController;
  }
}
