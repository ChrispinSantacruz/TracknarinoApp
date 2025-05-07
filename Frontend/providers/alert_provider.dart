import 'package:flutter/material.dart';
import 'package:trackarino/models/trip_offer_model.dart';
import 'package:trackarino/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AlertProvider with ChangeNotifier {
  List<RoadAlert> _alerts = [];
  bool _isLoading = false;
  final AuthProvider _authProvider;

  AlertProvider(this._authProvider) {
    loadAlerts();
  }

  List<RoadAlert> get alerts => _alerts;
  bool get isLoading => _isLoading;

  Future<void> loadAlerts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // En una aplicación real, aquí se cargarían los datos desde una API
      final prefs = await SharedPreferences.getInstance();
      final alertsJson = prefs.getString('roadAlerts');
      
      if (alertsJson != null) {
        final List<dynamic> decodedList = json.decode(alertsJson);
        _alerts = decodedList.map((item) => RoadAlert.fromJson(item)).toList();
      } else {
        // Cargar datos de ejemplo si no hay datos guardados
        _alerts = [
          RoadAlert(
            id: '1',
            title: 'Bloqueo en vía Pasto-Ipiales',
            description: 'Bloqueo total de la vía por manifestaciones en el km 40.',
            location: 'Km 40 vía Pasto-Ipiales',
            timestamp: DateTime.now().subtract(Duration(hours: 2)),
            type: RoadAlertType.blockage,
            reportedBy: 'Sistema',
          ),
          RoadAlert(
            id: '2',
            title: 'Accidente en vía Pasto-Tumaco',
            description: 'Accidente entre dos vehículos. Tráfico lento.',
            location: 'Km 15 vía Pasto-Tumaco',
            timestamp: DateTime.now().subtract(Duration(hours: 5)),
            type: RoadAlertType.accident,
            reportedBy: 'Sistema',
          ),
          RoadAlert(
            id: '3',
            title: 'Obras en la vía Ipiales-Tulcán',
            description: 'Trabajos de mantenimiento. Paso alternado.',
            location: 'Puente Rumichaca',
            timestamp: DateTime.now().subtract(Duration(days: 1)),
            type: RoadAlertType.construction,
            reportedBy: 'Sistema',
          ),
        ];
        
        // Guardar los datos de ejemplo en SharedPreferences
        await _saveAlertsToStorage();
      }
    } catch (e) {
      print('Error loading alerts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveAlertsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final alertsJson = json.encode(_alerts.map((alert) => alert.toJson()).toList());
      await prefs.setString('roadAlerts', alertsJson);
    } catch (e) {
      print('Error saving alerts: $e');
    }
  }

  Future<void> addAlert(RoadAlert alert) async {
    _isLoading = true;
    notifyListeners();

    try {
      _alerts.add(alert);
      await _saveAlertsToStorage();
    } catch (e) {
      throw Exception('Error al crear la alerta: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAlert(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _alerts.removeWhere((alert) => alert.id == id);
      await _saveAlertsToStorage();
    } catch (e) {
      throw Exception('Error al eliminar la alerta: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleAlertStatus(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final index = _alerts.indexWhere((alert) => alert.id == id);
      if (index != -1) {
        final alert = _alerts[index];
        final updatedAlert = RoadAlert(
          id: alert.id,
          title: alert.title,
          description: alert.description,
          location: alert.location,
          timestamp: alert.timestamp,
          type: alert.type,
          reportedBy: alert.reportedBy,
          isActive: !alert.isActive,
        );
        
        _alerts[index] = updatedAlert;
        await _saveAlertsToStorage();
      }
    } catch (e) {
      throw Exception('Error al actualizar la alerta: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<RoadAlert> getMyReports() {
    final currentUser = _authProvider.currentUser;
    if (currentUser == null) return [];
    
    return _alerts.where((alert) => alert.reportedBy == currentUser.name).toList();
  }

  List<RoadAlert> getAlertsForRoute(String origin, String destination) {
    // En una implementación real, esto filtraría alertas basadas en la ruta
    // Por ahora, simplemente devolvemos todas las alertas activas
    return _alerts.where((alert) => alert.isActive).toList();
  }
}
