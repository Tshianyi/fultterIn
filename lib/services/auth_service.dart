import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ===================== CREATE USER =====================
  Future<User?> signUpWithEmail({
    required String fullname,
    required String email,
    required String password,
  }) async {
    try {
      // Créer l’utilisateur FirebaseAuth
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) throw 'Erreur lors de la création du compte';

      // Mettre à jour le displayName dans FirebaseAuth
      await user.updateDisplayName(fullname);

      // Enregistrer dans Firestore
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'fullname': fullname,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      // Retourne un message d'erreur spécifique à l'authentification
      throw e.message ?? 'Une erreur d\'authentification est survenue.';
    } catch (e) {
      // Retourne l'erreur réelle pour un meilleur débogage
      print('Une erreur : ${e.toString()}');
      throw 'Une erreur est surveNue: ${e.toString()}';

    }
  }

  // ===================== SIGN IN USER =====================
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) throw 'Erreur lors de la connexion';

      return user;
    } on FirebaseAuthException catch (e) {
      // Retourne un message d'erreur spécifique à l'authentification
      throw e.message ?? 'Une erreur d\'authentification est survenue.';
    } catch (e) {
      // Retourne l'erreur réelle pour un meilleur débogage
      throw 'Une erreur est surveNNue: ${e.toString()}';
    }
  }

  // ===================== GET USER DATA =====================
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw 'Erreur lors de la récupération des données utilisateur';
    }
  }

  // ===================== SIGN IN WITH GOOGLE =====================
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);
      final User? user = result.user;

      if (user != null) {
        // Check if user exists in Firestore, if not, create
        final doc = await _db.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await _db.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'fullname': user.displayName ?? 'Utilisateur Google',
            'email': user.email ?? '',
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Erreur inconnue';
    } catch (_) {
      throw 'Une erreur est survenue';
    }
  }

  // ===================== SIGN IN WITH TWITTER =====================
  Future<User?> signInWithTwitter() async {
    try {
      final OAuthProvider twitterProvider = OAuthProvider('twitter.com');
      twitterProvider.addScope('email');
      twitterProvider.addScope('profile');

      final UserCredential result = await _auth.signInWithProvider(twitterProvider);
      final User? user = result.user;

      if (user != null) {
        // Check if user exists in Firestore, if not, create
        final doc = await _db.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await _db.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'fullname': user.displayName ?? 'Utilisateur Twitter',
            'email': user.email ?? '',
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw 'Un compte existe déjà avec cette adresse email.';
        case 'invalid-credential':
          throw 'Les informations d\'identification Twitter sont invalides.';
        case 'operation-not-allowed':
          throw 'La connexion Twitter n\'est pas activée dans Firebase.';
        case 'user-disabled':
          throw 'Ce compte utilisateur a été désactivé.';
        case 'user-not-found':
          throw 'Aucun utilisateur trouvé pour ces informations.';
        case 'wrong-password':
          throw 'Mot de passe incorrect.';
        case 'invalid-verification-code':
          throw 'Code de vérification invalide.';
        case 'invalid-verification-id':
          throw 'ID de vérification invalide.';
        default:
          throw e.message ?? 'Erreur lors de la connexion avec Twitter.';
      }
    } catch (e) {
      throw 'Une erreur inattendue est survenue lors de la connexion Twitter: $e';
    }
  }

  // ===================== SIGN IN WITH FACEBOOK =====================
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

        final UserCredential authResult = await _auth.signInWithCredential(facebookAuthCredential);
        final User? user = authResult.user;

        if (user != null) {
          // Check if user exists in Firestore, if not, create
          final doc = await _db.collection('users').doc(user.uid).get();
          if (!doc.exists) {
            await _db.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'fullname': user.displayName ?? 'Utilisateur Facebook',
              'email': user.email ?? '',
              'createdAt': DateTime.now().toIso8601String(),
            });
          }
        }

        return user;
      } else if (result.status == LoginStatus.cancelled) {
        return null;
      } else {
        throw result.message ?? 'Erreur lors de la connexion Facebook';
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw 'Un compte existe déjà avec cette adresse email.';
        case 'invalid-credential':
          throw 'Les informations d\'identification Facebook sont invalides.';
        case 'operation-not-allowed':
          throw 'La connexion Facebook n\'est pas activée dans Firebase.';
        case 'user-disabled':
          throw 'Ce compte utilisateur a été désactivé.';
        case 'user-not-found':
          throw 'Aucun utilisateur trouvé pour ces informations.';
        case 'wrong-password':
          throw 'Mot de passe incorrect.';
        case 'invalid-verification-code':
          throw 'Code de vérification invalide.';
        case 'invalid-verification-id':
          throw 'ID de vérification invalide.';
        default:
          throw e.message ?? 'Erreur lors de la connexion avec Facebook.';
      }
    } catch (e) {
      throw 'Une erreur inattendue est survenue lors de la connexion Facebook: $e';
    }
  }

  // ===================== LOGOUT =====================
  Future<void> logout() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print('Erreur lors de la déconnexion Facebook: $e');
    }
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Erreur lors de la déconnexion Google: $e');
    }
    try {
      await _auth.signOut();
    } catch (e) {
      print('Erreur lors de la déconnexion Firebase: $e');
      throw 'Erreur lors de la déconnexion: $e';
    }
  }
}
