import 'package:first_pro/services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  // ===================== SIGNUP LOGIC =====================
  Future<String?> registerUser({
    required String fullname,
    required String email,
    required String password,
  }) async {
    if (fullname.isEmpty) return 'Le nom complet est obligatoire';
    if (email.isEmpty) return 'L\'email est obligatoire';
    if (!email.contains('@')) return 'Email invalide';
    if (password.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';

    try {
      await _authService.signUpWithEmail(
        fullname: fullname,
        email: email,
        password: password,
      );
      return null; // succès
    } catch (e) {
      return e.toString();
    }
  }

  // ===================== LOGIN LOGIC =====================
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) return 'L\'email est obligatoire';
    if (!email.contains('@')) return 'Email invalide';
    if (password.isEmpty) return 'Le mot de passe est obligatoire';

    try {
      await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      return null; // succès
    } catch (e) {
      return e.toString();
    }
  }

  // ===================== GET USER DATA =====================
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      return await _authService.getUserData();
    } catch (e) {
      return null;
    }
  }

  // ===================== GOOGLE SIGN IN =====================
  Future<String?> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      return null; // succès
    } catch (e) {
      return e.toString();
    }
  }

  // ===================== TWITTER SIGN IN =====================
  Future<String?> signInWithTwitter() async {
    try {
      await _authService.signInWithTwitter();
      return null; // succès
    } catch (e) {
      return e.toString();
    }
  }

  // ===================== FACEBOOK SIGN IN =====================
  Future<String?> signInWithFacebook() async {
    try {
      await _authService.signInWithFacebook();
      return null; // succès
    } catch (e) {
      return e.toString();
    }
  }

  // ===================== LOGOUT =====================
  Future<void> logout() async {
    await _authService.logout();
  }
}
