import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hoodhappen_creator/features/get_event/screens/get_event_screen.dart';
import 'package:hoodhappen_creator/features/joined_events/screen/joined_event_screen.dart';
import 'package:hoodhappen_creator/features/my_events/screen/my_event_screen.dart';
import 'package:hoodhappen_creator/features/profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isBottomBarVisible = true; // bottom nav visibility

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    final List<Widget> _pages = [
      GetEventScreen(
        onScroll: (isVisible) {
          setState(() {
            _isBottomBarVisible = isVisible;
          });
        },
      ),
      MyEventScreen(
        onScroll: (isVisible) {
          setState(() {
            _isBottomBarVisible = isVisible;
          });
        },
      ),
      JoinedEventScreen(
        onScroll: (isVisible) {
          setState(() {
            _isBottomBarVisible = isVisible;
          });
        },
      ),
      ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF0B0B16),
      body: Stack(
        children: [
          _pages[_selectedIndex],

          // ================== Glassmorphic Bottom Nav ==================
          if (!isKeyboardOpen)
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isBottomBarVisible ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !_isBottomBarVisible,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onItemTapped(0),
                                child: Image.asset(
                                  "assets/animations/home.png",
                                  height: 30,
                                  width: 30,
                                  color: _selectedIndex == 0
                                      ? const Color(0xFF9F6BFF)
                                      : Colors.white54,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onItemTapped(1),
                                child: Image.asset(
                                  "assets/animations/event.png",
                                  height: 30,
                                  width: 30,
                                  color: _selectedIndex == 1
                                      ? const Color(0xFF9F6BFF)
                                      : Colors.white54,
                                ),
                              ),
                            ),
                            const SizedBox(width: 80),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onItemTapped(2),
                                child: Image.asset(
                                  "assets/animations/ticket.png",
                                  height: 30,
                                  width: 30,
                                  color: _selectedIndex == 2
                                      ? const Color(0xFF9F6BFF)
                                      : Colors.white54,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onItemTapped(3),
                                child: Image.asset(
                                  "assets/animations/person.png",
                                  height: 30,
                                  width: 30,
                                  color: _selectedIndex == 3
                                      ? const Color(0xFF9F6BFF)
                                      : Colors.white54,
                                ),
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

          // ================== FAB ==================
          if (!isKeyboardOpen)
            Positioned(
              bottom: 55,
              left: 0,
              right: 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: _isBottomBarVisible ? Offset.zero : const Offset(0, 2),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: FloatingActionButton(
                      onPressed: () => context.push('/createevent'),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.white,
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
