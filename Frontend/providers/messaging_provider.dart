import 'package:flutter/material.dart';
import 'package:trackarino/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MessagingProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = false;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  MessagingProvider() {
    loadAllMessages();
  }

  Future<void> loadAllMessages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString('messages');
      
      if (messagesJson != null) {
        final List<dynamic> decodedList = json.decode(messagesJson);
        _messages = decodedList.map((item) => Message.fromJson(item)).toList();
      } else {
        // Cargar mensajes de ejemplo si no hay datos guardados
        _messages = [];
        
        // Guardar los mensajes en SharedPreferences
        await _saveMessagesToStorage();
      }
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String partnerId, String tripId) async {
    // Esta función podría filtrar mensajes específicos para un chat
    // En este caso, simplemente cargamos todos los mensajes
    await loadAllMessages();
  }

  Future<void> _saveMessagesToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = json.encode(_messages.map((message) => message.toJson()).toList());
      await prefs.setString('messages', messagesJson);
    } catch (e) {
      print('Error saving messages: $e');
    }
  }

  Future<void> sendMessage(Message message) async {
    _isLoading = true;
    notifyListeners();

    try {
      // En una aplicación real, aquí se enviaría el mensaje a un servidor
      _messages.add(message);
      await _saveMessagesToStorage();
    } catch (e) {
      throw Exception('Error al enviar mensaje: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      final index = _messages.indexWhere((message) => message.id == messageId);
      if (index != -1) {
        _messages[index] = _messages[index].copyWith(isRead: true);
        await _saveMessagesToStorage();
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error al marcar mensaje como leído: $e');
    }
  }

  List<Message> getMessagesForChat(String partnerId, String tripId) {
    return _messages.where((message) => 
      (message.senderId == partnerId || message.receiverId == partnerId) &&
      message.tripId == tripId
    ).toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  List<String> getUniqueChatPartnerIds(String userId) {
    final Set<String> partnerIds = {};
    
    for (final message in _messages) {
      if (message.senderId == userId) {
        partnerIds.add(message.receiverId);
      } else if (message.receiverId == userId) {
        partnerIds.add(message.senderId);
      }
    }
    
    return partnerIds.toList();
  }

  int getUnreadMessageCount(String userId) {
    return _messages.where((message) => 
      message.receiverId == userId && !message.isRead
    ).length;
  }
}
