import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const SamsungRemote());

class SamsungRemote extends StatelessWidget {
  const SamsungRemote({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF1A1A1A)),
      home: const RemoteHomePage(),
    );
  }
}

class RemoteHomePage extends StatelessWidget {
  const RemoteHomePage({super.key});
  final String serverUrl = "http://192.168.1.6:5000";

  Future<void> send(String path) async {
    try {
      await http.get(Uri.parse('$serverUrl$path')).timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // BARRA SUPERIOR: POWER Y SOURCE
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleBtn(Icons.power_settings_new, Colors.red, () => send('/tv/power')),
                  const Text("SAMSUNG", style: TextStyle(letterSpacing: 5, fontWeight: FontWeight.bold)),
                  _circleBtn(Icons.input, Colors.grey[800]!, () => send('/tv/source')), // PARA HDMI
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // TECLADO NUMÉRICO (Sutil)
                    _buildNumericPad(),
                    
                    const SizedBox(height: 20),

                    // VOLUMEN Y CANALES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _verticalControl("VOL", Icons.add, Icons.remove, 
                          () => send('/tv/volume/up'), () => send('/tv/volume/down')),
                        _circleBtn(Icons.volume_off, Colors.grey[900]!, () => send('/tv/mute')),
                        _verticalControl("CH", Icons.keyboard_arrow_up, Icons.keyboard_arrow_down, 
                          () => send('/tv/channel/up'), () => send('/tv/channel/down')),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // JOYSTICK CENTRAL
                    _buildJoystick(),

                    const SizedBox(height: 30),

                    // ACCESOS RÁPIDOS (NETFLIX / YOUTUBE)
                    _buildAppRow(),

                    const SizedBox(height: 20),

                    // BOTONES DE COLORES (PRO)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _colorDot(Colors.red), _colorDot(Colors.green),
                        _colorDot(Colors.yellow), _colorDot(Colors.blue),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS DE APOYO
  Widget _circleBtn(IconData icon, Color color, VoidCallback press) {
    return IconButton(
      onPressed: press,
      icon: Icon(icon, color: color, size: 30),
      style: IconButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.all(15)),
    );
  }

  Widget _verticalControl(String label, IconData up, IconData down, VoidCallback onUp, VoidCallback onDown) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          IconButton(icon: Icon(up), onPressed: onUp),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(label)),
          IconButton(icon: Icon(down), onPressed: onDown),
        ],
      ),
    );
  }

  Widget _buildJoystick() {
    return Column(
      children: [
        IconButton(icon: const Icon(Icons.arrow_drop_up, size: 50), onPressed: () => send('/tv/move/up')),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: const Icon(Icons.arrow_left, size: 50), onPressed: () => send('/tv/move/left')),
            GestureDetector(
              onTap: () => send('/tv/move/enter'),
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(border: Border.all(color: Colors.white24), shape: BoxShape.circle),
                child: const Center(child: Text("OK")),
              ),
            ),
            IconButton(icon: const Icon(Icons.arrow_right, size: 50), onPressed: () => send('/tv/move/right')),
          ],
        ),
        IconButton(icon: const Icon(Icons.arrow_drop_down, size: 50), onPressed: () => send('/tv/move/down')),
      ],
    );
  }

  Widget _buildNumericPad() {
    return Wrap(
      spacing: 15, runSpacing: 10,
      children: List.generate(10, (index) => TextButton(
        onPressed: () => send('/tv/number/$index'),
        child: Text("$index", style: const TextStyle(fontSize: 18, color: Colors.white60)),
      )),
    );
  }

  Widget _buildAppRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _appBtn("NETFLIX", Colors.red[900]!, () => send('/tv/app/netflix')),
        _appBtn("YouTube", Colors.white, () => send('/tv/app/youtube'), isDark: false),
      ],
    );
  }

  Widget _appBtn(String txt, Color col, VoidCallback press, {bool isDark = true}) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(backgroundColor: col, foregroundColor: isDark ? Colors.white : Colors.black),
      child: Text(txt, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _colorDot(Color color) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    width: 15, height: 15,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}