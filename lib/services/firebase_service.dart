import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  // ============================================================
  // FIREBASE INSTANCES
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // CURRENT USER / SESSION MANAGEMENT
  // ============================================================

  User? get currentUser {
    return _auth.currentUser;
  }

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }

  bool get isAnonymous {
    return _auth.currentUser?.isAnonymous ?? false;
  }

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  // ============================================================
  // SIGN UP WITH EMAIL + PASSWORD
  // ============================================================

  Future<User?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final UserCredential result =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = result.user;

      if (user == null) {
        return null;
      }

      // Update Firebase Auth profile
      await user.updateDisplayName(
        name.trim(),
      );

      // Send email verification
      await user.sendEmailVerification();

      // Save user data in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'uid': user.uid,
          'name': name.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'provider': 'password',
          'isAnonymous': false,
          'emailVerified': false,
          'createdAt':
          FieldValue.serverTimestamp(),
          'lastLoginAt':
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // ============================================================
  // LOGIN WITH EMAIL + PASSWORD
  // ============================================================

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result =
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = result.user;

      if (user == null) {
        return null;
      }

      // Refresh user information
      await user.reload();

      final User? refreshedUser =
          _auth.currentUser;

      if (refreshedUser != null) {
        await _firestore
            .collection('users')
            .doc(refreshedUser.uid)
            .set(
          {
            'lastLoginAt':
            FieldValue.serverTimestamp(),
            'emailVerified':
            refreshedUser.emailVerified,
          },
          SetOptions(merge: true),
        );
      }

      return refreshedUser;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // ============================================================
  // SEND EMAIL VERIFICATION
  // ============================================================

  Future<void> sendEmailVerification() async {
    final User? user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No user is currently logged in.',
      );
    }

    await user.sendEmailVerification();
  }

  // ============================================================
  // CHECK EMAIL VERIFICATION
  // ============================================================

  Future<bool> isEmailVerified() async {
    User? user =
        _auth.currentUser;

    if (user == null) {
      return false;
    }

    await user.reload();

    user = _auth.currentUser;

    return user?.emailVerified ?? false;
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> sendPasswordResetEmail(
      String email,
      ) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // ============================================================
  // GOOGLE SIGN-IN
  // ============================================================

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn =
          GoogleSignIn.instance;

      // Initialize Google Sign-In
      await googleSignIn.initialize();

      // Open Google account picker
      final GoogleSignInAccount googleUser =
      await googleSignIn.authenticate();

      // Get Google authentication
      final GoogleSignInAuthentication
      googleAuth =
          googleUser.authentication;

      // Create Firebase credential
      final AuthCredential credential =
      GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Login with Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(
        credential,
      );

      final User? user =
          userCredential.user;

      if (user == null) {
        return null;
      }

      // Save Google user data
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'phone': user.phoneNumber ?? '',
          'photoUrl': user.photoURL ?? '',
          'provider': 'google',
          'isAnonymous': false,
          'emailVerified':
          user.emailVerified,
          'lastLoginAt':
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // ============================================================
  // ANONYMOUS / GUEST LOGIN
  // ============================================================

  Future<User?> signInAnonymously() async {
    try {
      final UserCredential result =
      await _auth.signInAnonymously();

      final User? user = result.user;

      if (user == null) {
        return null;
      }

      // Save anonymous user data
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'uid': user.uid,
          'name': 'Guest User',
          'email': '',
          'phone': '',
          'provider': 'anonymous',
          'isAnonymous': true,
          'createdAt':
          FieldValue.serverTimestamp(),
          'lastLoginAt':
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // ============================================================
  // PHONE OTP - SEND OTP
  // ============================================================

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(
        String verificationId,
        int? resendToken,
        )
    onCodeSent,
    required void Function(
        FirebaseAuthException error,
        )
    onVerificationFailed,
    required void Function(
        PhoneAuthCredential credential,
        )
    onVerificationCompleted,
    required void Function(
        String verificationId,
        )
    onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),

      timeout:
      const Duration(seconds: 60),

      verificationCompleted:
      onVerificationCompleted,

      verificationFailed:
      onVerificationFailed,

      codeSent: onCodeSent,

      codeAutoRetrievalTimeout:
      onCodeAutoRetrievalTimeout,
    );
  }

  // ============================================================
  // PHONE OTP - VERIFY OTP
  // ============================================================

  Future<User?> verifyPhoneOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final PhoneAuthCredential credential =
      PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp.trim(),
      );

      final UserCredential result =
      await _auth.signInWithCredential(
        credential,
      );

      final User? user = result.user;

      if (user == null) {
        return null;
      }

      // Save phone user
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'phone':
          user.phoneNumber ?? '',
          'provider': 'phone',
          'isAnonymous': false,
          'lastLoginAt':
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      return user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // ============================================================
  // REFRESH CURRENT USER
  // ============================================================

  Future<User?> refreshCurrentUser() async {
    User? user =
        _auth.currentUser;

    if (user == null) {
      return null;
    }

    await user.reload();

    return _auth.currentUser;
  }

  // ============================================================
  // CHECK USER SESSION
  // ============================================================

  Future<bool> checkSession() async {
    return _auth.currentUser != null;
  }

  // ============================================================
  // GET USER DATA FROM FIRESTORE
  // ============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>>
  getUserData() async {
    final User? user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No user is currently logged in.',
      );
    }

    return await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
  }

  // ============================================================
  // GET USER DATA BY UID
  // ============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>>
  getUserById(String uid) async {
    return await _firestore
        .collection('users')
        .doc(uid)
        .get();
  }

  // ============================================================
  // SAVE / UPDATE USER DATA
  // ============================================================

  Future<void> saveUserData({
    required String uid,
    String? name,
    String? email,
    String? phone,
    String? provider,
    String? photoUrl,
    bool? isAnonymous,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(
      {
        'uid': uid,

        if (name != null)
          'name': name,

        if (email != null)
          'email': email,

        if (phone != null)
          'phone': phone,

        if (provider != null)
          'provider': provider,

        if (photoUrl != null)
          'photoUrl': photoUrl,

        if (isAnonymous != null)
          'isAnonymous': isAnonymous,

        'lastLoginAt':
        FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  // ============================================================
  // UPDATE USER NAME
  // ============================================================

  Future<void> updateUserName(
      String name,
      ) async {
    final User? user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No user is currently logged in.',
      );
    }

    await user.updateDisplayName(
      name.trim(),
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(
      {
        'name': name.trim(),
      },
      SetOptions(merge: true),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      // Firebase logout
      await _auth.signOut();

      // Google logout
      try {
        final GoogleSignIn googleSignIn =
            GoogleSignIn.instance;

        await googleSignIn.signOut();
      } catch (_) {
        // Ignore Google logout error
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // ============================================================
  // DELETE CURRENT ACCOUNT
  // ============================================================

  Future<void> deleteAccount() async {
    final User? user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No user is currently logged in.',
      );
    }

    final String uid = user.uid;

    // Delete Firestore user document
    await _firestore
        .collection('users')
        .doc(uid)
        .delete();

    // Delete Firebase Auth account
    await user.delete();
  }
}