import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'What is the above madd (extension) and how long should it be extended?',
      'answers': [
        'ikhfa, 2 counts',
        'muttassil, 4 counts',
        'Laazim, 6 counts',
        'Ghunna, 2 counts'
      ],
      'correctAnswer': 'muttassil, 4 counts',
    },
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  void answerQuestion(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex]['correctAnswer']) {
      setState(() {
        score++;
      });
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() async {
    bool passed = score >= questions.length * 0.80; // 80% pass rate

    // Update user's canRecord status in Firebase
    if (passed) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'canRecord': true,
      });
      // QawlUser user = getCurrentQawlUser();
      // user.canRecord = true
    }

    // Navigate back to the recording page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recording Permission Quiz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(questions[currentQuestionIndex]['question']),
            ...(questions[currentQuestionIndex]['answers'] as List<String>).map(
              (answer) => ElevatedButton(
                onPressed: () => answerQuestion(answer),
                child: Text(answer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
