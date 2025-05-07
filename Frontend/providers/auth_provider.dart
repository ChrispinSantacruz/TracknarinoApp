import 'package:flutter/material.dart';
import 'package:trackarino/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _showProfileOnLogin = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get showProfileOnLogin => _showProfileOnLogin;

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      
      if (userJson != null) {
        _currentUser = User.fromJson(json.decode(userJson));
        _showProfileOnLogin = prefs.getBool('showProfileOnLogin') ?? false;
      }
    } catch (e) {
      print('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password, UserType userType) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulación de autenticación
      await Future.delayed(Duration(seconds: 1));
      
      if (userType == UserType.camionero) {
        _currentUser = User(
          id: '123456',
          name: 'Juan Pérez',
          email: email,
          phone: '+57 300 123 4567',
          since: '2020',
          rating: 4.8,
          userType: UserType.camionero,
          trips: 128,
          kilometers: 24560,
          deliveries: 156,
          vehicle: Vehicle(
            type: 'Camión de Carga',
            plate: 'ABC-123',
            capacity: '10 toneladas',
            imageUrl: 'assets/images/truck_default.png',
            license: 'C1-123456',
          ),
        );
      } else {
        _currentUser = User(
          id: '789012',
          name: 'Transportes Nariño S.A.',
          email: email,
          phone: '+57 315 987 6543',
          since: '2018',
          rating: 4.9,
          userType: UserType.contratista,
          tripsPublished: 245,
          tripsCompleted: 230,
          company: Company(
            name: 'Transportes Nariño S.A.',
            nit: '900.123.456-7',
            address: 'Calle 25 #15-30, Pasto, Nariño',
          ),
        );
      }
      
      _showProfileOnLogin = true;
      
      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(_currentUser!.toJson()));
      await prefs.setBool('showProfileOnLogin', _showProfileOnLogin);
      
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerDriver({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String vehicleType,
    required String plate,
    required String capacity,
    required String license,
    File? vehicleImage,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulación de registro
      await Future.delayed(Duration(seconds: 1));
      
      // En una aplicación real, aquí se enviarían los datos a un servidor
      // y se procesaría la imagen del vehículo
      
      String imageUrl = 'assets/images/truck_default.png';
      if (vehicleImage != null) {
        // En una aplicación real, aquí se subiría la imagen a un servidor
        // y se obtendría la URL
        imageUrl = vehicleImage.path; // Solo para simulación
      }
      
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        since: DateTime.now().year.toString(),
        rating: 5.0, // Rating inicial
        userType: UserType.camionero,
        trips: 0,
        kilometers: 0,
        deliveries: 0,
        vehicle: Vehicle(
          type: vehicleType,
          plate: plate,
          capacity: capacity,
          imageUrl: imageUrl,
          license: license,
        ),
      );
      
      _showProfileOnLogin = true;
      
      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(_currentUser!.toJson()));
      await prefs.setBool('showProfileOnLogin', _showProfileOnLogin);
      
    } catch (e) {
      throw Exception('Error al registrar: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerContractor({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String companyName,
    required String nit,
    required String address,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulación de registro
      await Future.delayed(Duration(seconds: 1));
      
      // En una aplicación real, aquí se enviarían los datos a un servidor
      
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        since: DateTime.now().year.toString(),
        rating: 5.0, // Rating inicial
        userType: UserType.contratista,
        tripsPublished: 0,
        tripsCompleted: 0,
        company: Company(
          name: companyName,
          nit: nit,
          address: address,
        ),
      );
      
      _showProfileOnLogin = true;
      
      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(_currentUser!.toJson()));
      await prefs.setBool('showProfileOnLogin', _showProfileOnLogin);
      
    } catch (e) {
      throw Exception('Error al registrar: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = null;
      
      // Limpiar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('showProfileOnLogin');
      
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setShowProfileOnLogin(bool value) {
    _showProfileOnLogin = value;
    notifyListeners();
    
    // Actualizar en SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('showProfileOnLogin', value);
    });
  }

  Future<void> updateUserRating(String userId, double rating) async {
    try {
      // En una aplicación real, aquí se enviaría la calificación a un servidor
      
      if (_currentUser != null && _currentUser!.id == userId) {
        _currentUser = User(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          phone: _currentUser!.phone,
          since: _currentUser!.since,
          rating: rating,
          userType: _currentUser!.userType,
          trips: _currentUser!.trips,
          kilometers: _currentUser!.kilometers,
          deliveries: _currentUser!.deliveries,
          vehicle: _currentUser!.vehicle,
          tripsPublished: _currentUser!.tripsPublished,
          tripsCompleted: _currentUser!.tripsCompleted,
          company: _currentUser!.company,
        );
        
        // Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(_currentUser!.toJson()));
      }
      
      notifyListeners();
    } catch (e) {
      throw Exception('Error al actualizar calificación: $e');
    }
  }
}
