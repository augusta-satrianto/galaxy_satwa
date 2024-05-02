import 'dart:convert';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constan.dart';
import '../models/api_response_model.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';

Future<ApiResponse> login(
    {required String email, required String password}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse('$baseURL/login'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    }, body: {
      'email': email,
      'password': password
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']['user']);
        apiResponse.data =
            AuthModel.fromJson(jsonDecode(response.body)['data']);
        break;
      default:
        apiResponse.error = 'Something Whent Wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

Future<ApiResponse> register({
  required String name,
  required String email,
  required String password,
}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse('$baseURL/register'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    }, body: {
      'name': name,
      'email': email,
      'password': password,
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        print(jsonDecode(response.body)['errors']);
        if (jsonDecode(response.body)['errors'].containsKey('email')) {
          apiResponse.error = jsonDecode(response.body)['errors']['email'][0];
        } else {
          apiResponse.error =
              jsonDecode(response.body)['errors']['password'][0];
        }
        break;
      default:
        apiResponse.error = 'Something Whent Wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$baseURL/user'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['user']);
        apiResponse.data =
            UserModel.fromJson(jsonDecode(response.body)['user']);
        break;
      default:
        apiResponse.error = 'Something Whent Wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

// All user
Future<ApiResponse> getUserAll() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$baseURL/alluser'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']);
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => UserModel.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      default:
        apiResponse.error = 'Something Whent Wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

// All User Role Dokter
Future<ApiResponse> getAllDokter() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse('$baseURL/user/dokter'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token',
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']);
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => UserModel.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      default:
        apiResponse.error = 'Something Whent Wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

// Update user
Future<ApiResponse> updateUser(
    {required String name,
    required String dateOfBirth,
    required String gender,
    required String phone,
    required String address,
    String? image}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$baseURL/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null
            ? {
                'name': name,
                'date_of_birth': dateOfBirth,
                'gender': gender,
                'phone': phone,
                'address': address,
                'image': image,
              }
            : {
                'name': name,
                'date_of_birth': dateOfBirth,
                'gender': gender,
                'phone': phone,
                'address': address,
              });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = "Something Whent Wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

// Update user
Future<ApiResponse> updatePassword({required String password}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.put(Uri.parse('$baseURL/updatepassword'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'password': password,
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = "Something Whent Wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

Future<ApiResponse> sendEmail({required String token}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response =
        await http.post(Uri.parse('$baseURL/email/resend'), headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['message']);
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = "Something Whent Wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

Future<ApiResponse> forgotPassword({required String email}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response =
        await http.post(Uri.parse('$baseURL/forgot-password'), headers: {
      'X-Requested-With': 'XMLHttpRequest',
    }, body: {
      'email': email,
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['meta']);
        apiResponse.data = jsonDecode(response.body)['meta'];
        break;
      case 400:
        print(jsonDecode(response.body)['error']);
        apiResponse.error = jsonDecode(response.body)['error'];
        break;
      default:
        apiResponse.error = "Something Whent Wrong";
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

//get token
Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('token') ?? '';
}

// get emailogin
Future<String> getEmailLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('emaillogin') ?? '';
}

// get passwordlogin
Future<String> getPasswordLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('passwordlogin') ?? '';
}

//get email
Future<String> getEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('email') ?? '';
}

//get role
Future<String> getRole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('role') ?? '';
}

//get user id
Future<int> getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('userId') ?? 0;
}

//get name
Future<String> getName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('name') ?? '';
}

//get image
Future<String> getImage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('image') ?? '';
}

//logout
Future<bool> logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.remove('token');
}

String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
