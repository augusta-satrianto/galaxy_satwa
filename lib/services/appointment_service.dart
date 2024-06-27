import 'dart:convert';
import 'package:galaxy_satwa/models/appointment_model.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:galaxy_satwa/constan.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';

// All
Future<ApiResponse> getAppointmentAll() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse('$baseURL/appointment'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => AppointmentModel.fromJson(p))
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

// By User Login
Future<ApiResponse> getAppointmentByUserLogin() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse('$baseURL/appointment/user'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => AppointmentModel.fromJson(p))
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

// By Dokter dan Tanggal
Future<List<String>> getAppointmentByDoctorDate(
    {required String doctorId, required String date}) async {
  List<String> listTime = [];
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('$baseURL/appointment/notavailable/$doctorId/$date'),
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Authorization': 'Bearer $token'
        });
    switch (response.statusCode) {
      case 200:
        List<dynamic> data = jsonDecode(response.body)['data'];
        listTime = List<String>.from(data.map((p) => p['time']));
        break;
      default:
        listTime = ['error'];
        break;
    }
  } catch (e) {
    listTime = ['error'];
  }
  return listTime;
}

// By User Login
Future<ApiResponse> getAppointmentWillCome() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse('$baseURL/appointment/willcome'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => AppointmentModel.fromJson(p))
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
Future<ApiResponse> createAppointment({
  required String doctorId,
  required String petId,
  required String date,
  required String time,
}) async {
  ApiResponse apiResponse = ApiResponse();
  String formatTime = time.replaceAll('.', ':');
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse('$baseURL/appointment'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'doctor_id': doctorId,
      'pet_id': petId,
      'date': date,
      'time': formatTime,
    });
    switch (response.statusCode) {
      case 200:
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

//Update Pet
Future<ApiResponse> updateAppointment({
  required String appointmentId,
  required String status,
}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .put(Uri.parse('$baseURL/appointment/$appointmentId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'status': status,
    });
    switch (response.statusCode) {
      case 200:
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
