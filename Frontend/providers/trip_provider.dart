import 'package:flutter/material.dart';
import 'package:trackarino/models/trip_offer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TripProvider with ChangeNotifier {
  List<TripOffer> _tripOffers = [];
  bool _isLoading = false;

  List<TripOffer> get tripOffers => _tripOffers;
  bool get isLoading => _isLoading;

  TripProvider() {
    loadTripOffers();
  }

  Future<void> loadTripOffers() async {
    _isLoading = true;
    notifyListeners();

    try {
      // En una aplicación real, aquí se cargarían los datos desde una API
      // Por ahora, usamos datos de ejemplo o guardados localmente
      
      final prefs = await SharedPreferences.getInstance();
      final offersJson = prefs.getString('tripOffers');
      
      if (offersJson != null) {
        final List<dynamic> decodedList = json.decode(offersJson);
        _tripOffers = decodedList.map((item) => TripOffer.fromJson(item)).toList();
      } else {
        // Cargar datos de ejemplo si no hay datos guardados
        _tripOffers = [
          TripOffer(
            id: '1',
            origin: 'Pasto',
            destination: 'Ipiales',
            date: '15 Mayo, 2023',
            price: 800000,
            distance: 82,
            cargo: 'Mercancía general',
            weight: '8 toneladas',
            client: 'Transportes Nariño S.A.',
            urgency: UrgencyLevel.normal,
            paymentMethods: ['Transferencia bancaria', 'Nequi', 'Efectivo'],
            description: 'Transporte de mercancía general desde Pasto hasta Ipiales. Se requiere camión con capacidad de 8 toneladas.',
          ),
          TripOffer(
            id: '2',
            origin: 'Tumaco',
            destination: 'Pasto',
            date: '18 Mayo, 2023',
            price: 1200000,
            distance: 300,
            cargo: 'Productos del mar',
            weight: '5 toneladas',
            client: 'Mariscos del Pacífico',
            urgency: UrgencyLevel.alta,
            paymentMethods: ['PSE', 'Nequi'],
            description: 'Transporte urgente de productos del mar refrigerados. Se requiere camión con sistema de refrigeración.',
          ),
          TripOffer(
            id: '3',
            origin: 'Pasto',
            destination: 'Cali',
            date: '20 Mayo, 2023',
            price: 1500000,
            distance: 380,
            cargo: 'Materiales de construcción',
            weight: '10 toneladas',
            client: 'Constructora Andina',
            urgency: UrgencyLevel.normal,
            paymentMethods: ['Transferencia bancaria', 'Efectivo'],
            description: 'Transporte de materiales de construcción. Carga y descarga por cuenta del contratista.',
          ),
          TripOffer(
            id: '4',
            origin: 'Ipiales',
            destination: 'Popayán',
            date: '22 Mayo, 2023',
            price: 1350000,
            distance: 410,
            cargo: 'Productos electrónicos',
            weight: '3 toneladas',
            client: 'Electro Import',
            urgency: UrgencyLevel.baja,
            paymentMethods: ['Transferencia bancaria', 'PSE'],
            description: 'Transporte de productos electrónicos importados. Se requiere manejo cuidadoso de la carga.',
          ),
          TripOffer(
            id: '5',
            origin: 'Pasto',
            destination: 'Popayán',
            date: '25 Mayo, 2023',
            price: 900000,
            distance: 290,
            cargo: 'Textiles',
            weight: '6 toneladas',
            client: 'Textiles del Sur',
            urgency: UrgencyLevel.alta,
            paymentMethods: ['Nequi', 'Daviplata'],
            description: 'Transporte urgente de textiles. Se paga 50% al cargar y 50% al entregar.',
          ),
        ];
        
        // Guardar los datos de ejemplo en SharedPreferences
        await _saveTripOffersToStorage();
      }
    } catch (e) {
      print('Error loading trip offers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveTripOffersToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final offersJson = json.encode(_tripOffers.map((offer) => offer.toJson()).toList());
      await prefs.setString('tripOffers', offersJson);
    } catch (e) {
      print('Error saving trip offers: $e');
    }
  }

  Future<void> createTripOffer(TripOffer tripOffer) async {
    _isLoading = true;
    notifyListeners();

    try {
      // En una aplicación real, aquí se enviaría la oferta a una API
      _tripOffers.add(tripOffer);
      await _saveTripOffersToStorage();
    } catch (e) {
      throw Exception('Error al crear la oferta: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTripOffer(TripOffer updatedOffer) async {
    _isLoading = true;
    notifyListeners();

    try {
      // En una aplicación real, aquí se actualizaría la oferta en una API
      final index = _tripOffers.indexWhere((offer) => offer.id == updatedOffer.id);
      if (index != -1) {
        _tripOffers[index] = updatedOffer;
        await _saveTripOffersToStorage();
      } else {
        throw Exception('Oferta no encontrada');
      }
    } catch (e) {
      throw Exception('Error al actualizar la oferta: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTripOffer(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // En una aplicación real, aquí se eliminaría la oferta en una API
      _tripOffers.removeWhere((offer) => offer.id == id);
      await _saveTripOffersToStorage();
    } catch (e) {
      throw Exception('Error al eliminar la oferta: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
