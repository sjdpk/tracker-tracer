// This page defines the dependency injection setup using GetIt for the
// authentication feature of the app, including registering HTTP client,
// bloc, use case, repository, and data source instances.

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'src/features/tracker/data/datasource/remote/tracker_data_source.dart';
import 'src/features/tracker/data/repository/tracker_repo_impl.dart';
import 'src/features/tracker/domain/repository/tracker_repo.dart';
import 'src/features/tracker/domain/usecase/tracker_usecase.dart';
import 'src/features/tracker/presentation/bloc/tracker/tracker_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // external
  sl.registerLazySingleton(() => http.Client());
  // ============ BLOCS ============
  sl.registerFactory(() => TrackerBloc(sl()));

  // ============ USECASES ============
  sl.registerLazySingleton(() => TrackerUseCase(sl()));

  // ============ REPOSITORIES ============
  sl.registerLazySingleton<TrackerRepository>(() => TrackerRepositoryImpl(sl()));

  // ============ REMOTE DATASOURCES ============
  sl.registerLazySingleton<RemoteTrackerDataSource>(() => RemoteTrackerDataSourceImpl(sl()));
}
