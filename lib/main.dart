import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MiAppIngenieria());
}

class MiAppIngenieria extends StatelessWidget {
  const MiAppIngenieria({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herramientas de Ingeniería',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos DefaultTabController para crear las dos pestañas superiores
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Herramientas de Ingeniería de Procesos'),
          backgroundColor: Colors.blue[900],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            tabs: [
              Tab(icon: Icon(Icons.speed), text: 'Velocidad en Tuberías'),
              Tab(icon: Icon(Icons.heat_pump), text: 'Volumen Intercambiador'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ModuloVelocidadTuberias(),
            ModuloVolumenIntercambiador(),
          ],
        ),
      ),
    );
  }
}

// ================= MODULE 1: VELOCIDAD EN TUBERÍAS =================
class ModuloVelocidadTuberias extends StatefulWidget {
  const ModuloVelocidadTuberias({super.key});

  @override
  State<ModuloVelocidadTuberias> createState() => _ModuloVelocidadTuberiasState();
}

class _ModuloVelocidadTuberiasState extends State<ModuloVelocidadTuberias> {
  final TextEditingController _flujoController = TextEditingController();
  final TextEditingController _diametroController = TextEditingController();
  String resultado = "Ingresa los datos para calcular la velocidad";

  void _calcularVelocidad() {
    double? gpm = double.tryParse(_flujoController.text);
    double? diametroIn = double.tryParse(_diametroController.text);

    if (gpm == null || diametroIn == null || diametroIn <= 0) {
      setState(() {
        resultado = "Por favor, ingresa valores numéricos válidos.";
      });
      return;
    }

    // Conversión de GPM a ft³/s (1 GPM = 0.002228002 ft³/s)
    double caudalFt3s = gpm * 0.002228002;
    
    // Diámetro y radio en pies
    double diametroFt = diametroIn / 12.0;
    double radioFt = diametroFt / 2.0;

    // Área transversal con A = pi * r²
    double areaFt2 = pi * pow(radioFt, 2);

    // Velocidad V = Q / A
    double velocidadFtS = caudalFt3s / areaFt2;

    setState(() {
      resultado = "Velocidad calculada: ${velocidadFtS.toStringAsFixed(2)} ft/s";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Estimación de Velocidad de Agua en Tubería',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _flujoController,
            decoration: const InputDecoration(
              labelText: 'Flujo (GPM)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.water_drop),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _diametroController,
            decoration: const InputDecoration(
              labelText: 'Diámetro interno (pulgadas)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.circle_outlined),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calcularVelocidad,
            child: const Text('Calcular Velocidad'),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
            ),
            child: Text(
              resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MODULE 2: VOLUMEN DE INTERCAMBIADOR =================
class ModuloVolumenIntercambiador extends StatefulWidget {
  const ModuloVolumenIntercambiador({super.key});

  @override
  State<ModuloVolumenIntercambiador> createState() => _ModuloVolumenIntercambiadorState();
}

class _ModuloVolumenIntercambiadorState extends State<ModuloVolumenIntercambiador> {
  final TextEditingController _numTubosController = TextEditingController();
  final TextEditingController _diamTubosController = TextEditingController();
  final TextEditingController _longTubosController = TextEditingController();
  final TextEditingController _diamCarcazaController = TextEditingController();

  String resultadoVolumen = "Ingresa los datos del equipo";

  void _calcularVolumenes() {
    double? numTubos = double.tryParse(_numTubosController.text);
    double? diamTubosIn = double.tryParse(_diamTubosController.text);
    double? longitudFt = double.tryParse(_longTubosController.text);
    double? diamCarcazaIn = double.tryParse(_diamCarcazaController.text);

    if (numTubos == null || diamTubosIn == null || longitudFt == null || diamCarcazaIn == null) {
      setState(() {
        resultadoVolumen = "Por favor, completa todos los campos correctamente.";
      });
      return;
    }

    // 1. Volumen del Lado Tubos:
    // Radio del tubo en pies = (diámetro en pulgadas / 12) / 2
    double radioTuboFt = (diamTubosIn / 12.0) / 2.0;
    double areaUnTubo = pi * pow(radioTuboFt, 2);
    double volumenUnTuboFt3 = areaUnTubo * longitudFt;
    double volumenTotalTubosFt3 = volumenUnTuboFt3 * numTubos;
    double volumenTotalTubosGal = volumenTotalTubosFt3 * 7.48052; // Conversión a galones

    // 2. Volumen del Lado Carcaza (Shell):
    // Volumen total del cilindro de la carcasa menos el volumen metálico/ocupado externo de los tubos
    double radioCarcazaFt = (diamCarcazaIn / 12.0) / 2.0;
    double areaCarcazaFt2 = pi * pow(radioCarcazaFt, 2);
    double volumenBrutoCarcazaFt3 = areaCarcazaFt2 * longitudFt;
    
    // Estimación del espacio libre en carcasa (Volumen bruto - volumen exterior ocupado por los tubos)
    // Asumimos el volumen exterior de los tubos aproximado al mismo radio interno para simplificar inventario neto de líquido
    double volumenNetoCarcazaFt3 = volumenBrutoCarcazaFt3 - volumenTotalTubosFt3;
    if (volumenNetoCarcazaFt3 < 0) volumenNetoCarcazaFt3 = 0;
    double volumenNetoCarcazaGal = volumenNetoCarcazaFt3 * 7.48052;

    setState(() {
      resultadoVolumen = 
          "Lado Tubos:\n"
          "• ${volumenTotalTubosFt3.toStringAsFixed(2)} ft³ (${volumenTotalTubosGal.toStringAsFixed(1)} Gal)\n\n"
          "Lado Carcaza (Efectivo):\n"
          "• ${volumenNetoCarcazaFt3.toStringAsFixed(2)} ft³ (${volumenNetoCarcazaGal.toStringAsFixed(1)} Gal)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cálculo de Inventario / Volúmenes en Intercambiador',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _numTubosController,
            decoration: const InputDecoration(
              labelText: 'Número de tubos',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.format_list_numbered),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _diamTubosController,
            decoration: const InputDecoration(
              labelText: 'Diámetro interno del tubo (pulgadas)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.straighten),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _longTubosController,
            decoration: const InputDecoration(
              labelText: 'Longitud de los tubos (pies)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.swap_horiz),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _diamCarcazaController,
            decoration: const InputDecoration(
              labelText: 'Diámetro interno de la carcaza (pulgadas)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.radio_button_checked),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _calcularVolumenes,
            child: const Text('Calcular Volúmenes'),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
            ),
            child: Text(
              resultadoVolumen,
              style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}