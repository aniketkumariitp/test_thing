import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/my_events/service/my_event_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  final String currentEventId;

  const QrScannerScreen({super.key, required this.currentEventId});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showAlert(String title, String message, {bool success = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            title,
            style: TextStyle(
              color: success ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message, style: const TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _isProcessing = false);
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.purpleAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleBarcode(String scannedData) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final Map<String, dynamic> data = jsonDecode(scannedData);

      final String userId = data['userId'];
      final String eventId = data['eventId'];

      if (userId.isEmpty || eventId.isEmpty) {
        throw Exception("Missing userId or eventId in QR code.");
      }

      if (eventId != widget.currentEventId) {
        throw Exception("❌ This ticket is not for this event.");
      }

      final message = await MyEventService.verifyTicket(userId, eventId);

      _showAlert("Party On 🎉", "✅ $message", success: true);
    } catch (e) {
      _showAlert("Error", e.toString(), success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Party Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4517E9), Color(0xFF7A3CE7), Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Scanner
          MobileScanner(
            overlayBuilder: (context, constraints) {
              return Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(
                            _animationController.value,
                          ),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: child,
                    );
                  },
                ),
              );
            },
            onDetect: (barcodeCapture) {
              final barcode = barcodeCapture.barcodes.first;
              final scannedCode = barcode.rawValue;
              if (scannedCode != null) {
                _handleBarcode(scannedCode);
              }
            },
          ),

          // Title
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "🔎 Party Ticket Scanner 🔎",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Instruction
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Align QR code inside the box",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
