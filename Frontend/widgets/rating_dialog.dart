import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/providers/auth_provider.dart';

class RatingDialog extends StatefulWidget {
  final String userId;
  final String userName;
  final double currentRating;

  const RatingDialog({
    Key? key,
    required this.userId,
    required this.userName,
    required this.currentRating,
  }) : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 5.0;
  String _comment = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.currentRating;
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona una calificación')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .updateUserRating(widget.userId, _rating);
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calificación enviada con éxito'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar calificación: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Calificar a ${widget.userName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Califica el servicio del transportista',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            
            // Estrellas de calificación
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 8),
            
            Text(
              _getRatingText(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getRatingColor(),
              ),
            ),
            SizedBox(height: 16),
            
            // Campo de comentario
            TextField(
              decoration: InputDecoration(
                labelText: 'Comentario (opcional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _comment = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitRating,
          child: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Enviar'),
          style: ElevatedButton.styleFrom(
            primary: Colors.green[600],
          ),
        ),
      ],
    );
  }

  String _getRatingText() {
    if (_rating >= 5) return 'Excelente';
    if (_rating >= 4) return 'Muy Bueno';
    if (_rating >= 3) return 'Bueno';
    if (_rating >= 2) return 'Regular';
    return 'Malo';
  }

  Color _getRatingColor() {
    if (_rating >= 5) return Colors.green;
    if (_rating >= 4) return Colors.green[700]!;
    if (_rating >= 3) return Colors.orange;
    if (_rating >= 2) return Colors.orange[700]!;
    return Colors.red;
  }
}
