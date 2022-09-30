import 'package:m2pcarddetails/utils/base_equitable.dart';

class HomeEvent extends BaseEquatable {}

class HomeInitialEvent extends HomeEvent {}

class HomeEnterVerificationCodeAlertEvent extends HomeEvent {}

class HomePermanantBlockOtpVerificationEvent extends HomeEvent {}

class HomeTemperaryBlockOtpVerificationEvent extends HomeEvent {}

class HomePermanantUnBlockOtpVerificationEvent extends HomeEvent {}

class HomeTemperaryUnBlockOtpVerificationEvent extends HomeEvent {}

class HomeCustomDialogEvent extends HomeEvent {}

class HomePermanantBlockCustomDialogEvent extends HomeEvent {}

class HomeTemperaryBlockCustomDialogEvent extends HomeEvent {}

class HomePermanantUnBlockCustomDialogEvent extends HomeEvent {}

class HomeTemperaryUnBlockCustomDialogEvent extends HomeEvent {}

class HomeCardLockCustomDialogEvent extends HomeEvent {
  String cardPreference;
  HomeCardLockCustomDialogEvent(this.cardPreference);
}

class HomeCardUnLockCustomDialogEvent extends HomeEvent {
  String cardPreference;
  HomeCardUnLockCustomDialogEvent(this.cardPreference);
}

class HomePremanantBlockAlertEvent extends HomeEvent {}

class HomeTemperaryBlockAlertEvent extends HomeEvent {}

class HomeCardDetailDecryptEvent extends HomeEvent {}
