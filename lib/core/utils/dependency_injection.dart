import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/signup_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/get_conversations.dart';
import '../../features/chat/domain/usecases/get_messages.dart';
import '../../features/chat/domain/usecases/send_message.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/chat/presentation/bloc/message_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => AuthBloc(
        loginUser: sl(),
        signupUser: sl(),
        logoutUser: sl(),
        getCurrentUser: sl(),
      ));

  sl.registerFactory(() => ChatBloc(
        getConversations: sl(),
      ));

  sl.registerFactory(() => MessageBloc(
        getMessages: sl(),
        sendMessage: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SignupUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => GetConversations(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      firestore: sl(),
      firebaseAuth: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
