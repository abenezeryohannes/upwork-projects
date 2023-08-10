import 'package:dartz/dartz.dart';
import 'package:linko/src/domain/chat/entities/chat.entity.dart';
import 'package:linko/src/domain/company/entities/company.entity.dart';

import '../../../appcore/dtos/wrapper.dto.dart';
import '../../../appcore/errors/failure.dart';

abstract class IChatRepository {
  Future<Either<Failure, WrapperDto<ChatEntity>>?>? findAll(
      {int? id, int? limit, int? page});

  Future<Either<Failure, WrapperDto<CompanyEntity>>?>? findAllCompaniesWithId(
      {int? id, int? limit, int? page, required List<int> ids});

  Future<Either<Failure, WrapperDto>?>? clearAll();
}