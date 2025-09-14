import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoodhappen_creator/features/deatils_of_event/service/RazorpayService.dart';
import 'package:hoodhappen_creator/features/get_event/model/get_event_model.dart';
import 'package:hoodhappen_creator/utils/glassmorphism_container.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsEventScreen extends StatefulWidget {
  const DetailsEventScreen({super.key});

  @override
  State<DetailsEventScreen> createState() => _DetailsEventScreenState();
}

class _DetailsEventScreenState extends State<DetailsEventScreen> {
  late final Data event;
  final ScrollController _scrollController = ScrollController();

  double _appBarOpacity = 1.0; // 👈 instead of hiding, just fade
  TextEditingController _couponController = TextEditingController();
  int? discountedPrice; // price after coupon
  bool isCouponApplied = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_appBarOpacity != 0) {
          setState(() => _appBarOpacity = 0);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_appBarOpacity != 1) {
          setState(() => _appBarOpacity = 1);
        }
      }
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    event = GoRouterState.of(context).extra as Data;
    precacheImage(CachedNetworkImageProvider(event.eventBanner!), context);

    // Reset coupon state every time user comes to this screen
    _couponController.clear();
    discountedPrice = null;
    isCouponApplied = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:
          AppBar(
              title: const Text('🎟️ Event Details'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/animations/bg.gif',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          /// Using ListView for lazy rendering (90 fps smooth)
          Center(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(12, 80, 12, 40),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(.3),
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // shrink to content height
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.zero,
                            child: InteractiveViewer(
                              child: CachedNetworkImage(
                                imageUrl: event.eventBanner!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: event.eventBanner!,
                              fit: BoxFit.cover,
                              height: 220,
                              width: double.infinity,
                            ),
                            Container(
                              height: 220,
                              color: Colors.black.withOpacity(0.25),
                            ),
                            const Text(
                              "Click to see full poster",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoCard(event.eventName!),
                    const SizedBox(height: 12),
                    DescriptionCard(text: event.eventDescription!),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _infoCard(
                            Helper.specilaDateFormat2(event.startDate!),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("To", style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _infoCard(
                            Helper.specilaDateFormat2(event.endDate!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: _infoCard(
                            "Contact Us : ${event.contactNumber}",
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            final phoneUri = Uri(
                              scheme: 'tel',
                              path: '+91${event.contactNumber}',
                            );
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            }
                          },
                          child: GlassmorphicContainer(
                            padding: EdgeInsets.zero,
                            borderRadius: 10,
                            child: Center(
                              child: Image.asset(
                                "assets/animations/mobile.png",
                                height: 28,
                              ),
                            ),
                            height: 45,
                            width: 45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            child: TextField(
                              textCapitalization: TextCapitalization.characters,
                              controller: _couponController,
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                hintText: "Enter Coupon Code",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Expanded(
                        //   flex: 1,
                        //   child: SizedBox(
                        //     height: 50,
                        //     child: ElevatedButton(
                        //       onPressed: isCouponApplied
                        //           ? null
                        //           : () async {
                        //               String enteredCode = _couponController
                        //                   .text
                        //                   .trim();
                        //               if (enteredCode.isEmpty) {
                        //                 ScaffoldMessenger.of(
                        //                   context,
                        //                 ).showSnackBar(
                        //                   const SnackBar(
                        //                     content: Text(
                        //                       "Please Enter Coupon Code",
                        //                     ),
                        //                     backgroundColor: Colors.red,
                        //                   ),
                        //                 );
                        //                 return;
                        //               }

                        //               int? finalPrice = await applyCoupon(
                        //                 enteredCode,
                        //                 event
                        //                     .ticketPrice!, // always send original price
                        //                 context,
                        //               );

                        //               if (finalPrice != null) {
                        //                 ScaffoldMessenger.of(
                        //                   context,
                        //                 ).showSnackBar(
                        //                   const SnackBar(
                        //                     content: Text("Coupon applied!"),
                        //                     backgroundColor: Colors.green,
                        //                   ),
                        //                 );
                        //                 setState(() {
                        //                   discountedPrice =
                        //                       finalPrice; // only update local price
                        //                   isCouponApplied = true;
                        //                 });
                        //               }
                        //             },
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: isCouponApplied
                        //             ? Colors.grey
                        //             : const Color(0xFF4517E9),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(14),
                        //         ),
                        //       ),
                        //       child: const Text(
                        //         "Apply",
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: isCouponApplied
                                  ? null
                                  : () async {
                                      String enteredCode = _couponController
                                          .text
                                          .trim();

                                      if (enteredCode.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Please Enter Coupon Code",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }

                                      // ✅ Close keyboard first
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      // ✅ wait ek frame tak before API call
                                      await Future.delayed(
                                        Duration(milliseconds: 100),
                                      );

                                      int? finalPrice = await applyCoupon(
                                        event.id!,
                                        enteredCode,
                                        event
                                            .ticketPrice!, // always send original price
                                        context,
                                      );

                                      if (finalPrice != null && mounted) {
                                        setState(() {
                                          discountedPrice = finalPrice;
                                          isCouponApplied = true;
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Coupon applied!"),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCouponApplied
                                    ? Colors.grey
                                    : const Color(0xFF4517E9),
                                disabledBackgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "Apply",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse(event.eventLocation!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: GlassmorphicContainer(
                        borderRadius: 14,
                        padding: EdgeInsets.zero,
                        blur: 3,
                        cc: const Color(0XFF0000FF),
                        child: const Center(
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
                    const SizedBox(height: 15),

                    _buildGradientButton(
                      context,
                      discountedPrice ?? event.ticketPrice!,
                      event.eventTotalseat!,
                      event.eventBookedseats!,
                      event,
                    ),
                  ],
                ),
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    String text, {
    double height = 50,
    double fontSize = 10,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildGradientButton(
    BuildContext context,
    int displayedPrice, // pass discountedPrice ?? event.ticketPrice
    int totalSeat,
    int bookedSeats,
    Data event,
  ) {
    final bool seatsAvailable = bookedSeats < totalSeat;

    return Material(
      borderRadius: BorderRadius.circular(14),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: seatsAvailable
            ? () async {
                final userId = await Helper.getUserID();
                RazorpayService razorpayService = RazorpayService();
                await razorpayService.startPayment(
                  email: event.creator!.email!,
                  contact: event.contactNumber!,
                  context: context,
                  userId: userId!,
                  eventId: event.id!,
                  amount: displayedPrice, // use the displayed price
                );
              }
            : null, // disables tap when no seats available
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: seatsAvailable ? const Color(0XFF4517E9) : Colors.grey,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            seatsAvailable
                ? "Pay ₹$displayedPrice and Book Now"
                : "All Seats Booked 😞",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class DescriptionCard extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const DescriptionCard({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.fontWeight = FontWeight.normal,
  });

  @override
  State<DescriptionCard> createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.firaSans(
      color: Colors.white.withOpacity(0.9),
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
      height: 1.4,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: textStyle,
            textAlign: TextAlign.justify,
            maxLines: isExpanded ? null : 6,
            overflow: TextOverflow.fade,
          ),
          if (widget.text.length > 120)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Text(
                  isExpanded ? "Show less ▲" : "Show more ▼",
                  style: GoogleFonts.firaSans(
                    color: Colors.blueAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
