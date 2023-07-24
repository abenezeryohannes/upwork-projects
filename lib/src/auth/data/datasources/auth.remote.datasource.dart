import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/network/api.dart';
import '../../domain/entities/i.firebase.entity.dart';

@singleton
class AuthRemoteDataSource {
  late http.Client client;

  AuthRemoteDataSource({required this.client});

  Future<IFirebaseAuthEntity?>? verifyPhoneNumber(
      IFirebaseAuthEntity firebaseDto, bool resend) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: firebaseDto.country!.dial_code + firebaseDto.phoneNumber,
      verificationCompleted: (cred) => firebaseDto.onVerificationComplete(cred),
      verificationFailed: (exc) => {firebaseDto.onVerificationFailed(exc)},
      codeSent: (String verificationId, int? resendToken) {
        firebaseDto.verificationId = verificationId;
        firebaseDto.resendToken = resendToken;
        firebaseDto.onCodeSent(verificationId, resendToken);
      },
      // timeout: const Duration(seconds: 120),
      forceResendingToken: resend ? firebaseDto.resendToken : null,
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = firebaseDto.verificationId;
        firebaseDto.onCodeAutoRetrievalTimeout(verificationId);
      },
    );
    return firebaseDto;
  }

  Future<IFirebaseAuthEntity?>? confirmPhoneConfirmationCode(
      IFirebaseAuthEntity firebaseDto) async {
    if (firebaseDto.verificationId.isEmpty) return null;

    firebaseDto.phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: firebaseDto.verificationId,
        smsCode: firebaseDto.confirmationCode);

    UserCredential cred = await FirebaseAuth.instance
        .signInWithCredential(firebaseDto.phoneAuthCredential!);

    firebaseDto.credential = cred.credential;
    firebaseDto.user = cred.user;
    return firebaseDto;
  }

  Future<bool?>? signOut(IFirebaseAuthEntity firebaseDto) async {
    if (firebaseDto.user == null) return true;
    await FirebaseAuth.instance.signOut();
    return FirebaseAuth.instance.currentUser == null;
  }

  Future<String?> getToken() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return null;
    }
    String res = 'https://hood.pragathi.business/session/token';
    Uri url = Uri.parse(res).replace();
    http.Response response = await client.get(url,
        headers: Api.getHeader('',
            firebaseID: FirebaseAuth.instance.currentUser?.uid));

    switch (response.statusCode) {
      case 200:
        return response.body;
      default:
        throw UnExpectedException(message: response.body);
    }
  }
}
