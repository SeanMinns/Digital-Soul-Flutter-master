import 'dart:convert';

import 'package:digital_soul/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Lesson with ChangeNotifier {
  final String? number;
  final List<String>? answers;
  final List<int>? timer;
  final int? progress;

  Lesson({
    @required this.number,
    @required this.answers,
    @required this.timer,
    @required this.progress,
  });
}

class Lessons with ChangeNotifier {
  List<Lesson> _lessons = [];
  List<int> _progress = [];
  List<bool> _captions = [
    false,
    false,
    false,
    false,
    false,
  ];

  Map<String, int> fullProgress = {
    "1": 7,
    "2": 7,
    "3": 7,
    "4": 17,
    "5": 7,
  };

  String? token;
  String? id;

  Lessons(this.token, this.id, this._lessons, this._progress);

  List<Lesson> get lessons {
    return [..._lessons];
  }

  List<bool> get captions {
    return [..._captions];
  }

  List<int> get progress {
    return [..._progress];
  }

  void clearLessons() {
    _lessons.clear();
    notifyListeners();
  }

  void addProgress(int lessonNumber) {
    if (!_progress.contains(lessonNumber)) {
      _progress.add(lessonNumber);
      notifyListeners();
    }
  }

  void changeCaptions(int index, bool value) {
    _captions[index] = value;
    notifyListeners();
  }

  void addQuestion(int lessonNumber, String answer, int timer) {
    Lesson lesson = _lessons[lessonNumber];
    List<String> answers = lesson.answers!;
    answers.add(answer);
    List<int> timers = lesson.timer!;
    timers.add(timer);
    lesson = Lesson(
      number: lesson.number,
      answers: answers,
      timer: timers,
      progress: lesson.progress! + 1,
    );
    _lessons[lessonNumber] = lesson;
    notifyListeners();
  }

  void updateQuestion(
      int lessonNumber, int questionNumber, String answer, int timer) {
    Lesson lesson = _lessons[lessonNumber];
    List<String> answers = lesson.answers!;
    answers[questionNumber] = answer;
    List<int> timers = lesson.timer!;
    timers[questionNumber] = timer;
    lesson = Lesson(
      number: lesson.number,
      answers: answers,
      timer: timers,
      progress: lesson.progress!,
    );
    notifyListeners();
  }

  void deleteLesson(int lessonNumber) {
    _lessons[lessonNumber] = Lesson(
      number: lessonNumber.toString(),
      answers: [],
      timer: [],
      progress: 0,
    );
    notifyListeners();
  }

  void setLessons(
    String lessonNumber,
    List<String> answers,
    List<int> timer,
    List<int> data,
  ) {
    _lessons.add(
      Lesson(
        number: lessonNumber,
        answers: answers,
        timer: timer,
        progress: answers.length,
      ),
    );
    _progress = data;
    notifyListeners();
  }

  Future<List<int>> setLessonsProgress() async {
    try {
      const url = "https://digitalsoulmclean.com/api/users/checkLessonsStatus";
      Map apiData = {
        "id": id,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(apiData),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData['code'] == 0) {
        throw '';
      }
      List<int> data = List<int>.from(extractedData['lessonsCompleted']);
      print(data);
      return data;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addLesson(
    String number,
    List<String> questions,
    List<dynamic> answers,
    List<int> timer,
  ) async {
    try {
      var url = "https://digitalsoulmclean.com/api/users/lessons/add/$number";
      List<Map<String, String>> dataAnswer = [];
      for (int i = 0; i < answers.length; i++) {
        dataAnswer.add({
          "question": questions[i].toString(),
          "answer": "${answers[i].toString()}",
          "timeTaken": "${timer[i].toString()}",
        });
      }
      Map apiData = {
        "id": id,
        "lesson${number}Answers": dataAnswer,
      };
      print(apiData);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(apiData),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData['code'] == 0) {
        throw HttpException('Failed to add lesson $number');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> sendEmailToChaplain(
    String userId,
    String email,
    String message,
  ) async {
    try {
      const url = "https://digitalsoulmclean.com/api/users/sendEmail";
      Map apiData = {
        "id": id,
        "email": email,
        "message": message,
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(apiData),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);

      if (extractedData['code'] == 0) {
        throw HttpException('Failed to send email to Chaplain');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addSuicideWords(List<String> suicideWords, String where) async {
    try {
      const url = 'https://digitalsoulmclean.com/api/users/addSuicideWords';
      Map apiData = {
        "id": id,
        "data": "where: $where; what: ${suicideWords.join(', ').toString()}",
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(apiData),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      print('suicide words added');
      if (extractedData['code'] == 0) {
        throw HttpException('Failed to add suicide words');
      }
    } catch (error) {
      throw error;
    }
  }
}
