import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/core/network/network_info.dart';
import 'package:notes_app/features/bussiness/repositories/firebase_repository.dart';
import 'package:notes_app/features/bussiness/usecases/add_note_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/delete_note_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/get_create_current_user.dart';
import 'package:notes_app/features/bussiness/usecases/get_current_uid.dart';
import 'package:notes_app/features/bussiness/usecases/get_notes_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/is_sign_in_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/sign_in_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/sign_out_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/sign_up_usecase.dart';
import 'package:notes_app/features/bussiness/usecases/update_note_usecase.dart';
import 'package:notes_app/features/data/local_database/local_database_repository.dart';
import 'package:notes_app/features/data/local_database/local_database_repositoryi_impl.dart';
import 'package:notes_app/features/data/model/note_model.dart';
import 'package:notes_app/features/data/remote/firebase_remote_data_source.dart';
import 'package:notes_app/features/data/remote/firebase_remote_data_source_impl.dart';
import 'package:notes_app/features/data/repositories/firebase_repository_impl.dart';
import 'package:notes_app/features/presentation/bloc/app_auth_bloc/app_auth_bloc.dart';
import 'package:notes_app/features/presentation/bloc/note_bloc/note_bloc.dart';
import 'package:notes_app/features/presentation/bloc/user_bloc/user_bloc.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  
// AuthBloc
sl.registerFactory<AppAuthBloc>(() => AppAuthBloc(
      isSignInUsecase: sl(),
      getCurrentUid: sl(),
      signOutUsecase: sl(),
    ));

// UserBloc
sl.registerFactory<UserBloc>(() => UserBloc(
      signInUsecase: sl(),
      signUpUsecase: sl(),
      getCreateCurrentUserUsecase: sl(),
    ));

// NoteBloc
sl.registerFactory<NoteBloc>(() => NoteBloc(
      addNoteUseCase: sl(),
      deleteNoteUseCase: sl(),
      updateNoteUsecase: sl(),
      getNotesUsecase: sl(),
    ));


  //useCase
  sl.registerLazySingleton<AddNoteUseCase>(
      () => AddNoteUseCase(repository: sl.call()));
  sl.registerLazySingleton<DeleteNoteUseCase>(
      () => DeleteNoteUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCreateCurrentUserUsecase>(
      () => GetCreateCurrentUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUid>(
      () => GetCurrentUid(repository: sl.call()));
  sl.registerLazySingleton<GetNotesUsecase>(
      () => GetNotesUsecase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUsecase>(
      () => IsSignInUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignInUsecase>(
      () => SignInUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUsecase>(
      () => SignOutUsecase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUsecase>(
      () => SignUpUsecase(repository: sl.call()));
  sl.registerLazySingleton<UpdateNoteUsecase>(
      () => UpdateNoteUsecase(repository: sl.call()));

  //repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call(), localDatabaseRepository: sl.call(), networkInfo: sl.call()));

  //data source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(auth: sl.call(), firestore: sl.call()));
  sl.registerLazySingleton<LocalDatabaseRepository>(() =>
      LocalDatabaseRepositoryiImpl(noteBox: sl.call()));

  //External
  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>('notesBox');
  final box = Hive.box<NoteModel>('notesBox');


  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => fireStore);
  sl.registerLazySingleton(() => box);
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: Connectivity()),
  );
}

