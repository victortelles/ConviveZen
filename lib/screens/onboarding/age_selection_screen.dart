import 'package:flutter/material.dart';

class AgeSelectionScreen extends StatefulWidget {
  final Function(int) onAgeSelected;

  const AgeSelectionScreen({Key? key, required this.onAgeSelected}) : super(key: key);

  @override
  _AgeSelectionScreenState createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  int _selectedAge = 18;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Cuál es tu edad?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Esta información nos ayuda a personalizar mejor tu experiencia',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Container(
            height: 200,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 60,
              diameterRatio: 1.5,
              physics: FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedAge = 13 + index;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final age = 13 + index;
                  final isSelected = age == _selectedAge;
                  
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink.shade100 : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '$age años',
                      style: TextStyle(
                        fontSize: isSelected ? 24 : 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.pink.shade700 : Colors.pink.shade400,
                      ),
                    ),
                  );
                },
                childCount: 50, // Ages 13-62
              ),
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => widget.onAgeSelected(_selectedAge),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: Text(
                'Continuar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}