import 'package:flutter/material.dart';
import 'note_details_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class MathsLibrary extends StatefulWidget {
  const MathsLibrary({super.key});

  @override
  _MathsLibraryState createState() => _MathsLibraryState();
}

class _MathsLibraryState extends State<MathsLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Maths Library'),
            floating: true,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle dropdown menu item selection
                  // You can add functionality based on the selected option
                  print('Selected option: $value');
                  if (value == 'Download Mathematics PDF(Beginner Level)') {
                    downloadPDF('beginner_level.pdf');
                  } else if (value == 'Download Mathematics PDF(Intermediate Level)') {
                    downloadPDF('intermediate_level.pdf');
                  } else if (value == 'Download Mathematics PDF(Advance Level)') {
                    downloadPDF('advance_level.pdf');
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    'Download Mathematics PDF(Beginner Level)',
                    'Download Mathematics PDF(Intermediate Level)',
                    'Download Mathematics PDF(Advance Level)'
                  ].map((String option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ShelfWidget(
                  grade: grades[index],
                  notes: notes[index],
                );
              },
              childCount: grades.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> downloadPDF(String pdfFileName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String fullPath = '$appDocPath/$pdfFileName';

    ByteData data = await rootBundle.load('assets/$pdfFileName');
    List<int> bytes = data.buffer.asUint8List();
    await File(fullPath).writeAsBytes(bytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloaded $pdfFileName to $appDocPath'),
      ),
    );
  }
}

final List<String> grades = [
  'Grade 1',
  'Grade 2',
  'Grade 3',
  'Grade 4',
  'Grade 5',
  'Grade 6',
  'Grade 7',
];

final List<List<String>> notes = [
  ['Addition Basics', 'Subtraction Basics', 'Number Bonds', 'Simple Shapes'],
  ['Multiplication Basics', 'Division Basics', '2D Shapes', 'Fractions Introduction'],
  ['Multiplication and Division Facts', 'Time Concepts', 'Introduction to Money', 'Geometric Shapes'],
  ['Fractions and Decimals', 'Measurement: Length, Weight, and Capacity', 'Understanding Angles', 'Patterns and Sequences'],
  ['Addition and Subtraction of Fractions', 'Introduction to Algebra', 'Perimeter and Area', 'Data and Probability'],
  ['Multiplication and Division of Fractions', 'Integers and Number Line', 'Ratio and Proportion', 'Geometry: Triangles and Quadrilaterals'],
  ['Algebraic Expressions', 'Equations and Inequalities', 'Area and Volume', 'Statistics and Probability'],
];

class ShelfWidget extends StatelessWidget {
  final String grade;
  final List<String> notes;

  const ShelfWidget({super.key, required this.grade, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              grade,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notes[index]), // Change here to display individual notes
                onTap: () {
                  // Navigate to the NoteDetailsScreen when a note is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailsScreen(
                        grade: grade,
                        note: notes[index], // Change here to pass the correct note
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
