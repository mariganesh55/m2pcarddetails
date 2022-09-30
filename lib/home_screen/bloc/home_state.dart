import 'package:m2pcarddetails/utils/base_equitable.dart';

class HomeState extends BaseEquatable {}

class HomeInitialState extends HomeState {}

class HomeloadingState extends HomeState {}

class HomeLoadedState extends HomeState {}

class HomeErrorState extends HomeState {
  String error;
  HomeErrorState(this.error);
}

class HomeConformOtpAlertState extends HomeState {}

class HomeCustomDialogState extends HomeState {}

class HomeTemperaryBlockCustomDialogState extends HomeState {}

class HomePermanantBlockCustomDialogState extends HomeState {}

class HomeTemperaryUnBlockCustomDialogState extends HomeState {}

class HomePermanantUnBlockCustomDialogState extends HomeState {}

class HomeCardLockCustomDialogState extends HomeState {
  String cardPreference;
  HomeCardLockCustomDialogState(this.cardPreference);
}

class HomeCardUnLockCustomDialogState extends HomeState {
  String cardPreference;
  HomeCardUnLockCustomDialogState(this.cardPreference);
}

class HomePeramanantBlockAlertState extends HomeState {}

class HomeTemperaryBlockAlertState extends HomeState {}

class HomePeramanantBlockOtpVerificationState extends HomeState {}

class HomeTemperaryBlockOtpVerificationState extends HomeState {}

class HomePeramanantUnBlockOtpVerificationState extends HomeState {}

class HomeTemperaryUnBlockOtpVerificationState extends HomeState {}

class HomeSecretKeyState extends HomeState {}
