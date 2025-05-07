import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/models/trip_offer_model.dart';
import 'package:trackarino/providers/alert_provider.dart';
import 'package:trackarino/widgets/alert_card.dart';
import 'package:trackarino/widgets/report_alert_dialog.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Cargar alertas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlertProvider>(context, listen: false).loadAlerts();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showReportAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportAlertDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Tabs para filtrar alertas
          Container(
            color: Colors.white,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.green[700],
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Colors.green[700],
                  tabs: [
                    Tab(text: 'Alertas Activas'),
                    Tab(text: 'Mis Reportes'),
                  ],
                ),
                Divider(height: 1),
              ],
            ),
          ),
          
          // Contenido de las pestañas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveAlertsTab(),
                _buildMyReportsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showReportAlertDialog,
        backgroundColor: Colors.green[600],
        child: Icon(Icons.add_alert),
        tooltip: 'Reportar Alerta',
      ),
    );
  }

  Widget _buildActiveAlertsTab() {
    final alertProvider = Provider.of<AlertProvider>(context);
    final activeAlerts = alertProvider.alerts.where((alert) => alert.isActive).toList();
    
    if (alertProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (activeAlerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green[300],
            ),
            SizedBox(height: 16),
            Text(
              'No hay alertas activas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Las vías están despejadas en este momento',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: activeAlerts.length,
      itemBuilder: (context, index) {
        final alert = activeAlerts[index];
        return AlertCard(
          alert: alert,
          onTap: () {
            // Mostrar detalles de la alerta
            _showAlertDetails(alert);
          },
        );
      },
    );
  }

  Widget _buildMyReportsTab() {
    final alertProvider = Provider.of<AlertProvider>(context);
    final myReports = alertProvider.getMyReports();
    
    if (alertProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (myReports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.report_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              'No has reportado alertas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tus reportes de vías bloqueadas aparecerán aquí',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: myReports.length,
      itemBuilder: (context, index) {
        final alert = myReports[index];
        return AlertCard(
          alert: alert,
          onTap: () {
            _showAlertDetails(alert);
          },
          showActions: true,
          onDelete: () {
            alertProvider.deleteAlert(alert.id);
          },
          onToggleActive: () {
            alertProvider.toggleAlertStatus(alert.id);
          },
        );
      },
    );
  }

  void _showAlertDetails(RoadAlert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlertDetailItem('Ubicación', alert.location, Icons.location_on),
            SizedBox(height: 8),
            _buildAlertDetailItem('Tipo', _getAlertTypeText(alert.type), _getAlertTypeIcon(alert.type)),
            SizedBox(height: 8),
            _buildAlertDetailItem('Fecha', _formatDate(alert.timestamp), Icons.calendar_today),
            SizedBox(height: 8),
            _buildAlertDetailItem('Reportado por', alert.reportedBy, Icons.person),
            SizedBox(height: 16),
            Text(
              'Descripción:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(alert.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  String _getAlertTypeText(RoadAlertType type) {
    switch (type) {
      case RoadAlertType.blockage:
        return 'Bloqueo';
      case RoadAlertType.accident:
        return 'Accidente';
      case RoadAlertType.construction:
        return 'Construcción';
      case RoadAlertType.weather:
        return 'Clima';
      default:
        return 'Otro';
    }
  }

  IconData _getAlertTypeIcon(RoadAlertType type) {
    switch (type) {
      case RoadAlertType.blockage:
        return Icons.block;
      case RoadAlertType.accident:
        return Icons.car_crash;
      case RoadAlertType.construction:
        return Icons.construction;
      case RoadAlertType.weather:
        return Icons.cloud;
      default:
        return Icons.warning;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
