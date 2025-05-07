import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:trackarino/models/user_model.dart';
import 'package:trackarino/providers/auth_provider.dart';
import 'package:trackarino/screens/dashboard/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Campos para camionero
  final _plateController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _licenseController = TextEditingController();
  
  // Campos para contratista
  final _companyNameController = TextEditingController();
  final _nitController = TextEditingController();
  final _addressController = TextEditingController();
  
  UserType _userType = UserType.camionero;
  bool _isLoading = false;
  File? _vehicleImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _plateController.dispose();
    _vehicleTypeController.dispose();
    _capacityController.dispose();
    _licenseController.dispose();
    _companyNameController.dispose();
    _nitController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _vehicleImage = File(image.path);
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _vehicleImage = File(photo.path);
      });
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Verificar que las contraseñas coincidan
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        if (_userType == UserType.camionero) {
          // Registro de camionero
          await authProvider.registerDriver(
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            password: _passwordController.text,
            vehicleType: _vehicleTypeController.text,
            plate: _plateController.text,
            capacity: _capacityController.text,
            license: _licenseController.text,
            vehicleImage: _vehicleImage,
          );
        } else {
          // Registro de contratista
          await authProvider.registerContractor(
            name: _companyNameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            password: _passwordController.text,
            companyName: _companyNameController.text,
            nit: _nitController.text,
            address: _addressController.text,
          );
        }
        
        // Navegar al dashboard después del registro exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrarse: ${e.toString()}')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tipo de usuario
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de Usuario',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<UserType>(
                                title: Row(
                                  children: [
                                    Icon(Icons.local_shipping, size: 16),
                                    SizedBox(width: 4),
                                    Text('Camionero', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                value: UserType.camionero,
                                groupValue: _userType,
                                onChanged: (value) {
                                  setState(() {
                                    _userType = value!;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<UserType>(
                                title: Row(
                                  children: [
                                    Icon(Icons.business, size: 16),
                                    SizedBox(width: 4),
                                    Text('Contratista', style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                value: UserType.contratista,
                                groupValue: _userType,
                                onChanged: (value) {
                                  setState(() {
                                    _userType = value!;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                
                // Información básica
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información Básica',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Nombre o Empresa
                        if (_userType == UserType.camionero) ...[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre Completo',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu nombre';
                              }
                              return null;
                            },
                          ),
                        ] else ...[
                          TextFormField(
                            controller: _companyNameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre de la Empresa',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa el nombre de la empresa';
                              }
                              return null;
                            },
                          ),
                        ],
                        SizedBox(height: 16),
                        
                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu correo';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Por favor ingresa un correo válido';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Teléfono
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu teléfono';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Contraseña
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        
                        // Confirmar Contraseña
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu contraseña';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                
                // Información específica según el tipo de usuario
                if (_userType == UserType.camionero) ...[
                  // Información del vehículo
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información del Vehículo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Tipo de vehículo
                          TextFormField(
                            controller: _vehicleTypeController,
                            decoration: InputDecoration(
                              labelText: 'Tipo de Vehículo',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.local_shipping),
                              hintText: 'Ej. Camión de Carga, Tractomula, etc.',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa el tipo de vehículo';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Placa
                          TextFormField(
                            controller: _plateController,
                            decoration: InputDecoration(
                              labelText: 'Placa',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.credit_card),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa la placa';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Capacidad
                          TextFormField(
                            controller: _capacityController,
                            decoration: InputDecoration(
                              labelText: 'Capacidad',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.scale),
                              hintText: 'Ej. 10 toneladas',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa la capacidad';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Licencia de conducción
                          TextFormField(
                            controller: _licenseController,
                            decoration: InputDecoration(
                              labelText: 'Licencia de Conducción',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.card_membership),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu licencia';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Foto del vehículo
                          Text(
                            'Foto del Vehículo (Opcional)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          
                          if (_vehicleImage != null) ...[
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _vehicleImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                          
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _pickImage,
                                  icon: Icon(Icons.photo_library),
                                  label: Text('Galería'),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _takePicture,
                                  icon: Icon(Icons.camera_alt),
                                  label: Text('Cámara'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Información de la empresa
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información de la Empresa',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // NIT
                          TextFormField(
                            controller: _nitController,
                            decoration: InputDecoration(
                              labelText: 'NIT',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.numbers),
                              hintText: 'Ej. 900.123.456-7',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa el NIT';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          
                          // Dirección
                          TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: 'Dirección',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa la dirección';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 24),
                
                // Botón de registro
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Registrarse'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[600],
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                SizedBox(height: 16),
                
                // Volver a iniciar sesión
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes una cuenta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(color: Colors.green[600]),
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
}
