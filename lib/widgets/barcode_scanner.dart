import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mysys/l10n/app_localizations.dart';

class BarcodeScanner extends StatefulWidget {
  final Function(String) onBarcodeDetected;
  final String? title;

  const BarcodeScanner({
    super.key,
    required this.onBarcodeDetected,
    this.title,
  });

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  late MobileScannerController controller;
  bool isTorchOn = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      autoStart: true,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleBarcodeDetected(String barcodeValue) {
    // Prevent multiple detections
    if (_isProcessing) return;
    _isProcessing = true;

    // Stop the scanner immediately to prevent more detections
    controller.stop();
    
    // Call the callback
    widget.onBarcodeDetected(barcodeValue);
    
    // Navigate back with the result
    if (mounted) {
      Navigator.pop(context, barcodeValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allcolors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: allcolors.primary,
        centerTitle: true,
        iconTheme: IconThemeData(color: allcolors.onPrimary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: allcolors.onPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title ?? 'Scan Barcode',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: allcolors.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isTorchOn ? Icons.flash_on : Icons.flash_off),
            color: allcolors.onPrimary,
            onPressed: () async {
              await controller.toggleTorch();
              setState(() {
                isTorchOn = !isTorchOn;
              });
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              // Handle barcode detection
              _handleBarcodeDetected(barcode.rawValue!);
              return;
            }
          }
        },
        errorBuilder: (context, error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 80,
                  color: allcolors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Camera permission denied',
                  style: TextStyle(
                    fontSize: 16,
                    color: allcolors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allcolors.secondary,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Go Back',
                    style: TextStyle(color: allcolors.onSecondary),
                  ),
                ),
              ],
            ),
          );
        },
        placeholderBuilder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: allcolors.secondary,
            ),
          );
        },
      ),
    );
  }
}
