import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:rnginfra/src/auth/domain/entities/country.entity.dart';
import 'package:rnginfra/src/auth/domain/usecases/confirm.phone.confirmation.code.dart';
import 'package:rnginfra/src/auth/domain/entities/i.firebase.entity.dart';
import 'package:rnginfra/src/auth/domain/usecases/resend.phone.confirmation.code.dart';
import 'package:rnginfra/src/auth/domain/usecases/sign.out.dart';
import 'package:rnginfra/src/auth/domain/usecases/verify.phone.dart';
import 'package:rnginfra/src/core/utils/utils.dart';

import '../../../core/errors/failure.dart';

part 'auth.state.event.dart';
part 'auth.state.state.dart';

@singleton
class AuthStateBloc extends Bloc<AuthStateEvent, AuthStateState>
    implements IFirebaseAuthEntity {
  @override
  bool isNewUser = true;

  @override
  MyCountry? country;

  @override
  List<MyCountry> countries = [];

  @override
  PhoneAuthCredential? phoneAuthCredential;

  @override
  AuthCredential? credential;

  @override
  String phoneNumber = '';

  @override
  String confirmationCode = '';

  @override
  int? resendToken;

  @override
  User? user;

  @override
  String verificationId = '';

  @override
  void clone(IFirebaseAuthEntity f) {
    credential = f.credential;
    phoneNumber = f.phoneNumber;
    resendToken = f.resendToken;
    user = f.user;
    verificationId = f.verificationId;
  }

  @override
  Future<List<MyCountry>> getCountries() async {
    final jsonResult =
        jsonDecode(await Util.loadJsonAsset('assets/fixtures/countries.json'));
    return List<MyCountry>.from(
        jsonResult.map((model) => MyCountry.fromJson(model)));
  }

  AuthStateBloc({
    required VerifyPhoneNumber verifyPhoneNumber,
    required ResendPhoneConfirmationCode resendPhoneConfirmationCode,
    required SignOut signOut,
    required ConfirmPhoneConfirmationCode confirmPhoneConfirmationCode,
  }) : super(AuthStateInitial()) {
    //
    on<OnAuthInitialEvent>((event, emit) async {
      emit(AuthStateInitial());
    });
    on<OnCodeAutoRetrievalTimeout>((event, emit) async {});

    on<OnNotVerifiedEvent>((event, emit) async {
      countries = await getCountries();
      country = countries[Random().nextInt(countries.length - 1)];
      isNewUser = event.isNewUser;
      emit(NotVerifiedAuthState());
    });

    //
    // This SignIn event is to send user info to the actual server not firebase
    //
    on<OnSignInEvent>((event, emit) async {});

    on<OnVerficationComplete>((event, emit) async {
      emit(VerifiedAuthState(phoneAuthCredential: event.credential));
    });

    on<OnCodeSent>((event, emit) async {
      emit(CodeSentAuthState(
          verificationId: event.verificationId,
          resendToken: event.resendToken));
    });

    on<OnVerificationFailed>((event, emit) async {
      emit(VerificationFailedAuthState(
          failure: Failure(message: event.exception.message)));
    });

    on<OnVerifyEvent>((event, emit) async {
      emit(VerifiyingAuthState());
      phoneNumber = event.phoneNumber;

      if (country == null ||
          !GetUtils.isPhoneNumber(country!.dial_code + phoneNumber)) {
        emit(VerificationFailedAuthState(
            failure: Failure(message: ('Sorry, Not a valid phone number!'))));
        return;
      }
      final result = await verifyPhoneNumber(SignUpParam(firebaseDto: this));

      if (result == null) {
        return emit(VerificationFailedAuthState(failure: UnExpectedFailure()));
      }

      result.fold((l) => VerificationFailedAuthState(failure: l), (r) {
        clone(r);
      });
    });

    on<OnConfirmEvent>((event, emit) async {
      emit(ConfirmingAuthState());

      confirmationCode = event.code;

      if (event.code.length != 6) {
        emit(ConfirmationFailedAuthState(
            failure: Failure(
                message: 'Sorry, Confirmation code must be 6 digit long!')));
        return;
      }

      final result = await confirmPhoneConfirmationCode(
          ConfirmPhoneConfirmationCodeParam(firebaseDto: this));

      if (result == null) {
        emit(ConfirmationFailedAuthState(failure: UnExpectedFailure()));
      }

      result!.fold((l) => emit(ConfirmationFailedAuthState(failure: l)), (r) {
        clone(r);
        emit(ConfirmedAuthState(user: user!));
      });
    });

    on<OnConfirmedEvent>((event, emit) async {
      //emit signup
    });
  }

  //
  // Below function are used on the data layer to call methods to update the UI
  // Not recommended but since we are depending on firebase phone auth which is external library we dont have that much option
  // only methods below are used in the data layer to pass render information
  //

  @override
  void onCodeAutoRetrievalTimeout(String verificationId) {
    // print('onCodeAutoRetrievalTimeout: ' + verificationId);
    add(OnCodeAutoRetrievalTimeout(verificationId: verificationId));
  }

  @override
  Future<void> onCodeSent(String verificationId, int? resendToken) {
    // print(
    //     'onCodeSent: verificationID: $verificationId   resendToken: ${resendToken?.toString() ?? ''}');
    add(OnCodeSent(resendToken: resendToken, verificationId: verificationId));
    return Future.value(null);
  }

  @override
  void onVerificationComplete(PhoneAuthCredential credential) {
    // print('onVerificationComplete: ' + credential.toString());
    add(OnVerficationComplete(credential: credential));
  }

  @override
  void onVerificationFailed(FirebaseAuthException e) {
    // print('FirebaseAuthException: ' + (e.message).toString());
    add(OnVerificationFailed(exception: e));
  }

  @override
  void signOut() {
    phoneNumber = "";
    credential = null;
    phoneAuthCredential = null;
    country = null;
    user = null;
    add(OnAuthInitialEvent());
  }
}
