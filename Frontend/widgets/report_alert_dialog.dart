import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/models/trip_offer_model.dart';
import 'package:trackarino/providers/alert_provider.dart';
import 'package:trackarino/providers/auth_provider.dart';

class ReportAlertDialog extends StatefulWidget {
  @override
  _ReportAlertDialogState createState() => _ReportAlertDialogState();
}

class _ReportAlertDialogState extends State<ReportAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  RoadAlertType _selectedType = RoadAlertType.blockage;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final alertProvider = Provider.of<AlertProvider>(context, listen: false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        if (authProvider.currentUser == null) {
          throw Exception('Usuario no autenticado');
        }

        final newAlert = RoadAlert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          timestamp: DateTime.now(),
          type: _selectedType,
          reportedBy: authProvider.currentUser!.name,
          isActive: true,
        );

        await alertProvider.addAlert(newAlert);
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alerta reportada con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reportar Alerta en la Vía'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la ubicación';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              Text(
                'Tipo de Alerta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              
              _buildAlertTypeSelector(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitReport,
          child: _isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Reportar'),
          style: ElevatedButton.styleFrom(
            primary: Colors.green[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertTypeSelector() {
    return Column(
      children: [
        RadioListTile<RoadAlertType>(
          title: Text('Bloqueo'),
          value: RoadAlertType.blockage,
          groupValue: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<RoadAlertType>(
          title: Text('Accidente'),
          value: RoadAlertType.accident,
          groupValue: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<RoadAlertType>(
          title: Text('Construcción/Mantenimiento'),
          value: RoadAlertType.construction,
          groupValue: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<RoadAlertType>(
          title: Text('Clima'),
          value: RoadAlertType.weather,
          groupValue: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<RoadAlertType>(
          title: Text('Otro'),
          value: RoadAlertType.other,
          groupValue: _selectedType,
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
