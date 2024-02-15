import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'video_player_widget.dart';

class NoteDetailsScreen extends StatelessWidget {
  final String grade;
  final String note;

  NoteDetailsScreen({super.key, required this.grade, required this.note});

  final Map<String, Map<String, String>> tutorialLessons = {
    'Addition Basics': {
      'tutorial': 'https://www.youtube.com/watch?v=example_addition_basics',
      'summary': 'This video tutorial covers the basics of addition in mathematics.',
      'preview': 'https://youtu.be/BZ4FjSXjzgg', 
    },
    'Subtraction Basics': {
      'tutorial': 'https://www.youtube.com/watch?v=example_subtraction_basics',
      'summary': 'This video tutorial covers the basics of subtraction in mathematics.',
      'preview': 'https://youtu.be/BZ4FjSXjzgg', 
    },
   
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                grade,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                note,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                tutorialLessons[note]?['summary'] ?? 'No Tutorial Lesson Available',
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              if (tutorialLessons[note] != null)
                ElevatedButton(
                  onPressed: () {
                  
                    launch(tutorialLessons[note]!['preview']!);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_library),
                      SizedBox(width: 8),
                      Text('Watch Preview'),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              if (tutorialLessons[note] != null)
                VideoPlayerWidget(
                  videoUrl: tutorialLessons[note]!['preview']!,
                ),
             
            ],
          ),
        ),
      ),
    );
  }
}
