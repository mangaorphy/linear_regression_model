import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _kController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();
  String _selectedCrop = 'rice';
  bool _isLoading = false;

  final List<String> _crops = [
    'rice',
    'apple',
    'cotton',
    'jute',
    'chickpea',
    'banana',
    'blackgram',
    'coconut',
    'coffee',
    'grapes',
    'kidneybeans',
    'lentil',
    'maize',
    'mango',
    'mothbeans',
    'orange',
    'mungbean',
    'muskmelon',
    'papaya',
    'pigeonpeas',
    'pomegranate',
    'watermelon',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nitrogen Predictor',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.green[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Crop Selection Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [

                            Text(
                              'CROP DETAILS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildCropDropdown(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Parameters Card
                    Card(
                      elevation: 4,
                      color: Colors.grey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'SOIL & WEATHER PARAMETERS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildInputField(
                              _pController,
                              'Phosphorus (P)',
                              'mg/kg',
                              '5 - 145',
                            ),
                            _buildInputField(
                              _kController,
                              'Potassium (K)',
                              'mg/kg',
                              '5 - 200',
                            ),
                            _buildInputField(
                              _tempController,
                              'Temperature',
                              '°C',
                              '10 - 45',
                            ),
                            _buildInputField(
                              _humidityController,
                              'Humidity',
                              '%',
                              '14 - 99',
                            ),
                            _buildInputField(_phController, 'pH Level', '',
                                '4.5 - 9.0'),
                            _buildInputField(
                              _rainfallController,
                              'Rainfall',
                              'mm',
                              '0 - 300',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Predict Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _isLoading ? null : _predictNitrogen,
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'PREDICT NITROGEN NEED',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.1,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCropDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCrop,
      items: _crops.map((crop) {
        return DropdownMenuItem(
          value: crop,
          child: Text(
            crop[0].toUpperCase() + crop.substring(1),
            style: TextStyle(fontSize: 15),
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCrop = value!),
      decoration: InputDecoration(
        labelText: 'Select Crop',
        labelStyle: TextStyle(color: Colors.green[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green),
        ),
        filled: true,
        fillColor: Colors.green[50],
        prefixIcon: Icon(Icons.grass, color: Colors.green[700]),
      ),
      icon: Icon(Icons.arrow_drop_down_circle, color: Colors.red[700]),
      dropdownColor: Colors.green[50],
      style: TextStyle(color: Colors.green[900]),
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    String unit,
    [String? range]
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green[700]),
          suffixText: unit,
          suffixStyle: TextStyle(color: Colors.green[700]),
          hintText: range != null ? 'Range: $range' : null,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black54, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green[700]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.green[50],
        ),
        validator: (value) {
          if (value!.isEmpty) return 'Required field';
          if (double.tryParse(value) == null) return 'Enter valid number';
          return null;
        },
      ),
    );
  }

  Future<void> _predictNitrogen() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final result = await ApiService.predictNitrogen(
          p: double.parse(_pController.text),
          k: double.parse(_kController.text),
          temperature: double.parse(_tempController.text),
          humidity: double.parse(_humidityController.text),
          ph: double.parse(_phController.text),
          rainfall: double.parse(_rainfallController.text),
          cropType: _selectedCrop,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(prediction: result),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red[700],
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
