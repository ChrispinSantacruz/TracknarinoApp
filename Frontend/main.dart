import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/providers/auth_provider.dart';
import 'package:trackarino/providers/trip_provider.dart';
import 'package:trackarino/screens/auth/login_screen.dart';
import 'package:trackarino/screens/dashboard/dashboard_screen.dart';
import 'package:trackarino/utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: MaterialApp(
        title: 'TRACKNARIÑO',
        theme: appTheme,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isLoggedIn 
                ? DashboardScreen() 
                : LoginScreen();
          },
        ),
      ),
    );
  }
}
