// Redesigned SignupPage UI (logo removed, variables untouched)
import 'package:first_pro/controllers/auth_controller.dart';
import 'package:first_pro/widgets/custom_input_field.dart';
import 'package:first_pro/widgets/custom_social_icon.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isLoading = false;

  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  Future<void> _callGoogleSignIn() async {
    setState(() => _isLoading = true);
    final errorMessage = await _authController.signInWithGoogle();
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connexion avec Google réussie')),
    );
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _callTwitterSignIn() async {
    setState(() => _isLoading = true);
    final errorMessage = await _authController.signInWithTwitter();
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connexion avec Twitter réussie')),
    );
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _callFacebookSignIn() async {
    setState(() => _isLoading = true);
    final errorMessage = await _authController.signInWithFacebook();
    setState(() => _isLoading = false);
    if (!mounted) return;
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connexion avec Facebook réussie')),
    );
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _callSignUp() async {
    setState(() => _isLoading = true);
    final fullname = _fullnameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final errorMessage = await _authController.registerUser(
      fullname: fullname,
      email: email,
      password: password,
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }

    _fullnameController.clear();
    _emailController.clear();
    _passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compte créé avec succès ,Connectez-vous')),
    );
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ==== Title redesigned ====
              Center(
                child: Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: Colors.blueGrey.shade900,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  "Rejoignez-nous et commencez l'aventure",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              CustomInputField(
                icon: Icons.person,
                hint: 'Nom complet',
                controller: _fullnameController,
              ),
              const SizedBox(height: 16),

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
                  onPressed: _isLoading ? null : _callSignUp,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "S'inscrire",
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
                  const Text('Vous avez déjà un compte ?'),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      'Se connecter',
                      style: TextStyle(
                        color: Colors.blueGrey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
