import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocalidadScreen(),
    );
  }
}

class LocalidadScreen extends StatefulWidget {
  @override
  _LocalidadScreenState createState() => _LocalidadScreenState();
}

class _LocalidadScreenState extends State<LocalidadScreen> {
  TextEditingController _locationController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isInputFocused = false;
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isInputFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _navigateToPayIDScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PayIDScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localidad'),
      ),
      body: Container(
        color: Colors.grey[200], // Fondo gris claro
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity, // Ocupa todo el ancho de la pantalla
                  decoration: BoxDecoration(
                    color: Colors.yellow, // Color amarillo
                    borderRadius: BorderRadius.circular(20), // Bordes redondeados
                  ),
                  padding: EdgeInsets.all(16), // Espaciado interno
                  child: Center(
                    child: Text(
                      'Localidad',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                if (!_isInputFocused)
                  Center(
                    child: Lottie.asset('assets/location.json', width: 200, height: 200),
                  ),
                if (!_isInputFocused)
                  SizedBox(height: 16),
                Container(
                  height: 300,
                  color: Colors.green, // Color verde para simular el mapa
                  child: Center(
                    child: Text(
                      'Google Maps aquí',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  focusNode: _focusNode,
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Ubicación',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')), // Solo permite letras y espacios
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una ubicación';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      String location = _locationController.text;
                      print('Ubicación guardada: $location');
                      _navigateToPayIDScreen(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Color amarillo para el botón
                  ),
                  child: Text(
                    'Guardar',
                    style: TextStyle(color: Colors.black), // Color del texto negro
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PayIDScreen extends StatefulWidget {
  @override
  _PayIDScreenState createState() => _PayIDScreenState();
}

class _PayIDScreenState extends State<PayIDScreen> {
  String _selectedOption = 'org';
  TextEditingController _inputController = TextEditingController();

  void _navigateToKmForTravelScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KmForTravelScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PayID'),
      ),
      body: SingleChildScrollView( // Permitir desplazamiento
        child: Container(
          color: Colors.grey[200], // Fondo gris claro
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'PayID',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.5), width: 2), // Contorno negro con alta transparencia
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Lottie.asset('assets/pay.json', width: 200, height: 200),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.yellow, width: 2),
                ),
                child: DropdownButton<String>(
                  value: _selectedOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                  items: <String>['org', 'email', 'phone']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  isExpanded: true,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: _selectedOption,
                  border: OutlineInputBorder(),
                ),
                keyboardType: _selectedOption == 'email'
                    ? TextInputType.emailAddress
                    : _selectedOption == 'phone'
                        ? TextInputType.phone
                        : TextInputType.text,
              ),
              SizedBox(height: 16),
              Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        print('Contenedor $index clickeado');
                      },
                      child: Container(
                        width: 100,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/image$index.png', // Asegúrate de tener estas imágenes en tu carpeta assets
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String input = _inputController.text;
                  print('Input guardado: $input');
                  _navigateToKmForTravelScreen(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Color amarillo para el botón
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(color: Colors.black), // Color del texto negro
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KmForTravelScreen extends StatelessWidget {
  final TextEditingController _kmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Km for travel'),
      ),
      body: SingleChildScrollView( // Permitir desplazamiento
        child: Container(
          color: Colors.grey[200], // Fondo gris claro
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Km for travel',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.5), width: 2), // Contorno negro con alta transparencia
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Lottie.asset('assets/travel.json', width: 200, height: 200),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Remember that the units are in KM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _kmController,
                decoration: InputDecoration(
                  labelText: 'Kilometers',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String km = _kmController.text;
                  print('Kilometers saved: $km');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Color amarillo para el botón
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(color: Colors.black), // Color del texto negro
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
