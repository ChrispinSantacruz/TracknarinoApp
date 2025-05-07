import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/models/user_model.dart';
import 'package:trackarino/providers/auth_provider.dart';
import 'package:trackarino/screens/dashboard/map_screen.dart';
import 'package:trackarino/screens/dashboard/notifications_screen.dart';
import 'package:trackarino/screens/dashboard/profile_screen.dart';
import 'package:trackarino/screens/dashboard/trips_screen.dart';
import 'package:trackarino/widgets/profile_dialog.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;
  late User _user;
  bool _showProfileDialog = false;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<AuthProvider>(context, listen: false).currentUser!;
    _screens = [
      MapScreen(),
      TripsScreen(),
      ProfileScreen(),
      NotificationsScreen(),
    ];
    
    // Mostrar el diálogo de perfil al iniciar sesión
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.showProfileOnLogin) {
        setState(() {
          _showProfileDialog = true;
        });
        authProvider.setShowProfileOnLogin(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isContratista = _user.userType == UserType.contratista;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Row(
          children: [
            Icon(Icons.local_shipping),
            SizedBox(width: 8),
            Text('TRACKNARIÑO'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildNavButton(0, Icons.map, 'Mapa'),
                _buildNavButton(1, Icons.inventory, isContratista ? 'Mis Viajes' : 'Cargas'),
                _buildNavButton(2, Icons.person, 'Perfil'),
                Spacer(),
                _buildNavButton(3, Icons.notifications, 'Alertas'),
              ],
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      
      // Diálogo de perfil al iniciar sesión
      onGenerateRoute: (settings) {
        if (_showProfileDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (context) => ProfileDialog(user: _user),
            ).then((_) {
              setState(() {
                _showProfileDialog = false;
              });
            });
          });
        }
        return null;
      },
    );
  }

  Widget _buildNavButton(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _currentIndex = index;
          if (index == 2) { // Si es el botón de perfil
            _showProfileDialog = true;
          }
        });
      },
      icon: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isSelected ? Colors.green[700] : Colors.transparent,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
