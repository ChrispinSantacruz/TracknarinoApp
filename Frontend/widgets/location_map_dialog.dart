import 'package:flutter/material.dart';
import 'dart:async';

class LocationMapDialog extends StatefulWidget {
  final String userId;
  final String userName;

  const LocationMapDialog({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  @override
  _LocationMapDialogState createState() => _LocationMapDialogState();
}

class _LocationMapDialogState extends State<LocationMapDialog> {
  bool _isLoading = true;
  Timer? _locationTimer;
  
  // Ubicación simulada
  double _latitude = 1.2145;
  double _longitude = -77.2854;
  String _locationName = "Vía Pasto-Ipiales, km 45";
  String _lastUpdate = "";

  @override
  void initState() {
    super.initState();
    _loadLocation();
    
    // Simular actualizaciones de ubicación cada 5 segundos
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _updateLocation();
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    // Simular carga de ubicación
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
      _lastUpdate = _getCurrentTime();
    });
  }

  void _updateLocation() {
    // Simular cambio de ubicación
    setState(() {
      // Pequeño cambio aleatorio en la ubicación
      _latitude += (DateTime.now().millisecond % 10 - 5) / 10000;
      _longitude += (DateTime.now().millisecond % 10 - 5) / 10000;
      _lastUpdate = _getCurrentTime();
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ubicación de ${widget.userName}'),
      content: Container(
        width: double.maxFinite,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mapa simulado
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 48,
                            color: Colors.grey[700],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Mapa no disponible en la versión de demostración',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Icon(
                            Icons.location_on,
                            size: 32,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Información de ubicación
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.green[700]),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _locationName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.my_location, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              'Lat: ${_latitude.toStringAsFixed(6)}, Lon: ${_longitude.toStringAsFixed(6)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text(
                              'Última actualización: $_lastUpdate',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
