// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class TicketDetailsScreen extends StatefulWidget {
//   const TicketDetailsScreen({super.key});

//   @override
//   State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
// }

// class _TicketDetailsScreenState extends State<TicketDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutBack,
//     );
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final event = GoRouterState.of(context).extra as String;

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: const Text('🎫 Your Ticket'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//           // 🔮 Background
//           Positioned.fill(
//             child: Image.network(
//               'https://64.media.tumblr.com/bff245925ee537755c3c3b1f9a3f2a7f/tumblr_oq9smvbNLz1vsjcxvo1_540.gif',
//               fit: BoxFit.cover,
//             ),
//           ),

//           // 🧊 Overlay
//           Positioned.fill(
//             child: Container(color: Colors.black.withOpacity(0.6)),
//           ),

//           // 🎟️ Main Ticket
//           Center(
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
//                   child: Container(
//                     width: 350,
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.05),
//                       borderRadius: BorderRadius.circular(30),
//                       border: Border.all(color: Colors.white.withOpacity(0.15)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.purpleAccent.withOpacity(0.4),
//                           blurRadius: 25,
//                           spreadRadius: 2,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // 🎨 Gradient Bar
//                         Container(
//                           height: 8,
//                           width: 100,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(50),
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFFFC67FA), Color(0xFF6A5AE0)],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // ✨ Header
//                         const Text(
//                           "Digital Pass",
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.4,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // 🧾 QR Code
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(24),
//                             gradient: const LinearGradient(
//                               colors: [Colors.white, Color(0xFFECEAFF)],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.white.withOpacity(0.3),
//                                 blurRadius: 12,
//                                 offset: const Offset(0, 8),
//                               ),
//                             ],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(
//                               24,
//                             ), // adjust radius as needed
//                             child: QrImageView(
//                               data: event,
//                               version: QrVersions.auto,
//                               size: 200,
//                               backgroundColor: Colors.white,
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         // 🧾 Event ID
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 10,
//                             horizontal: 16,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.06),
//                             borderRadius: BorderRadius.circular(18),
//                             border: Border.all(color: Colors.white12),
//                           ),
//                           child: Column(
//                             children: [
//                               const Text(
//                                 '⚠️ IMPORTANT NOTE ⚠️',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   letterSpacing: 1.2,
//                                   color: Colors.white60,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "Do not share this code to others",
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                   letterSpacing: 1.1,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 16),

//                         // 🔔 Note
//                         const Text(
//                           'Show this pass at entry gate',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.white54,
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  String? eventId;
  String? userId;
  String? rawTicket;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // extract data from GoRouter extra (only works in post frame callback)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is String) {
        setState(() {
          rawTicket = extra;
          final decoded = jsonDecode(extra);
          eventId = decoded['eventId'];
          userId = decoded['userId'];
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rawTicket == null || eventId == null || userId == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.purpleAccent),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('🎫 Your Ticket'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 🔮 Background
          Positioned.fill(
            child: Image.network(
              'https://64.media.tumblr.com/bff245925ee537755c3c3b1f9a3f2a7f/tumblr_oq9smvbNLz1vsjcxvo1_540.gif',
              fit: BoxFit.cover,
            ),
          ),

          // 🧊 Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          // 🎟️ Main Ticket
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🎨 Gradient Bar
                          Container(
                            height: 8,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFC67FA), Color(0xFF6A5AE0)],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ✨ Header
                          const Text(
                            "✨ Experience Pass ✨",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.4,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 🧾 QR Code
                          Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: [Colors.white, Color(0xFFECEAFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: PrettyQrView.data(
                                data: rawTicket!,
                                decoration: const PrettyQrDecoration(
                                  image: const PrettyQrDecorationImage(
                                    image: AssetImage(
                                      'assets/animations/party.png',
                                    ),
                                    scale: 0.18, // ✅ smaller image
                                  ),
                                  quietZone: PrettyQrQuietZone.standart,
                                  shape: PrettyQrShape.custom(
                                    PrettyQrSmoothSymbol(
                                      color: PrettyQrGradientBrush(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.purple,
                                            Colors.purple,
                                          ], // ✅ dark gradient
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                    finderPattern: const PrettyQrSmoothSymbol(
                                      color: PrettyQrGradientBrush(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.purple,
                                            Colors.purple,
                                          ], // ✅ dark gradient
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ), // ✅ keep solid
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ✅ Show Event ID

                          // ⚠️ Warning
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Column(
                              children: const [
                                Text(
                                  '⚠️ IMPORTANT NOTE ⚠️',
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                    color: Colors.white60,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Do not share this code with others",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 1.1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'Show this pass at entry gate',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
