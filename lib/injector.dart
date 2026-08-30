import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin/presentation/screens/authentication/bloc/authentication_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'config/http_schema.dart';
import 'data/datasources/remote/http_client.dart';
import 'data/plugins/uuid_generator.dart';
import 'data/repositories/period_remote_repository.dart';
import 'data/repositories/period_summary_remote_repository.dart';
import 'data/repositories/remote/api_repository_impl.dart';
import 'data/repositories/transaction_remote_repository.dart';
import 'domain/controller/user_controller.dart';
import 'domain/repositories/period_repository.dart';
import 'domain/repositories/period_summary_repository.dart';
import 'domain/repositories/remote/api_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/streams/auth_stream.dart';
import 'external/plugins/http_client_impl.dart';
import 'external/plugins/uuid_generator_impl.dart';
import 'presentation/screens/home/bloc/home_bloc.dart';
import 'presentation/screens/period/bloc/period_bloc.dart';
import 'presentation/screens/transaction/bloc/transaction_bloc.dart';

final getIt = GetIt.instance;

abstract class Injector {
  Injector(this.getIt);

  late final GetIt getIt;

  void dispose();
}

final class InjectorImpl extends Injector {
  InjectorImpl._(super.getIt);

  static Future<Injector> initializeDependencies() async {
    final getIt = GetIt.instance;

    getIt
      /// Schemas---------------------------------------------------------------
      ..registerSingleton<HttpSchema>(const LocalSchema())
      /// Plugins---------------------------------------------------------------
      ..registerSingleton<UuidGenerator>(const UuidGeneratorImpl())
      ..registerSingleton<FirebaseAuth>(FirebaseAuth.instance)
      /// API Client------------------------------------------------------------
      ..registerSingleton<HttpClient>(
        HttpClientImpl.initialize(getIt.get<HttpSchema>()),
      )
      /// Repository-----------------------------------------------------
      ..registerSingleton<ApiRepository>(
        ApiRepositoryImpl(getIt.get<HttpClient>(), getIt.get<HttpSchema>()),
      )
      ..registerSingleton<TransactionRepository>(
        TransactionRemoteRepository(FirebaseFirestore.instance),
      )
      ..registerSingleton<PeriodRepository>(
        PeriodRemoteRepository(FirebaseFirestore.instance),
      )
      ..registerSingleton<PeriodSummaryRepository>(
        PeriodSummaryRemoteRepository(FirebaseFirestore.instance),
      )
      /// Stream----------------------------------------------------------------
      ..registerSingleton<AuthStream>(AuthStream())
      /// Controllers-----------------------------------------------------------
      ..registerSingleton<UserController>(
        UserController(getIt.get<FirebaseAuth>()),
      )
      /// BLoC------------------------------------------------------------------
      ..registerSingleton<AuthenticationBloc>(
        AuthenticationBloc(getIt.get<AuthStream>()),
      )
      ..registerFactory<HomeBloc>(
        () => HomeBloc(
          getIt.get<TransactionRepository>(),
          getIt.get<PeriodSummaryRepository>(),
          getIt.get<UserController>(),
        ),
      )
      ..registerFactory<TransactionBloc>(
        () => TransactionBloc(
          getIt.get<TransactionRepository>(),
          getIt.get<PeriodSummaryRepository>(),
          getIt.get<UserController>(),
        ),
      )
      ..registerFactory<PeriodBloc>(
        () => PeriodBloc(
          getIt.get<PeriodRepository>(),
          getIt.get<UserController>(),
        ),
      );

    return InjectorImpl._(getIt);
  }

  @override
  void dispose() {
    Future.wait([]);
  }
}
