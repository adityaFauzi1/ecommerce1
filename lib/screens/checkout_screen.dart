import 'package:flutter/material.dart';
import '../services/checkout_service.dart';
import 'success_screen.dart'; // Pastikan import success_screen

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _checkoutService = CheckoutService();

  List<dynamic> _paymentMethods = [];
  List<dynamic> _shippingMethods = [];
  bool _isLoading = true;

  String? _selectedPaymentMethod;
  String? _selectedShippingMethod;

  @override
  void initState() {
    super.initState();
    _loadCheckoutData();
  }

  Future<void> _loadCheckoutData() async {
    try {
      final payments = await _checkoutService.getPaymentMethods();
      final shippings = await _checkoutService.getShippingMethods();
      setState(() {
        _paymentMethods = payments;
        _shippingMethods = shippings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _confirmCheckout() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPaymentMethod == null || _selectedShippingMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih metode pembayaran dan pengiriman')),
        );
        return;
      }

      // Navigasi ke SuccessScreen setelah checkout berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SuccessScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alamat
              Text('Alamat Pengiriman', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan alamat lengkap Anda',
                ),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              // Metode Pembayaran
              Text('Metode Pembayaran', style: Theme.of(context).textTheme.titleLarge),
              ..._paymentMethods.map((method) {
                return RadioListTile<String>(
                  title: Text(method['name']),
                  value: method['id'],
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value),
                );
              }).toList(),
              const SizedBox(height: 24),

              // Metode Pengiriman
              Text('Metode Pengiriman', style: Theme.of(context).textTheme.titleLarge),
              ..._shippingMethods.map((method) {
                return RadioListTile<String>(
                  title: Text('${method['name']} - Rp ${method['price']}'),
                  value: method['id'],
                  groupValue: _selectedShippingMethod,
                  onChanged: (value) => setState(() => _selectedShippingMethod = value),
                );
              }).toList(),
              const SizedBox(height: 32),

              // Tombol Konfirmasi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _confirmCheckout,
                  child: const Text('Konfirmasi & Bayar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}