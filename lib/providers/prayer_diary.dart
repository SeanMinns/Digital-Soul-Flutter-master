import 'dart:convert';

import 'package:digital_soul/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Entry with ChangeNotifier {
  final String? id;
  final DateTime? date;
  late final int? beforeEmotions;
  late final int? afterEmotions;
  late final int? beforeStress;
  late final int? afterStress;
  late final List<String>? prayerType;
  late final String? prayer;
  late final String? note;
  late final String? noteId;

  Entry({
    @required this.id,
    @required this.date,
    @required this.beforeEmotions,
    @required this.afterEmotions,
    @required this.beforeStress,
    @required this.afterStress,
    @required this.prayerType,
    @required this.prayer,
    @required this.note,
    @required this.noteId,
  });
}

class Diary with ChangeNotifier {
  List<Entry> _diary = [
    // Entry(
    //   id: "1",
    //   date: DateTime.parse("2021-07-13 19:00:12.005"),
    //   beforeEmotions: 3,
    //   afterEmotions: 1,
    //   beforeStress: 1,
    //   afterStress: 3,
    //   prayerType: ["Gratitude", "Forgiveness"],
    //   prayer:
    //       "Today I am praying about Lorem Ipsum is used as placeholder text in the typesetting industry. Today I am praying about Lorem Ipsum is used as placeholder text in the type setting industry. Today I am praying about Lorem Ipsum is used as",
    //   note: "",
    //   noteId: "1",
    // ),
    // Entry(
    //   id: "0",
    //   date: DateTime.parse("2021-07-12 17:00:13.005"),
    //   beforeEmotions: 5,
    //   afterEmotions: 0,
    //   beforeStress: 2,
    //   afterStress: 1,
    //   prayerType: ["Gratitude", "Forgiveness"],
    //   prayer:
    //       "Today I am praying about Lorem Ipsum is used as placeholder text in the typesetting industry. Today I am praying about Lorem Ipsum is used as placeholder text in the type setting industry. Today I am praying about Lorem Ipsum is used as",
    //   note: "",
    //   noteId: "2",
    // ),
  ];

  String? token;
  String? id;

  Diary(this.token, this.id, this._diary);

  List<Entry> get diary {
    return [..._diary];
  }

  Future<void> getEntries() async {
    try {
      const url = "https://digitalsoulmclean.com/api/users/notes/getAll";
      Map apiData = {"id": id};
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
        throw HttpException('Failed to load prayer entries');
      }
      List<Entry> data = [];
      if (extractedData['entries'].length != 0) {
        for (int i = 0; i < extractedData['entries'].length; i++) {
          data.insert(
            i,
            Entry(
              id: extractedData['entries'][i]['noteId'],
              date: DateTime.parse(
                  '${extractedData['entries'][i]['date']} ${extractedData['entries'][i]['time']}'),
              beforeEmotions:
                  int.parse(extractedData['entries'][i]['feelingBefore']),
              afterEmotions:
                  int.parse(extractedData['entries'][i]['feelingAfter']),
              beforeStress:
                  int.parse(extractedData['entries'][i]['stressBefore']),
              afterStress:
                  int.parse(extractedData['entries'][i]['stressAfter']),
              prayer: extractedData['entries'][i]['prayer'],
              note: extractedData['entries'][i]['notes'],
              noteId: extractedData['entries'][i]['noteId'],
              prayerType: extractedData['entries'][i]['prayerType']
                  .toString()
                  .split(', ')
                  .toList(),
            ),
          );
          _diary = data.reversed.toList();
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addEntry(
    int beforeEmotions,
    int afterEmotions,
    int beforeStress,
    int afterStress,
    List<String> prayerType,
    String prayer,
    String question3Time,
  ) async {
    try {
      const url = "https://digitalsoulmclean.com/api/users/notes/addNote";
      var dateTime = DateTime.now().toString();
      var date = dateTime.split(' ')[0];
      var time = dateTime.split(' ')[1];
      Map apiData = {
        "id": id,
        "diary": {
          "date": date.toString(),
          "time": time.toString(),
          "timeTakenForThirdField": question3Time,
          "prayerType": prayerType.join(', ').toString(),
          "feelingBefore": beforeEmotions.toString(),
          "feelingAfter": afterEmotions.toString(),
          "stressBefore": beforeStress.toString(),
          "stressAfter": afterStress.toString(),
          "prayer": prayer,
          "notes": ""
        },
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
        throw HttpException('Failed to add prayer entry');
      }
      // Entry temp = new Entry(
      //   id: (_diary.length - 1).toString(),
      //   date: DateTime.now(),
      //   // date: DateTime.now().hour > 11
      //   //     ? '${DateFormat("E, LLL d, h:m").format(DateTime.now())}pm'
      //   //     : '${DateFormat("E, LLL d, h:m").format(DateTime.now())}am',
      //   beforeEmotions: beforeEmotions,
      //   afterEmotions: afterEmotions,
      //   beforeStress: beforeStress,
      //   afterStress: afterStress,
      //   prayerType: prayerType,
      //   prayer: prayer,
      //   note: "",
      // );
      // _diary.insert(0, temp);
      // notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addNote(String noteId, String note) async {
    try {
      const url = "https://digitalsoulmclean.com/api/users/notes/editNote";
      Map apiData = {
        "id": id,
        "diary": {
          "noteId": noteId,
          "notes": note,
        },
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
        throw HttpException('Failed to add note');
      }
      int entryIndex = _diary.indexWhere((element) => element.noteId == noteId);
      _diary[entryIndex] = Entry(
        id: _diary[entryIndex].id,
        date: _diary[entryIndex].date,
        beforeEmotions: _diary[entryIndex].beforeEmotions,
        afterEmotions: _diary[entryIndex].afterEmotions,
        beforeStress: _diary[entryIndex].beforeStress,
        afterStress: _diary[entryIndex].afterStress,
        prayerType: _diary[entryIndex].prayerType,
        prayer: _diary[entryIndex].prayer,
        note: note,
        noteId: _diary[entryIndex].noteId,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
