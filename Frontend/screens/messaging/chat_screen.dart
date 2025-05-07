import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/models/message_model.dart';
import 'package:trackarino/models/user_model.dart';
import 'package:trackarino/providers/messaging_provider.dart';
import 'package:trackarino/providers/auth_provider.dart';
import 'package:trackarino/widgets/location_map_dialog.dart';
import 'package:trackarino/widgets/rating_dialog.dart';

class ChatScreen extends StatefulWidget {
  final User chatPartner;
  final String tripId;

  const ChatScreen({
    Key? key,
    required this.chatPartner,
    required this.tripId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<MessagingProvider>(context, listen: false)
          .loadMessages(widget.chatPartner.id, widget.tripId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar mensajes: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      
      // Scroll al final de la lista de mensajes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final currentUser = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (currentUser == null) return;

    try {
      await Provider.of<MessagingProvider>(context, listen: false).sendMessage(
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: currentUser.id,
          receiverId: widget.chatPartner.id,
          tripId: widget.tripId,
          text: text,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );

      _messageController.clear();
      
      // Scroll al final de la lista de mensajes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar mensaje: ${e.toString()}')),
      );
    }
  }

  void _showLocationMap() {
    showDialog(
      context: context,
      builder: (context) => LocationMapDialog(
        userId: widget.chatPartner.id,
        userName: widget.chatPartner.name,
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => RatingDialog(
        userId: widget.chatPartner.id,
        userName: widget.chatPartner.name,
        currentRating: widget.chatPartner.rating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).currentUser;
    final messagingProvider = Provider.of<MessagingProvider>(context);
    final messages = messagingProvider.getMessagesForChat(widget.chatPartner.id, widget.tripId);
    final isContratista = currentUser?.userType == UserType.contratista;
    final isCamionero = widget.chatPartner.userType == UserType.camionero;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(
                widget.chatPartner.userType == UserType.camionero
                    ? Icons.local_shipping
                    : Icons.business,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatPartner.name,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.chatPartner.userType == UserType.camionero
                        ? 'Camionero'
                        : 'Contratista',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        actions: [
          // Solo mostrar botones de ubicación y calificación si el contratista está chateando con un camionero
          if (isContratista && isCamionero) ...[
            IconButton(
              icon: Icon(Icons.location_on),
              tooltip: 'Ver ubicación',
              onPressed: _showLocationMap,
            ),
            IconButton(
              icon: Icon(Icons.star),
              tooltip: 'Calificar',
              onPressed: _showRatingDialog,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(
                        child: Text(
                          'No hay mensajes. ¡Envía el primero!',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUser?.id;
                          
                          return _buildMessageBubble(message, isMe);
                        },
                      ),
          ),
          
          // Separador
          Divider(height: 1),
          
          // Campo de entrada de mensaje
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Campo de texto
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                
                // Botón de enviar
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green[600]),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isMe ? 64 : 0,
          right: isMe ? 0 : 64,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
