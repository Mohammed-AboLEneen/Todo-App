import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/methods/google_auth.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitLoginState());

  static LoginCubit get(context) => BlocProvider.of(context);

  Future<void> signInWithGoogle() async {
    emit(LoadingLoginState());
    try {
      // Create a new credential
      final credential = await googleAuth();
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(SuccessLoginState());
    } catch (e) {
      emit(FailureLoginState('There is something wrong, try Again'));
    }
  }
}
