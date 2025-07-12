import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce1/screens/login_screen.dart'; // Pastikan path-nya sesuai

void main() {
  testWidgets('Login screen shows email, password fields and login button', (WidgetTester tester) async {
    // Jalankan LoginScreen dalam MaterialApp
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Periksa apakah terdapat teks "Login"
    expect(find.text('Login'), findsWidgets); // Bisa muncul di AppBar dan tombol

    // Periksa apakah ada field untuk email dan password
    expect(find.byType(TextField), findsNWidgets(2)); // Biasanya 2 field: email & password

    // Cek apakah ada tombol login (ElevatedButton)
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Coba masukkan teks ke form
    await tester.enterText(find.byType(TextField).first, 'test@email.com');
    await tester.enterText(find.byType(TextField).last, 'password123');

    // Tap tombol login
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Render ulang setelah aksi

    // Tambahan: bisa cek apakah ada navigasi atau loading muncul
  });
}
