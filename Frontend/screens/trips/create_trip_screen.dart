import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackarino/models/trip_offer_model.dart';
import 'package:trackarino/providers/trip_provider.dart';

class CreateTripScreen extends StatefulWidget {
  final TripOffer? tripToEdit;

  const CreateTripScreen({Key? key, this.tripToEdit}) : super(key: key);

  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _dateController = TextEditingController();
  final _priceController = TextEditingController();
  final _cargoController = TextEditingController();
  final _weightController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  UrgencyLevel _urgency = UrgencyLevel.normal;
  List<String> _selectedPaymentMethods = ['Transferencia bancaria'];
  String _preferredPaymentMethod = 'Transferencia bancaria';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Transferencia bancaria', 'icon': Icons.account_balance, 'description': 'Pago mediante transferencia bancaria directa'},
    {'name': 'Nequi', 'icon': Icons.smartphone, 'description': 'Pago mediante la aplicación Nequi'},
    {'name': 'PSE', 'icon': Icons.credit_card, 'description': 'Pago Seguro Electrónico (PSE)'},
    {'name': 'Efectivo', 'icon': Icons.money, 'description': 'Pago en efectivo al momento de la entrega'},
    {'name': 'Daviplata', 'icon': Icons.smartphone, 'description': 'Pago mediante la aplicación Daviplata'},
  ];

  @override
  void initState() {
    super.initState();
    
    // Si estamos editando un viaje existente, llenar el formulario
    if (widget.tripToEdit != null) {
      _originController.text = widget.tripToEdit!.origin;
      _destinationController.text = widget.tripToEdit!.destination;
      _dateController.text = widget.tripToEdit!.date;
      _priceController.text = widget.tripToEdit!.price.toString();
      _cargoController.text = widget.tripToEdit!.cargo;
      _weightController.text = widget.tripToEdit!.weight;
      _descriptionController.text = widget.tripToEdit!.description;
      _urgency = widget.tripToEdit!.urgency;
      _selectedPaymentMethods = List.from(widget.tripToEdit!.paymentMethods);
      _preferredPaymentMethod = widget.tripToEdit!.preferredPaymentMethod ?? _selectedPaymentMethods.first;
    }
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    _cargoController.dispose();
    _weightController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _togglePaymentMethod(String method) {
    setState(() {
      if (_selectedPaymentMethods.contains(method)) {
        if (_selectedPaymentMethods.length > 1) {
          _selectedPaymentMethods.remove(method);
          if (_preferredPaymentMethod == method) {
            _preferredPaymentMethod = _selectedPaymentMethods.first;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Debe seleccionar al menos un método de pago')),
          );
        }
      } else {
        _selectedPaymentMethods.add(method);
      }
    });
  }

  void _saveTrip() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPaymentMethods.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selecciona al menos un método de pago')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final tripProvider = Provider.of<TripProvider>(context, listen: false);
        
        final newTrip = TripOffer(
          id: widget.tripToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          origin: _originController.text,
          destination: _destinationController.text,
          date: _dateController.text,
          price: double.parse(_priceController.text),
          distance: widget.tripToEdit?.distance ?? _calculateDistance(_originController.text, _destinationController.text),
          cargo: _cargoController.text,
          weight: _weightController.text,
          client: 'Mi Empresa', // Esto vendría del usuario actual
          urgency: _urgency,
          paymentMethods: _selectedPaymentMethods,
          preferredPaymentMethod: _preferredPaymentMethod,
          description: _descriptionController.text,
          status: widget.tripToEdit?.status ?? TripStatus.pending,
        );

        if (widget.tripToEdit != null) {
          await tripProvider.updateTripOffer(newTrip);
        } else {
          await tripProvider.createTripOffer(newTrip);
        }

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.tripToEdit != null
                ? 'Viaje actualizado con éxito'
                : 'Viaje creado con éxito'),
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

  // Función simulada para calcular distancia
  int _calculateDistance(String origin, String destination) {
    // En una implementación real, esto usaría una API de mapas
    final Map<String, Map<String, int>> distances = {
      'Pasto': {
        'Ipiales': 82,
        'Tumaco': 300,
        'Cali': 380,
        'Popayán': 290,
      },
      'Ipiales': {
        'Pasto': 82,
        'Popayán': 410,
      },
      'Tumaco': {
        'Pasto': 300,
      }
    };

    return distances[origin]?[destination] ?? 200; // Valor por defecto
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripToEdit != null ? 'Editar Viaje' : 'Crear Nuevo Viaje'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Origen y Destino
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _originController,
                        decoration: InputDecoration(
                          labelText: 'Origen',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el origen';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                          labelText: 'Destino',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el destino';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Fecha y Precio
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de Carga',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa la fecha';
                          }
                          return null;
                        },
                        onTap: () async {
                          // Aquí se podría mostrar un selector de fecha
                          FocusScope.of(context).requestFocus(FocusNode());
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              _dateController.text = "${picked.day} ${_getMonthName(picked.month)}, ${picked.year}";
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Precio (COP)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el precio';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Ingresa un número válido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Tipo de Carga y Peso
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cargoController,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Carga',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.inventory),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el tipo de carga';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: 'Peso',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.scale),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el peso';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Descripción
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
                      return 'Ingresa una descripción';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                
                // Urgencia
                Text(
                  'Urgencia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                RadioListTile<UrgencyLevel>(
                  title: Text('Alta', style: TextStyle(color: Colors.red)),
                  subtitle: Text('Entrega urgente, prioridad máxima'),
                  value: UrgencyLevel.alta,
                  groupValue: _urgency,
                  onChanged: (value) {
                    setState(() {
                      _urgency = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<UrgencyLevel>(
                  title: Text('Normal'),
                  subtitle: Text('Entrega en tiempo regular'),
                  value: UrgencyLevel.normal,
                  groupValue: _urgency,
                  onChanged: (value) {
                    setState(() {
                      _urgency = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<UrgencyLevel>(
                  title: Text('Baja', style: TextStyle(color: Colors.green)),
                  subtitle: Text('Entrega flexible, sin prisa'),
                  value: UrgencyLevel.baja,
                  groupValue: _urgency,
                  onChanged: (value) {
                    setState(() {
                      _urgency = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                SizedBox(height: 24),
                
                // Métodos de Pago
                Text(
                  'Métodos de Pago Aceptados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                
                // Lista de métodos de pago con checkbox
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = _paymentMethods[index];
                    final isSelected = _selectedPaymentMethods.contains(method['name']);
                    
                    return CheckboxListTile(
                      title: Row(
                        children: [
                          Icon(method['icon'], size: 20),
                          SizedBox(width: 8),
                          Text(method['name']),
                        ],
                      ),
                      subtitle: Text(method['description'], style: TextStyle(fontSize: 12)),
                      value: isSelected,
                      onChanged: (selected) {
                        _togglePaymentMethod(method['name']);
                      },
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
                
                SizedBox(height: 16),
                
                // Método de pago preferido
                if (_selectedPaymentMethods.length > 1) ...[
                  Text(
                    'Método de Pago Preferido',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Dropdown para seleccionar el método preferido
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payments),
                    ),
                    value: _preferredPaymentMethod,
                    items: _selectedPaymentMethods.map((method) {
                      final methodData = _paymentMethods.firstWhere(
                        (m) => m['name'] == method,
                        orElse: () => {'name': method, 'icon': Icons.payment},
                      );
                      
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Row(
                          children: [
                            Icon(methodData['icon'], size: 20),
                            SizedBox(width: 8),
                            Text(method),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _preferredPaymentMethod = value!;
                      });
                    },
                  ),
                  
                  SizedBox(height: 16),
                ],
                
                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveTrip,
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(widget.tripToEdit != null ? 'Actualizar' : 'Publicar'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
}
