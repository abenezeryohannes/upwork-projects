import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:linko/src/appcore/errors/failure.dart';
import 'package:linko/src/appcore/usecases/usecase.dart';

import '../entities/i.firebase.entity.dart';
import '../respositories/i.auth.repository.dart';

@singleton
class SignOutUseCase
    implements UseCase<IFirebaseAuthEntity?, SignOutUseCaseParam> {
  late IAuthRepository signInRepository;
  SignOutUseCase({required this.signInRepository});

  @override
  Future<Either<Failure, IFirebaseAuthEntity?>?>? call(
      {required SignOutUseCaseParam param}) {
    return signInRepository.signOut(param.firebaseDto);
  }
}

class SignOutUseCaseParam extends Equatable {
  final IFirebaseAuthEntity? firebaseDto;

  const SignOutUseCaseParam({this.firebaseDto});

  @override
  List<Object?> get props => [firebaseDto];
}