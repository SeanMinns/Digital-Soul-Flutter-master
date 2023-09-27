import 'dart:convert';
import 'package:digital_soul/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:uuid/uuid.dart';

class Profile with ChangeNotifier {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? mrn;
  final String? email;

  Profile({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.dateOfBirth,
    @required this.mrn,
    @required this.email,
  });
}

class UserProfile with ChangeNotifier {
  Profile? _item;
  String? _token;

  Profile? get item {
    return _item;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String mrn,
    required String dob,
  }) async {
    try {
      var uuid = Uuid();
      var uniqueId = uuid.v4();
      Map<String, String> userAttributes = {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'mrn': mrn,
        'birthdate': dob,
        'uniqueIdentifier': uniqueId.toString(),
        // additional attributes as needed
      };
      SignUpResult res = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      print(res);
      print('Registered SUCCESS');
      if (res.isSignUpComplete) {
        SignInResult res1 = await Amplify.Auth.signIn(
          username: email,
          password: password,
        );
        if (res1.isSignedIn) {
          await fetchUserDetail(email, 0);
          print(item!.id);
          const url = 'https://digitalsoulmclean.com/api/users/register';
          Map apiData = {
            "id": item!.id.toString(),
            "email": email.toString(),
            'uniqueIdentifier': uniqueId.toString(),
          };
          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(apiData),
          );

          final extractedData =
              json.decode(response.body) as Map<String, dynamic>;
          print(extractedData);
          if (extractedData['code'] == 1) {
            print('REGISTERED ON API');
            await genAuthToken(item!.id!, email);
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on AuthException catch (e) {
      throw e;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> confirmSignup(
      {required String username, required String code}) async {
    if (username != "" && code != "") {
      try {
        SignUpResult res = await Amplify.Auth.confirmSignUp(
            username: username, confirmationCode: code);
        print(res.isSignUpComplete);
        print('SUCCESS');
      } on AuthException catch (e) {
        print(e.message);
      }
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      print('USER LOGGED IN');
      if (res.isSignedIn) {
        await fetchUserDetail(email, 1);
      }
      return res.isSignedIn;
    } on AuthException catch (e) {
      throw e.message;
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUserDetail(String email, int type) async {
    try {
      var res = await Amplify.Auth.fetchUserAttributes();
      var id;
      var firstName;
      var lastName;
      var dateOfBirth;
      var mrn;
      var email;
      res.forEach((element) {
        print('key: ${element.userAttributeKey}; value: ${element.value}');
        if (element.userAttributeKey.toString() == 'custom:first_name') {
          firstName = element.value;
        } else if (element.userAttributeKey.toString() == 'custom:last_name') {
          lastName = element.value;
        } else if (element.userAttributeKey.toString() == 'custom:mrn') {
          mrn = element.value.toString();
        } else if (element.userAttributeKey.toString() == 'sub') {
          id = element.value;
        } else if (element.userAttributeKey.toString() == 'birthdate') {
          dateOfBirth = element.value;
        } else if (element.userAttributeKey.toString() == 'email') {
          email = element.value;
        }
      });
      var data;
      data = Profile(
        id: id,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        mrn: mrn,
        email: email,
      );
      if (type == 1) {
        await genAuthToken(id, email);
      }
      _item = data;
      notifyListeners();
    } on AuthException catch (e) {
      throw e;
    } catch (error) {
      throw error;
    }
  }

  Future<void> genAuthToken(String id, String email) async {
    try {
      const url = 'https://digitalsoulmclean.com/api/users/genAuthToken';
      Map apiData = {
        "user": {"id": id.toString(), "email": email.toString()}
      };
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(apiData),
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData['code'] == 0) {
        throw '';
      }
      print(extractedData['code']);
      print(extractedData['token']);
      _token = extractedData['token'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addInitialQuestions(
      List<String> questions, List<dynamic> answers) async {
    try {
      const url = "https://digitalsoulmclean.com/api/users/addInitialQuestions";
      List<Map<String, String>> dataAnswer = [];
      for (int i = 0; i < 4; i++) {
        dataAnswer.add({
          "question": questions[i].toString(),
          "answer": "${answers[i].toString()}",
        });
      }
      Map apiData = {
        "id": item!.id.toString(),
        "initialQuestions": dataAnswer,
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
        throw HttpException('Failed to add Initial Questions');
      }
    } catch (error) {
      throw error;
    }
  }
}
