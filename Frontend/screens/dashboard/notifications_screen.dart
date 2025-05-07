import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/models/trip_offer_model.dart';
import 'package:trackarino/providers/alert_provider.dart';
import 'package:trackarino/widgets/alert_card.dart';
import 'package:trackarino/widgets/report_alert_dialog.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
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
