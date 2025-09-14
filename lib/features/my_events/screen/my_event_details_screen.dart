import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hoodhappen_creator/features/my_events/model/my_event_model.dart';
import 'package:hoodhappen_creator/features/my_events/screen/qr_screen.dart';
import 'package:hoodhappen_creator/utils/glassmorphism_container.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class MyEventDetailsScreen extends StatelessWidget {
  const MyEventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = GoRouterState.of(context).extra as CreatedEvent;
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
          // 🔵 Deep black background
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
                        GlassmorphicContainer(
                          padding: EdgeInsets.all(0),
                          child: Image.network(
                            event.eventBanner!,
                            fit: BoxFit.cover,
                          ),
                          height: 170,
                          width: double.infinity,
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          height: 40,
                          width: double.infinity,
                        ),
                        SizedBox(height: 10),
                        GlassmorphicContainer(
                          padding: EdgeInsets.all(10),
                          borderRadius: 10,
                          child: Center(
                            child: Text(
                              event.eventDescription!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          height: 90,
                          width: double.infinity,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GlassmorphicContainer(
                                padding: EdgeInsets.all(0),
                                borderRadius: 10,
                                child: Center(
                                  child: Text(
                                    "Total Seats : ${event.eventTotalseat.toString()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                height: 50,
                                width: double.infinity,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: GlassmorphicContainer(
                                padding: EdgeInsets.all(0),
                                borderRadius: 10,
                                child: Center(
                                  child: Text(
                                    "Booked : ${event.eventTotalseat! - remainingSeats!}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
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
                        Row(
                          children: [
                            Expanded(
                              child: GlassmorphicContainer(
                                padding: EdgeInsets.zero,
                                borderRadius: 10,
                                child: Center(
                                  child: AutoSizeText(
                                    Helper.specilaDateFormat2(event.startDate!),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    minFontSize:
                                        8, // chhoti screen pe adjust hoga
                                    overflow: TextOverflow.ellipsis,
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
                                padding: EdgeInsets.zero,
                                borderRadius: 10,
                                child: Center(
                                  child: AutoSizeText(
                                    Helper.specilaDateFormat2(event.endDate!),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    minFontSize:
                                        8, // chhoti screen pe adjust hoga
                                    overflow: TextOverflow.ellipsis,
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
                                    "${event.contactNumber}",
                                    style: TextStyle(
                                      color: Colors.white,

                                      fontSize: 20,
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
                        const SizedBox(height: 10),
                        _buildGradientButton(context, event.id!),
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

Widget _buildGradientButton(BuildContext context, String eventId) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QrScannerScreen(
                  currentEventId: eventId, // ✅ yahan event id bheja
                ),
              ),
            );
          },
          child: Container(
            height: 52,
            alignment: Alignment.center,
            child: const Text(
              "Check Ticket !!!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
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
