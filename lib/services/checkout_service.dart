import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckoutService {
  final String _baseUrl = 'http://localhost:3000'; // Gunakan IP ini untuk emulator Android

  Future<List<dynamic>> getPaymentMethods() async {
    final response = await http.get(Uri.parse('$_baseUrl/payment_methods'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat metode pembayaran');
    }
  }

  Future<List<dynamic>> getShippingMethods() async {
    final response = await http.get(Uri.parse('$_baseUrl/shipping_methods'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat metode pengiriman');
    }
  }
}