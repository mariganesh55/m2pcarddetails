// ignore: public_member_api_docs
import 'package:bloc/bloc.dart';

class EchoBlocDelegate extends BlocObserver {
  // @override
  // // ignore: unnecessary_overrides
  // void onEvent(Bloc bloc, Object event) {
  //   super.onEvent(bloc, event);
  // }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    @override
    // ignore: unused_element
    void onError(Cubit bloc, Object error, StackTrace stacktrace) {
      super.onError(bloc, error, stacktrace);
    }
  }
}
