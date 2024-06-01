import 'dart:convert';
import 'package:galaxy_satwa/models/medical_record_model.dart';
import 'package:galaxy_satwa/services/auth_service.dart';
import 'package:galaxy_satwa/constan.dart';
import 'package:galaxy_satwa/models/api_response_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// All By Pet Id
Future<ApiResponse> getMedicalRecordByPetId({required int petId}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('$baseURL/medicalrecord/pet/$petId'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        print(jsonDecode(response.body)['data']);
        apiResponse.data = jsonDecode(response.body)['data']
            .map((p) => MedicalRecordModel.fromJson(p))
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
Future<ApiResponse> createMedicalRecord({
  required String petId,
  required String symptom,
  required String diagnosis,
  required String action,
  required String recipe,
}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse('$baseURL/medicalrecord'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'pet_id': petId,
      'symptom': symptom,
      'diagnosis': diagnosis,
      'action': action,
      'recipe': recipe,
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
Future<ApiResponse> updateMedicalRecord({
  required String recordId,
  required String symptom,
  required String diagnosis,
  required String action,
  required String recipe,
}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.put(Uri.parse('$baseURL/medicalrecord/$recordId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'symptom': symptom,
      'diagnosis': diagnosis,
      'action': action,
      'recipe': recipe,
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

//Delete Post
Future<ApiResponse> deleteMedicalRecord(String recordId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .delete(Uri.parse('$baseURL/medicalrecord/$recordId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
