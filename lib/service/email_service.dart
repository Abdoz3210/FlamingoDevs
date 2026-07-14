import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const _serviceId  = 'service_qts4x38';
  static const _templateId = 'template_339jvhn';
  static const _publicKey  = '9A-dRl72lvEU-NfKV';

  Future<bool> send({
    required String name,
    required String email,
    required String projectType,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
          'origin':       'http://localhost',
        },
        body: jsonEncode({
          'service_id':  _serviceId,
          'template_id': _templateId,
          'user_id':     _publicKey,
          'template_params': {
            'from_name':    name,
            'from_email':   email,
            'project_type': projectType,
            'message':      message,
          },
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('EmailJS error: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('EmailJS exception: $e');
      return false;
    }
  }
}