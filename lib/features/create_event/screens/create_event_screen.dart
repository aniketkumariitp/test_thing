import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoodhappen_creator/features/create_event/provider/create_event_provider.dart';
import 'package:hoodhappen_creator/utils/glassmorphism_container.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameOfEvent = TextEditingController();
  final TextEditingController descriptionOfEvent = TextEditingController();
  final TextEditingController ticketPrice = TextEditingController();
  final TextEditingController totalSeats = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();
  final TextEditingController creatorUpiIDController = TextEditingController();

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              WillPopScope(
                onWillPop: () async {
                  final eventProvider = Provider.of<CreateEventProvider>(
                    context,
                    listen: false,
                  );
                  eventProvider.clearSelectedImage();

                  return true;
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    elevation: 0,
                    title: Text("Create New Event !!"),
                    backgroundColor: Colors.transparent,
                  ),
                  body: Stack(
                    children: [
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<CreateEventProvider>(
                                  builder: (context, eventProvider, child) {
                                    return GestureDetector(
                                      onTap: eventProvider.pickImage,
                                      child: GlassmorphicContainer(
                                        blur: 5,
                                        height: 200,
                                        width: double.infinity,
                                        image:
                                            eventProvider.selectedImage != null
                                            ? DecorationImage(
                                                image: FileImage(
                                                  eventProvider.selectedImage!,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,

                                        child:
                                            eventProvider.selectedImage == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.add, size: 40.0),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "Click Here to Upload Event Banner",
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: nameOfEvent,
                                  decoration: InputDecoration(
                                    hintText: "Name of event...",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: descriptionOfEvent,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: "Description about event...",
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final eventProvider =
                                              Provider.of<CreateEventProvider>(
                                                context,
                                                listen: false,
                                              );
                                          if (nameOfEvent.text.isEmpty ||
                                              descriptionOfEvent.text.isEmpty ||
                                              eventProvider.selectedImage ==
                                                  null) {
                                            Helper().showSnackBar(
                                              context,
                                              "Please fill all the details",
                                            );
                                          } else {
                                            _nextPage();
                                          }
                                        },
                                        child: const Text("Next"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  elevation: 0,
                  title: Text("Addition Details"),
                  backgroundColor: Colors.transparent,
                ),
                body: Stack(
                  children: [
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
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: totalSeats,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.chair),
                                  hintText: "Total no of seats...",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              Consumer<CreateEventProvider>(
                                builder: (context, eventProvider, child) {
                                  if (eventProvider.location != null &&
                                      locationController.text !=
                                          eventProvider.location) {
                                    locationController.text =
                                        eventProvider.location!;
                                  }

                                  return TextField(
                                    controller: locationController,
                                    readOnly:
                                        false, // ✅ ab user manually type kar sakta hai
                                    decoration: InputDecoration(
                                      prefixIcon: InkWell(
                                        onTap: () async {
                                          // ✅ Auto Location fetch on icon tap
                                          print("Cliced ✅");
                                          await eventProvider.getLocation(
                                            context,
                                            locationController,
                                          );

                                          if (eventProvider.mapurl != null) {
                                            Clipboard.setData(
                                              ClipboardData(
                                                text: eventProvider.mapurl!,
                                              ),
                                            );
                                            // ScaffoldMessenger.of(
                                            //   context,
                                            // ).showSnackBar(
                                            //   const SnackBar(
                                            //     content: Text(
                                            //       "Map URL copied to clipboard",
                                            //     ),
                                            //     backgroundColor: Colors.green,
                                            //   ),
                                            // );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  eventProvider.mapurl!,
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            print(eventProvider.mapurl!);
                                          }
                                        },
                                        child: const Icon(
                                          Icons.my_location,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      hintText:
                                          "Enter location or tap icon to auto fetch...",
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Consumer<CreateEventProvider>(
                              //   builder: (context, eventProvider, child) {
                              //     if (eventProvider.location != null &&
                              //         locationController.text !=
                              //             eventProvider.location) {
                              //       locationController.text =
                              //           eventProvider.location!;
                              //     }

                              //     return InkWell(
                              //       onTap: () async {
                              //         await eventProvider.getLocation(context);
                              //         if (eventProvider.mapsUrl != null) {
                              //           Clipboard.setData(
                              //             ClipboardData(
                              //               text: eventProvider.mapsUrl!,
                              //             ),
                              //           );
                              //           ScaffoldMessenger.of(
                              //             context,
                              //           ).showSnackBar(
                              //             const SnackBar(
                              //               content: Text(
                              //                 "Map URL copied to clipboard",
                              //               ),
                              //               backgroundColor: Colors.green,
                              //             ),
                              //           );
                              //         }
                              //       },
                              //       child: IgnorePointer(
                              //         child: TextField(
                              //           controller: locationController,
                              //           readOnly: true,
                              //           decoration: InputDecoration(
                              //             prefixIcon: Icon(Icons.location_city),
                              //             hintText: "Tap to fetch location...",
                              //             border: OutlineInputBorder(),
                              //           ),
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // ),
                              SizedBox(height: 20),
                              TextField(
                                controller: ticketPrice,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Ticket Price...",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(
                                      left: 12,
                                      right: 4,
                                    ),
                                    child: Text(
                                      '₹',

                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 0,
                                    minHeight: 0,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: contactNumber,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: "Contact Number...",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(
                                      left: 12,
                                      right: 4,
                                    ),
                                    child: Text(
                                      '+91',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 0,
                                    minHeight: 0,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Consumer<CreateEventProvider>(
                                      builder: (context, eventValue, child) {
                                        return ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          icon: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: const Icon(Icons.date_range),
                                          ),
                                          label: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: Text(
                                              eventValue.startDateTime == null
                                                  ? "Start Date & Time"
                                                  : Helper.formatDateTime(
                                                      eventValue.startDateTime!,
                                                    ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          onPressed: () =>
                                              eventValue.pickDateTime(
                                                context: context,
                                                isStart: true,
                                              ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  const Text(
                                    "To",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Consumer<CreateEventProvider>(
                                      builder: (context, eventValue, child) {
                                        return ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          icon: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: const Icon(Icons.date_range),
                                          ),
                                          label: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: Text(
                                              eventValue.endDateTime == null
                                                  ? "End Date & Time"
                                                  : Helper.formatDateTime(
                                                      eventValue.endDateTime!,
                                                    ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          onPressed: () =>
                                              eventValue.pickDateTime(
                                                context: context,
                                                isStart: false,
                                              ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Row(
                                children: [
                                  _currentPage != 0
                                      ? Expanded(
                                          child: OutlinedButton(
                                            onPressed: _prevPage,
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                            ),
                                            child: const Text(
                                              "Back",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Expanded(
                                          child: SizedBox(),
                                        ), // or Spacer() if not in Expanded

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final eventProvider =
                                            Provider.of<CreateEventProvider>(
                                              context,
                                              listen: false,
                                            );
                                        if (totalSeats.text.isEmpty ||
                                            locationController.text.isEmpty ||
                                            ticketPrice.text.isEmpty ||
                                            contactNumber.text.isEmpty ||
                                            eventProvider.startDateTime ==
                                                null ||
                                            eventProvider.endDateTime == null) {
                                          Helper().showSnackBar(
                                            context,
                                            "Please fill all the details",
                                          );
                                        } else {
                                          print(eventProvider.startDateTime);
                                          print(eventProvider.endDateTime);
                                          _nextPage();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                      child: const Text("Next"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  elevation: 0,
                  title: Text("Addition Details"),
                  backgroundColor: Colors.transparent,
                ),
                body: Stack(
                  children: [
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
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: creatorUpiIDController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.money),
                                  hintText: "Enter you UPI ID...",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: Consumer<CreateEventProvider>(
                                  builder: (context, eventProvider, child) {
                                    return ElevatedButton(
                                      onPressed: () async {
                                        // ✅ Basic form validation
                                        if (nameOfEvent.text.isEmpty ||
                                            descriptionOfEvent.text.isEmpty ||
                                            ticketPrice.text.isEmpty ||
                                            creatorUpiIDController
                                                .text
                                                .isEmpty ||
                                            totalSeats.text.isEmpty ||
                                            contactNumber.text.length != 10 ||
                                            eventProvider.selectedImage ==
                                                null ||
                                            eventProvider.startDateTime ==
                                                null ||
                                            eventProvider.endDateTime == null ||
                                            locationController.text.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please fill all fields correctly.",
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }

                                        // ✅ Handle mapsUrl
                                        if (eventProvider.mapurl == null ||
                                            eventProvider.mapurl!.isEmpty) {
                                          eventProvider.mapurl =
                                              "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(locationController.text.trim())}";
                                        }

                                        // ✅ Debug print before API call
                                        print({
                                          'eventName ✅✅': nameOfEvent.text,
                                          'description':
                                              descriptionOfEvent.text,
                                          'ticketPrice': ticketPrice.text,
                                          'totalSeats': totalSeats.text,
                                          'contact': contactNumber.text,
                                          'image': eventProvider.selectedImage,
                                          'startDate':
                                              eventProvider.startDateTime,
                                          'endDate': eventProvider.endDateTime,
                                          'location': locationController.text
                                              .trim(),
                                          'mapsUrl': eventProvider.mapurl,
                                        });

                                        // ✅ Call provider function
                                        await eventProvider.addEvent(
                                          context: context,
                                          eventName: nameOfEvent.text.trim(),
                                          eventDiscriptioion: descriptionOfEvent
                                              .text
                                              .trim(),
                                          eventTotalSeat: int.parse(
                                            totalSeats.text.trim(),
                                          ),
                                          eventLoaction: locationController.text
                                              .trim(), // ✅ always save location text
                                          eventMapLocation: eventProvider
                                              .mapurl!, // ✅ always save map link separately
                                          ticketPrice: int.parse(
                                            ticketPrice.text.trim(),
                                          ),
                                          creatorUpiID: creatorUpiIDController
                                              .text
                                              .trim(),
                                          contactNumber: contactNumber.text
                                              .trim(),
                                        );

                                        eventProvider.mapurl = "";

                                        // ✅ Handle error / success
                                        if (eventProvider.error != null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                eventProvider.error!,
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          print(
                                            "❌ Error: ${eventProvider.error}",
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Event created successfully!",
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );

                                          // ✅ Clear form after success
                                          nameOfEvent.clear();
                                          descriptionOfEvent.clear();
                                          ticketPrice.clear();
                                          totalSeats.clear();
                                          contactNumber.clear();
                                          creatorUpiIDController.clear();
                                          locationController.clear();
                                        }
                                      },

                                      style:
                                          ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          ).copyWith(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                  Colors.transparent,
                                                ),
                                            elevation:
                                                MaterialStateProperty.all(0),
                                          ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF4CAF50),
                                              Color(0xFF2E7D32),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          constraints: const BoxConstraints(
                                            minHeight: 50,
                                          ),
                                          child: const Text(
                                            "Create Event",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  _currentPage != 0
                                      ? Expanded(
                                          child: OutlinedButton(
                                            onPressed: _prevPage,
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 16,
                                                  ),
                                            ),
                                            child: const Text(
                                              "Back",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Expanded(
                                          child: SizedBox(),
                                        ), // or Spacer() if not in Expanded
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
