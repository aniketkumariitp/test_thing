import 'package:go_router/go_router.dart';
import 'package:hoodhappen_creator/features/authentication/screens/login_screen.dart';
import 'package:hoodhappen_creator/features/authentication/screens/register_screen.dart';
import 'package:hoodhappen_creator/features/create_event/screens/create_event_screen.dart';
import 'package:hoodhappen_creator/features/deatils_of_event/screen/details_event_screen.dart';
import 'package:hoodhappen_creator/features/get_event/model/get_event_model.dart';
import 'package:hoodhappen_creator/features/home/screens/home_screen.dart';
import 'package:hoodhappen_creator/features/joined_events/model/joined_event_model';
import 'package:hoodhappen_creator/features/joined_events/screen/joined_event_details_screen.dart';
import 'package:hoodhappen_creator/features/joined_events/screen/ticket_details_screen.dart';
import 'package:hoodhappen_creator/features/my_events/model/my_event_model.dart';
import 'package:hoodhappen_creator/features/my_events/screen/my_event_details_screen.dart';
import 'package:hoodhappen_creator/features/splashs/screens/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/createevent',
      builder: (context, state) => const CreateEventScreen(),
    ),
    GoRoute(
      path: '/detail-event',
      builder: (context, state) {
        final event = state.extra as Data;
        return const DetailsEventScreen(); // event is read inside
      },
    ),
    GoRoute(
      path: '/my-detail-event',
      builder: (context, state) {
        final event = state.extra as CreatedEvent;
        return const MyEventDetailsScreen(); // event is read inside
      },
    ),
    GoRoute(
      path: '/joined-detail-event',
      builder: (context, state) {
        final event = state.extra as Eventdata;
        return const JoinedEventDetailsScreen(); // event is read inside
      },
    ),

    GoRoute(
      path: '/my-ticket',
      builder: (context, state) {
        final event = state.extra as String;
        return const TicketDetailsScreen(); // event is read inside
      },
    ),
  ],
);
