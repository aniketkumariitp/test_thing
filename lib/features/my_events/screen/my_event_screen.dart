import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hoodhappen_creator/features/my_events/provider/my_event_provider.dart';
import 'package:hoodhappen_creator/features/my_events/widgets/my_event_card.dart';
import 'package:provider/provider.dart';

class MyEventScreen extends StatefulWidget {
  final Function(bool isVisible)? onScroll;
  const MyEventScreen({super.key, this.onScroll});

  @override
  State<MyEventScreen> createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MyEventProvider>(
        context,
        listen: false,
      ).fetchEvents(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = kToolbarHeight;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          '🎉 Your Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // 🔁 Background GIF
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

          // 👇 Main content with top padding to avoid AppBar overlap
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 60, 5, 16),
            child: Consumer<MyEventProvider>(
              builder: (context, provider, child) {
                final events = provider.events;

                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (events.isEmpty) {
                  return const Center(
                    child: Text(
                      'No events created yet!',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                }

                return NotificationListener<UserScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (widget.onScroll != null) {
                      if (scrollNotification.direction ==
                          ScrollDirection.forward) {
                        widget.onScroll!(true); // show bottom nav
                      } else if (scrollNotification.direction ==
                          ScrollDirection.reverse) {
                        widget.onScroll!(false); // hide bottom nav
                      }
                    }
                    return false;
                  },
                  child: SafeArea(
                    top: false,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MyEventCard(
                            eventTitle: event.eventName ?? 'Untitled',
                            bannerImage: event.eventBanner ?? '',
                            startDate: event.startDate ?? DateTime.now(),
                            endDate: event.endDate ?? DateTime.now(),
                            location:
                                event.eventMapLocation ?? 'Unknown Location',
                            event: event,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
