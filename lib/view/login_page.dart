// Redesigned LoginPage UI (logo removed, variables untouched)
import 'package:first_pro/controllers/auth_controller.dart';
import 'package:first_pro/widgets/custom_input_field.dart';
import 'package:first_pro/widgets/custom_social_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  Future<void> _callGoogleSignIn() async {
    setState(() => _isLoading = true);
    final errorMessage = await _authController.signInWithGoogle();
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion avec Google réussie')));
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _callTwitterSignIn() async {
    setState(() => _isLoading = true);
    final errorMessage = await _authController.signInWithTwitter();
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion avec Twitter réussie')));
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _callFacebookSignIn() async {
    setState(() => _isLoading = true);
    final errorMessage = await _authController.signInWithFacebook();
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion avec Facebook réussie')));
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _callLogin() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final errorMessage = await _authController.loginUser(email: email, password: password);

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    _emailController.clear();
    _passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion réussie')));
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.grey.shade400),
              shape: BoxShape.circle,
            ),
            child: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ==== Title (logo removed) ====
              Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.blueGrey.shade900,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Heureux de vous revoir',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueGrey.shade600,
                ),
              ),

              const SizedBox(height: 40),

              CustomInputField(
                icon: Icons.email,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),

              const SizedBox(height: 16),

              CustomInputField(
                icon: Icons.lock,
                hint: 'Mot de passe',
                obscure: true,
                keyboardType: TextInputType.visiblePassword,
                controller: _passwordController,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isLoading ? null : _callLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Connexion',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OU'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSocialIcon(
                    onPressed: _callGoogleSignIn,
                    child: Image.asset('lib/assets/google.png', height: 32),
                  ),
                  const SizedBox(width: 25),
                  CustomSocialIcon(
                    onPressed: _callFacebookSignIn,
                    child: Image.asset('lib/assets/facebook.png', height: 32),
                  ),
                  const SizedBox(width: 25),
                  CustomSocialIcon(
                    onPressed: _callTwitterSignIn,
                    child: Image.asset('lib/assets/twitter.png', height: 32),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Vous n'avez pas de compte ?"),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                        color: Colors.blueGrey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
