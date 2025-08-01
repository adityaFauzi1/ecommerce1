import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Dapatkan pengguna saat ini
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ✅ LOGIN
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // ✅ jika sukses, return null (tidak ada error)
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return 'Email atau password salah atau akun tidak terdaftar.';
      } else if (e.code == 'user-not-found') {
        return 'Akun tidak ditemukan. Silakan daftar dahulu.';
      } else if (e.code == 'wrong-password') {
        return 'Password salah. Coba lagi.';
      } else {
        return 'Terjadi kesalahan: ${e.message}';
      }
    }
  }

  // ✅ REGISTER
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // ✅ jika sukses, return null
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Password terlalu lemah (minimal 6 karakter).';
      } else if (e.code == 'email-already-in-use') {
        return 'Email sudah terdaftar.';
      } else {
        return 'Terjadi kesalahan: ${e.message}';
      }
    }
  }

  // ✅ LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}