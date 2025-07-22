import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> prediction;

  const ResultPage({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    final formattedNitrogen = NumberFormat.decimalPattern().format(
      double.parse(prediction['predicted_nitrogen'].toString()),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Results', 
               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[800],
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Result Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('NITROGEN REQUIREMENT', 
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                            letterSpacing: 1.1,
                          )),
                      SizedBox(height: 20),
                      Text('$formattedNitrogen ${prediction['units']}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          )),
                      SizedBox(height: 10),
                      Text('for ${prediction['crop_type'].toString().toUpperCase()}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          )),
                      SizedBox(height: 20),
                      Icon(Icons.eco, size: 50, color: Colors.green),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Additional Information Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RECOMMENDATIONS', 
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          )),
                      SizedBox(height: 10),
                      _buildRecommendationItem('Optimal Application Time', 'Early morning or late afternoon'),
                      _buildRecommendationItem('Application Method', 'Split application recommended'),
                      _buildRecommendationItem('Soil Preparation', 'Ensure proper soil moisture'),
                      SizedBox(height: 10),
                      Text('Note: Results are based on machine learning predictions. Actual field conditions may vary.',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Add save/share functionality
                      },
                      child: Text('SAVE RESULT', 
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('NEW PREDICTION',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 18, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    )),
                Text(value,
                    style: TextStyle(
                      color: Colors.grey[600],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}