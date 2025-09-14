import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoodhappen_creator/features/joined_events/model/joined_event_model';
import 'package:hoodhappen_creator/utils/glassmorphism_container.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class JoinedEventDetailsScreen extends StatelessWidget {
  const JoinedEventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = GoRouterState.of(context).extra as Eventdata;
    final remainingSeats = (event.eventTotalseat! - event.eventBookedseats!);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('🎟️ Event Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // // 🔵 Deep black background
          Positioned.fill(
            child: Image.network(
              'https://64.media.tumblr.com/bff245925ee537755c3c3b1f9a3f2a7f/tumblr_oq9smvbNLz1vsjcxvo1_540.gif',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // 🧊 Semi-transparent overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: .5, sigmaY: .5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Open full screen image
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.zero,
                                child: InteractiveViewer(
                                  child: CachedNetworkImage(
                                    imageUrl: event.eventBanner!,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: event.eventBanner!,
                                fit: BoxFit.cover,
                                height: 220,

                                width: double.infinity,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 220,
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                "Click to see full poster",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        GlassmorphicContainer(
                          padding: EdgeInsets.all(0),
                          borderRadius: 10,
                          child: Center(
                            child: Text(
                              event.eventName!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 13
                              ),
                            ),
                          ),
                          height: 60,
                          width: double.infinity,
                        ),
                        SizedBox(height: 10),
                        _descriptionCard(event.eventDescription!),

                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GlassmorphicContainer(
                                padding: EdgeInsets.all(0),
                                borderRadius: 10,
                                child: Center(
                                  child: Text(
                                    Helper.specilaDateFormat2(event.startDate!),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("To"),
                            SizedBox(width: 10),
                            Expanded(
                              child: GlassmorphicContainer(
                                padding: EdgeInsets.all(0),
                                borderRadius: 10,
                                child: Center(
                                  child: Text(
                                    Helper.specilaDateFormat2(event.endDate!),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // _-------------------------
                        Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: GlassmorphicContainer(
                                padding: EdgeInsets.all(0),
                                borderRadius: 10,
                                child: Center(
                                  child: Text(
                                    "Contact Us : ${event.contactNumber}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                height: 40,
                                width: double.infinity,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final Uri phoneUri = Uri(
                                    scheme: 'tel',
                                    path: '+91${event.contactNumber}',
                                  );
                                  if (await canLaunchUrl(phoneUri)) {
                                    await launchUrl(phoneUri);
                                  } else {
                                    debugPrint('Could not launch $phoneUri');
                                  }
                                },
                                child: GlassmorphicContainer(
                                  padding: EdgeInsets.all(0),
                                  borderRadius: 10,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/animations/mobile.png",
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  height: 40,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () async {
                            final googleMapsUrl = event
                                .eventLocation!; // your URL like https://www.google.com/maps/search/?api=1&query=25.7132407,85.2227286

                            final uri = Uri.parse(googleMapsUrl);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Could not open Google Maps"),
                                ),
                              );
                            }
                          },
                          child: GlassmorphicContainer(
                            borderRadius: 14,
                            padding: EdgeInsets.all(0),
                            cc: const Color(0XFF0000FF),
                            child: Center(
                              child: Text(
                                "Navigate to Event",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            height: 52,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildGradientButton(context, event),
                      ],
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

Widget _descriptionCard(
  String text, {
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.normal,
}) {
  bool isExpanded = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300), // smooth expand/collapse
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        width: double.infinity,
        height: isExpanded ? 250 : 100, // 👈 controlled height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: isExpanded
                  ? ScrollConfiguration(
                      behavior: const _NoGlowBehavior(),
                      child: SingleChildScrollView(
                        physics:
                            const ClampingScrollPhysics(), // 👈 smooth scroll
                        child: Text(
                          text,
                          style: GoogleFonts.firaSans(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                          ),
                          textAlign: TextAlign.justify, // 👈 better alignment
                        ),
                      ),
                    )
                  : Text(
                      text,
                      style: GoogleFonts.firaSans(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            if (text.length > 100)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? "Show less" : "Show more",
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

Widget _buildGradientButton(BuildContext context, Eventdata event) {
  final String qrData = jsonEncode({
    "eventId": event.eventId,
    "userId": event.userId,
  });

  return SizedBox(
    width: double.infinity,
    child: Material(
      borderRadius: BorderRadius.circular(14),
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0XFF4517E9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            context.push("/my-ticket", extra: qrData);
          },
          child: Container(
            height: 52,
            alignment: Alignment.center,
            child: const Text(
              "My Ticket !!!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();

  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
