import 'dart:convert';
import 'package:galaxy_satwa/models/attendance_model.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:galaxy_satwa/constan.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// By User Login
Future<ApiResponse> getAttendanceByUserLogin() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse('$baseURL/attendance/user'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']);
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => AttendanceModel.fromJson(p))
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

// Today user login
Future<String> getAttendanceToday() async {
  String data = '';
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse('$baseURL/attendance/today'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        if (jsonDecode(response.body)['status'] == 'Kosong') {
          data = 'Kosong';
        } else {
          data =
              '${jsonDecode(response.body)['data'][0]['id']}||${jsonDecode(response.body)['data'][0]['check_out']}';
        }

        break;
      default:
        data = 'Error';
        break;
    }
  } catch (e) {
    data = 'Error';
  }
  return data;
}

// Monthly user login
Future<ApiResponse> getAttendanceMonthly({required String yearmonth}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('$baseURL/attendance/monthly/$yearmonth}'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']);
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => AttendanceModel.fromJson(p))
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

//create
Future<ApiResponse> createAttendance({
  required String date,
  required String checkIn,
}) async {
  print(date);
  print(checkIn);
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse('$baseURL/attendance'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'date': date,
      'check_in': checkIn,
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(response.body);
        apiResponse.data = jsonDecode(response.body);
        break;
      default:
        print(jsonDecode(response.body));
        apiResponse.error = 'Something Whent Wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server Error';
  }
  return apiResponse;
}

//Update Attendance
Future<ApiResponse> updateAttendance({
  required String idAttendance,
  required String checkOut,
}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .put(Uri.parse('$baseURL/attendance/$idAttendance'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'check_out': checkOut,
    });
    switch (response.statusCode) {
      case 200:
        print(apiResponse.data);
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = 'Data Not Found';
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
