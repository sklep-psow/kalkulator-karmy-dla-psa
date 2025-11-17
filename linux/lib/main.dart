import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const KalkulatorKarmy());
}

class KalkulatorKarmy extends StatelessWidget {
  const KalkulatorKarmy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Karmy dla Psa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Kontrolery formularza
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _activityHoursController = TextEditingController();
  final TextEditingController _emController = TextEditingController(text: '385');
  
  // Wybory użytkownika
  String _selectedLifeStage = 'adult';
  String _selectedBreed = 'other';
  String _selectedActivity = 'normal';
  String _selectedBodyCondition = 'optimal';
  bool _isNeutered = false;
  
  // Wynik
  double? _dailyAmount;
  bool _showResult = false;

  @override
  void dispose() {
    _weightController.dispose();
    _activityHoursController.dispose();
    _emController.dispose();
    super.dispose();
  }

  double _calculateBEE(double weight) {
    if (weight < 9) {
      return (130 * pow(weight, 0.75)).toDouble();
    } else {
      return (156 * pow(weight, 0.667)).toDouble();
    }
  }

  double _getBreedCoefficient(String breed) {
    switch (breed) {
      case 'nordic': return 0.8;
      case 'beagle': return 0.9;
      case 'greyhound': return 1.2;
      case 'other': return 1.0;
      case 'mixed': return 1.0;
      default: return 1.0;
    }
  }

  double _getActivityCoefficient(String activity) {
    switch (activity) {
      case 'convalescence': return 0.7;
      case 'very_calm': return 0.8;
      case 'calm': return 0.9;
      case 'normal': return 1.0;
      case 'active': return 1.1;
      case 'hyperactive': return 1.2;
      default: return 1.0;
    }
  }

  double _getLifeStageCoefficient(String stage) {
    switch (stage) {
      case 'puppy_2_3': return 2.0;
      case 'puppy_4_6': return 1.5;
      case 'puppy_6_12': return 1.2;
      case 'adult': return 1.0;
      case 'senior': return 1.0;
      default: return 1.0;
    }
  }

  double _getBodyConditionCoefficient(String condition) {
    switch (condition) {
      case 'very_thin': return 1.2;
      case 'underweight': return 1.1;
      case 'optimal': return 1.0;
      case 'overweight': return 0.9;
      case 'obese': return 0.8;
      default: return 1.0;
    }
  }

  void _calculateDailyAmount() {
    if (!_formKey.currentState!.validate()) return;

    double weight = double.parse(_weightController.text);
    double em = double.parse(_emController.text);
    
    // Oblicz BEE
    double bee = _calculateBEE(weight);
    
    // Zastosuj współczynniki
    double be = bee *
        _getBreedCoefficient(_selectedBreed) *
        _getActivityCoefficient(_selectedActivity) *
        _getLifeStageCoefficient(_selectedLifeStage) *
        _getBodyConditionCoefficient(_selectedBodyCondition) *
        (_isNeutered ? 0.8 : 1.0);
    
    // Oblicz ilość karmy w gramach
    double dailyGrams = (be * 100) / em;
    
    setState(() {
      _dailyAmount = dailyGrams;
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text(
          'Kalkulator Karmy dla Psa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Nagłówek
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.pets, size: 50, color: Colors.orange.shade700),
                        const SizedBox(height: 8),
                        Text(
                          'Oblicz dzienną porcję karmy dla Twojego psa',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Waga psa
                _buildSectionCard(
                  'Waga psa',
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Waga (kg)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Proszę podać wagę psa';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Proszę podać prawidłową liczbę';
                      }
                      return null;
                    },
                  ),
                ),

                // Etap życia
                _buildSectionCard(
                  'Etap życia',
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLifeStage,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'puppy_2_3', child: Text('Szczeniak 2-3 miesiące')),
                      DropdownMenuItem(value: 'puppy_4_6', child: Text('Szczeniak 4-6 miesięcy')),
                      DropdownMenuItem(value: 'puppy_6_12', child: Text('Szczeniak 6-12 miesięcy')),
                      DropdownMenuItem(value: 'adult', child: Text('Dorosły')),
                      DropdownMenuItem(value: 'senior', child: Text('Senior')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLifeStage = value!;
                      });
                    },
                  ),
                ),

                // Rasa
                _buildSectionCard(
                  'Rasa',
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBreed,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.pets),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'nordic', child: Text('Rasy nordyckie, retriever, nowofundland (0.8)')),
                      DropdownMenuItem(value: 'beagle', child: Text('Beagle, cocker (0.9)')),
                      DropdownMenuItem(value: 'greyhound', child: Text('Chart, dog argentyński (1.2)')),
                      DropdownMenuItem(value: 'other', child: Text('Inne rasy (1.0)')),
                      DropdownMenuItem(value: 'mixed', child: Text('Mieszaniec (1.0)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedBreed = value!;
                      });
                    },
                  ),
                ),

                // Aktywność
                _buildSectionCard(
                  'Aktywność',
                  DropdownButtonFormField<String>(
                    initialValue: _selectedActivity,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.directions_run),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'convalescence', child: Text('Rekonwalescencja (0.7)')),
                      DropdownMenuItem(value: 'very_calm', child: Text('Bardzo spokojny <1h/dzień (0.8)')),
                      DropdownMenuItem(value: 'calm', child: Text('Spokojny 1-3h/dzień (0.9)')),
                      DropdownMenuItem(value: 'normal', child: Text('Normalny 3h/dzień (1.0)')),
                      DropdownMenuItem(value: 'active', child: Text('Aktywny >3h/dzień (1.1)')),
                      DropdownMenuItem(value: 'hyperactive', child: Text('Hiperaktywny (1.2)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedActivity = value!;
                      });
                    },
                  ),
                ),

                // Kondycja ciała
                _buildSectionCard(
                  'Kondycja ciała',
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBodyCondition,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.fitness_center),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'very_thin', child: Text('Zbyt chudy (1.2)')),
                      DropdownMenuItem(value: 'underweight', child: Text('Lekka niedowaga (1.1)')),
                      DropdownMenuItem(value: 'optimal', child: Text('Waga optymalna (1.0)')),
                      DropdownMenuItem(value: 'overweight', child: Text('Lekka nadwaga (0.9)')),
                      DropdownMenuItem(value: 'obese', child: Text('Nadwaga/otyłość (0.8)')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedBodyCondition = value!;
                      });
                    },
                  ),
                ),

                // Sterylizacja
                _buildSectionCard(
                  'Sterylizacja',
                  SwitchListTile(
                    title: const Text('Pies sterylizowany/kastrowany'),
                    subtitle: Text(_isNeutered ? 'Współczynnik: 0.8' : 'Współczynnik: 1.0'),
                    value: _isNeutered,
                    onChanged: (value) {
                      setState(() {
                        _isNeutered = value;
                        // Aktualizuj domyślną wartość EM
                        if (_isNeutered) {
                          _emController.text = '340';
                        } else {
                          _emController.text = '385';
                        }
                      });
                    },
                  ),
                ),

                // Energia metabolizowalna
                _buildSectionCard(
                  'Energia metabolizowalna (EM)',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'EM (kcal/100g)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.battery_charging_full),
                          helperText: 'Wartość z opakowania karmy',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Proszę podać wartość EM';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Proszę podać prawidłową liczbę';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Wartość domyślna:\n• 340 kcal/100g - karma dla psa sterylizowanego/seniora\n• 385 kcal/100g - karma dla psa dorosłego niesterylizowanego',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Przycisk oblicz
                ElevatedButton(
                  onPressed: _calculateDailyAmount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('OBLICZ DZIENNĄ PORCJĘ'),
                ),

                // Wynik
                if (_showResult && _dailyAmount != null) ...[
                  const SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle, size: 60, color: Colors.green.shade700),
                          const SizedBox(height: 12),
                          Text(
                            'Dzienna porcja karmy',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_dailyAmount!.toStringAsFixed(0)} g/dzień',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          const Text(
                            '⚠️ To tylko szacunkowa wartość. Zaleca się konsultację z weterynarzem.',
                            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // Tabela referencji
                _buildReferenceTable(),

                const SizedBox(height: 30),

                // Link do psów.pl
                _buildSponsoredLink(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tabela referencyjna - szybkie oszacowanie',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ilość karmy dziennie (w gramach) dla psów o normalnej aktywności:',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.orange.shade100),
                columns: const [
                  DataColumn(label: Text('Waga (kg)', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Niesterylizowany', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Sterylizowany', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('2')), DataCell(Text('57')), DataCell(Text('51'))]),
                  DataRow(cells: [DataCell(Text('3')), DataCell(Text('77')), DataCell(Text('70'))]),
                  DataRow(cells: [DataCell(Text('5')), DataCell(Text('113')), DataCell(Text('102'))]),
                  DataRow(cells: [DataCell(Text('10')), DataCell(Text('188')), DataCell(Text('171'))]),
                  DataRow(cells: [DataCell(Text('15')), DataCell(Text('247')), DataCell(Text('223'))]),
                  DataRow(cells: [DataCell(Text('20')), DataCell(Text('299')), DataCell(Text('271'))]),
                  DataRow(cells: [DataCell(Text('30')), DataCell(Text('392')), DataCell(Text('355'))]),
                  DataRow(cells: [DataCell(Text('40')), DataCell(Text('475')), DataCell(Text('430'))]),
                  DataRow(cells: [DataCell(Text('50')), DataCell(Text('551')), DataCell(Text('499'))]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Uwaga: Wartości zakładają karmę o EM 385 kcal/100g dla psów niesterylizowanych i 340 kcal/100g dla psów sterylizowanych.',
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsoredLink() {
    return Card(
      elevation: 6,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.star, size: 40, color: Colors.amber.shade700),
            const SizedBox(height: 12),
            Text(
              'Szukasz najlepszych produktów dla Twojego psa?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Odkryj profesjonalne porady, recenzje karm i produktów dla psów. Znajdź wszystko, czego potrzebuje Twój czworonożny przyjaciel!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final Uri url = Uri.parse('https://psów.pl/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('najlepsze produkty dla psów'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '🐾 Odwiedź psów.pl - Twoje źródło wiedzy o psach',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
