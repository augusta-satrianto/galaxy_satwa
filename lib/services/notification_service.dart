import 'dart:convert';
import 'package:galaxy_satwa/models/notification_model.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:galaxy_satwa/constan.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';

// By User Login
Future<ApiResponse> getNotificationByUserLogin() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse('$baseURL/notification/user'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => NotificationModel.fromJson(p))
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

//Update isread
Future<ApiResponse> updateNotification() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse('$baseURL/notification/user'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(response.body);
        apiResponse.data = jsonDecode(response.body);
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
