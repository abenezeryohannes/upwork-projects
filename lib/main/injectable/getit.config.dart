// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i7;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i11;
import 'package:rnginfra/main/injectable/external.package.injection.dart'
    as _i3;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import '../../src/auth/data/datasources/auth.local.datasource.dart' as _i8;
import '../../src/auth/data/datasources/auth.remote.datasource.dart' as _i9;
import '../../src/auth/data/respositories/auth.repository.dart' as _i17;
import '../../src/auth/domain/respositories/i.auth.repository.dart' as _i16;
import '../../src/auth/domain/usecases/confirm.phone.confirmation.code.dart'
    as _i26;
import '../../src/auth/domain/usecases/resend.phone.confirmation.code.dart'
    as _i21;
import '../../src/auth/domain/usecases/sign.out.dart' as _i22;
import '../../src/auth/domain/usecases/verify.phone.dart' as _i23;
import '../../src/auth/presentation/bloc/auth.state.bloc.dart' as _i41;
import '../../src/core/network/network.info.dart' as _i10;
import '../../src/guards/activity/data/datasources/activity.local.datasource.dart'
    as _i4;
import '../../src/guards/activity/data/datasources/activity.remote.datasource.dart'
    as _i6;
import '../../src/guards/activity/data/repositories/activity.repository.dart'
    as _i15;
import '../../src/guards/activity/domain/repositories/i.activities.repository.dart'
    as _i14;
import '../../src/guards/activity/domain/usecases/add.staff.attendance.usecase.dart'
    as _i25;
import '../../src/guards/activity/domain/usecases/edit.staff.attendance.usecase.dart'
    as _i29;
import '../../src/guards/activity/domain/usecases/get.activity.types.usecase.dart'
    as _i30;
import '../../src/guards/activity/domain/usecases/get.guests.activities.usecase.dart'
    as _i31;
import '../../src/guards/activity/domain/usecases/get.guests.usecase.dart'
    as _i32;
import '../../src/guards/activity/domain/usecases/get.staffs.activities.usecase.dart'
    as _i33;
import '../../src/guards/activity/domain/usecases/get.staffs.usecase.dart'
    as _i34;
import '../../src/guards/activity/presentation/guests/bloc/guest_activity_bloc.dart'
    as _i35;
import '../../src/guards/activity/presentation/new_activity/controller/add.activity.controller.dart'
    as _i39;
import '../../src/guards/activity/presentation/staffs/bloc/staff_activity_bloc.dart'
    as _i38;
import '../../src/guards/activity/presentation/staffs/controllers/add.staff.attendance.controller.dart'
    as _i40;
import '../../src/guards/activity/presentation/staffs/controllers/edit.staff.attendance.controller.dart'
    as _i42;
import '../../src/guards/patroll/data/datasources/patroll.local.data.source.dart'
    as _i12;
import '../../src/guards/patroll/data/datasources/patroll.remote.data.source.dart'
    as _i13;
import '../../src/guards/patroll/data/repositories/patroll.repository.dart'
    as _i19;
import '../../src/guards/patroll/domain/repositories/i.patroll.repository.dart'
    as _i18;
import '../../src/guards/patroll/domain/usecases/add.patroll.usecase.dart'
    as _i24;
import '../../src/guards/patroll/domain/usecases/delete.patroll.usecase.dart'
    as _i27;
import '../../src/guards/patroll/domain/usecases/edit.patroll.usecase.dart'
    as _i28;
import '../../src/guards/patroll/domain/usecases/list.patroll.usecase.dart'
    as _i20;
import '../../src/guards/patroll/presentation/patrolls_list/bloc/patroll_bloc.dart'
    as _i36;
import '../../src/guards/patroll/presentation/scan_patrolls/controller/scan.patroll.controller.dart'
    as _i37;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    await _i3.ExternalPackageInjection().init(gh);
    gh.singleton<_i4.ActivityLocalDatasource>(
        _i4.ActivityLocalDatasource(cache: gh<_i5.SharedPreferences>()));
    gh.singleton<_i6.ActivityRemoteDatasource>(
        _i6.ActivityRemoteDatasource(client: gh<_i7.Client>()));
    gh.singleton<_i8.AuthLocalDataSource>(_i8.AuthLocalDataSource(
        sharedPreferences: gh<_i5.SharedPreferences>()));
    gh.singleton<_i9.AuthRemoteDataSource>(
        _i9.AuthRemoteDataSource(client: gh<_i7.Client>()));
    gh.singleton<_i10.INetworkInfo>(
        _i10.NetworkInfoImp(connectionChecker: gh<_i11.InternetConnection>()));
    gh.singleton<_i12.PatrollLocalDataSource>(
        _i12.PatrollLocalDataSource(cache: gh<_i5.SharedPreferences>()));
    gh.singleton<_i13.PatrollRemoteDataSource>(
        _i13.PatrollRemoteDataSource(client: gh<_i7.Client>()));
    gh.singleton<_i14.IActivityRepository>(_i15.ActivityRepository(
      networkInfo: gh<_i10.INetworkInfo>(),
      remoteDataSource: gh<_i6.ActivityRemoteDatasource>(),
      localDataSource: gh<_i4.ActivityLocalDatasource>(),
    ));
    gh.singleton<_i16.IAuthRepository>(_i17.AuthRepository(
      networkInfo: gh<_i10.INetworkInfo>(),
      authRemoteDataSource: gh<_i9.AuthRemoteDataSource>(),
      authLocalDataSource: gh<_i8.AuthLocalDataSource>(),
    ));
    gh.singleton<_i18.IPatrollRepository>(_i19.PatrollRepository(
      networkInfo: gh<_i10.INetworkInfo>(),
      remoteDataSource: gh<_i13.PatrollRemoteDataSource>(),
      localDataSource: gh<_i12.PatrollLocalDataSource>(),
    ));
    gh.singleton<_i20.ListPatrollUseCase>(_i20.ListPatrollUseCase(
        patrollRepository: gh<_i18.IPatrollRepository>()));
    gh.singleton<_i21.ResendPhoneConfirmationCode>(
        _i21.ResendPhoneConfirmationCode(
            signInRepository: gh<_i16.IAuthRepository>()));
    gh.singleton<_i22.SignOut>(
        _i22.SignOut(signInRepository: gh<_i16.IAuthRepository>()));
    gh.singleton<_i23.VerifyPhoneNumber>(
        _i23.VerifyPhoneNumber(signInRepository: gh<_i16.IAuthRepository>()));
    gh.singleton<_i24.AddPatrollUseCase>(_i24.AddPatrollUseCase(
        patrollRepository: gh<_i18.IPatrollRepository>()));
    gh.singleton<_i25.AddStaffAttendanceUseCase>(
        _i25.AddStaffAttendanceUseCase(repo: gh<_i14.IActivityRepository>()));
    gh.singleton<_i26.ConfirmPhoneConfirmationCode>(
        _i26.ConfirmPhoneConfirmationCode(
            signInRepository: gh<_i16.IAuthRepository>()));
    gh.singleton<_i27.DeletePatrollUseCase>(_i27.DeletePatrollUseCase(
        patrollRepository: gh<_i18.IPatrollRepository>()));
    gh.singleton<_i28.EditPatrollUseCase>(_i28.EditPatrollUseCase(
        patrollRepository: gh<_i18.IPatrollRepository>()));
    gh.singleton<_i29.EditStaffAttendanceUseCase>(
        _i29.EditStaffAttendanceUseCase(repo: gh<_i14.IActivityRepository>()));
    gh.singleton<_i30.GetActivityTypesUseCase>(
        _i30.GetActivityTypesUseCase(repo: gh<_i14.IActivityRepository>()));
    gh.singleton<_i31.GetGuestsActivitiesUseCase>(
        _i31.GetGuestsActivitiesUseCase(repo: gh<_i14.IActivityRepository>()));
    gh.singleton<_i32.GetGuestsUseCase>(
        _i32.GetGuestsUseCase(repo: gh<_i14.IActivityRepository>()));
    gh.singleton<_i33.GetStaffsActivityUseCase>(
        _i33.GetStaffsActivityUseCase(repo: gh<_i14.IActivityRepository>()));
    gh.singleton<_i34.GetStaffsUseCase>(
        _i34.GetStaffsUseCase(repo: gh<_i14.IActivityRepository>()));
    gh.factory<_i35.GuestActivityBloc>(
        () => _i35.GuestActivityBloc(gh<_i31.GetGuestsActivitiesUseCase>()));
    gh.factory<_i36.PatrollBloc>(() => _i36.PatrollBloc(
          gh<_i24.AddPatrollUseCase>(),
          gh<_i28.EditPatrollUseCase>(),
          gh<_i20.ListPatrollUseCase>(),
          gh<_i27.DeletePatrollUseCase>(),
        ));
    gh.factory<_i37.ScanPatrollController>(() =>
        _i37.ScanPatrollController(useCase: gh<_i24.AddPatrollUseCase>()));
    gh.factory<_i38.StaffActivityBloc>(
        () => _i38.StaffActivityBloc(gh<_i33.GetStaffsActivityUseCase>()));
    gh.singleton<_i39.AddActivityController>(_i39.AddActivityController(
      getActivityTypesUseCase: gh<_i30.GetActivityTypesUseCase>(),
      getStaffsUseCase: gh<_i34.GetStaffsUseCase>(),
      getGuestsUseCase: gh<_i32.GetGuestsUseCase>(),
    ));
    gh.factory<_i40.AddStaffAttendanceController>(
        () => _i40.AddStaffAttendanceController(
              addStaffAttendanceUseCase: gh<_i25.AddStaffAttendanceUseCase>(),
              getStaffsUseCase: gh<_i34.GetStaffsUseCase>(),
            ));
    gh.singleton<_i41.AuthStateBloc>(_i41.AuthStateBloc(
      verifyPhoneNumber: gh<_i23.VerifyPhoneNumber>(),
      resendPhoneConfirmationCode: gh<_i21.ResendPhoneConfirmationCode>(),
      signOut: gh<_i22.SignOut>(),
      confirmPhoneConfirmationCode: gh<_i26.ConfirmPhoneConfirmationCode>(),
    ));
    gh.factory<_i42.EditStaffAttendanceController>(() =>
        _i42.EditStaffAttendanceController(
            editStaffAttendanceUseCase: gh<_i29.EditStaffAttendanceUseCase>()));
    return this;
  }
}
