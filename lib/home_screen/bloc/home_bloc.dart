import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_event.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_state.dart';
import 'package:m2pcarddetails/http/model/bit_url_response/bit_url_response.dart';
import 'package:m2pcarddetails/http/repository/home_repository.dart';
import 'package:m2pcarddetails/http/response/card_detail_response.dart';
import 'package:m2pcarddetails/http/response/generic_response.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/constants.dart';
import 'package:m2pcarddetails/utils/string_resource.dart';
import 'package:m2pcarddetails/utils/validator.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState());

  TextEditingController dobTextController = TextEditingController();
  TextEditingController enterPinTextController = TextEditingController();
  TextEditingController conformPinTextController = TextEditingController();
  TextEditingController securityCodeTextController = TextEditingController();

  TextEditingController atmLimitTextController = TextEditingController();
  TextEditingController posLimitTextController = TextEditingController();
  TextEditingController ecomLimitTextController = TextEditingController();

  bool blockTemporary = false;
  bool blockPermanant = false;

  bool atmTransactions = false;
  bool posTransactions = false;
  bool ecomTransactions = false;
  bool internationalTransactions = false;
  bool contactlessTransactions = false;

  bool atmTransactionsLimit = false;
  bool posTransactionsLimit = false;
  bool ecomTransactionsLimit = false;

  String atmLimit = "";
  String posLimit = "";
  String ecomlimit = "";

  late String publicKeyString;
  late String privateKeyString;
  late String secretKeyString;
  late String serverPublicKey;
  late String deviceId;

  late String cardDetailMessage;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeInitialEvent) {
      yield HomeInitialState();

      GenericResponse? depairResponse = await HomeRepository.depairPublicKey();

      if (depairResponse != null) {
        if (depairResponse.result) {
          AppUtils.showToast("Depaired Success");
        } else {}
      }

      GenericResponse? response =
          await HomeRepository.pairPublicKey(publicKeyString, deviceId);
      if (response != null) {
        if (response.result) {
          AppUtils.showToast("Paired Success");
        } else {
          AppUtils.showErrorToast("Failure");
        }
      }

      BitUrlResponse? generateBitUrlResponse =
          await HomeRepository.generateBitUrl();
      if (generateBitUrlResponse != null) {
        if (generateBitUrlResponse.result != null) {
          Constants.dynamicUrl = generateBitUrlResponse.result?.url ?? '';
          Constants.serverPublicKey =
              generateBitUrlResponse.result?.publicKey ?? '';

          HomeRepository.fetchTenantConfig();

          AppUtils.showToast("Dynamic url Success");
        } else {
          AppUtils.showErrorToast("Dynamic url Failure");
        }
      }

      CardDetailResponse? cardDetailResponse =
          await HomeRepository.getCardDetails();
      if (cardDetailResponse != null) {
        if (cardDetailResponse.result != null) {
          cardDetailMessage = cardDetailResponse.result!.detailMessage;
          serverPublicKey = cardDetailResponse.result!.publicKey;
          yield HomeSecretKeyState();
        } else {
          AppUtils.showErrorToast("Failure");
        }
      }
      yield HomeLoadedState();
    }

    if (event is HomeCardDetailDecryptEvent) {
      String decrypted =
          AppUtils.decryptAES(cardDetailMessage, secretKeyString);
      print(decrypted);
    }

    if (event is HomeEnterVerificationCodeAlertEvent) {
      final dobStatus = Validator.validate(dobTextController.text.trim(),
          rules: ['required']);
      if (!dobStatus.status) {
        yield HomeErrorState(StringResource.dob + dobStatus.error!);
        return;
      }

      final enterPinStatus = Validator.validate(
          enterPinTextController.text.trim(),
          rules: ['required']);
      if (!enterPinStatus.status) {
        yield HomeErrorState(StringResource.pin + enterPinStatus.error!);
        return;
      }

      final conformPinStatus = Validator.validate(
          conformPinTextController.text.trim(),
          rules: ['required']);
      if (!conformPinStatus.status) {
        yield HomeErrorState(
            StringResource.conformPIN + conformPinStatus.error!);
        return;
      }

      if (enterPinTextController.text.trim() !=
          conformPinTextController.text.trim()) {
        yield HomeErrorState("PIN Mismatch");
        return;
      }

      yield HomeConformOtpAlertState();
    }

    if (event is HomeCustomDialogEvent) {
      yield HomeCustomDialogState();
    }

    if (event is HomePremanantBlockAlertEvent) {
      yield HomePeramanantBlockAlertState();
    }

    if (event is HomeTemperaryBlockAlertEvent) {
      yield HomeTemperaryBlockAlertState();
    }
    if (event is HomePermanantBlockCustomDialogEvent) {
      yield HomePermanantBlockCustomDialogState();
    }

    if (event is HomeTemperaryBlockCustomDialogEvent) {
      yield HomeTemperaryBlockCustomDialogState();
    }

    if (event is HomeTemperaryBlockOtpVerificationEvent) {
      yield HomeTemperaryBlockOtpVerificationState();
    }

    if (event is HomePermanantBlockOtpVerificationEvent) {
      yield HomePeramanantBlockOtpVerificationState();
    }

    if (event is HomeTemperaryUnBlockOtpVerificationEvent) {
      yield HomeTemperaryUnBlockOtpVerificationState();
    }

    if (event is HomePermanantUnBlockOtpVerificationEvent) {
      yield HomePeramanantUnBlockOtpVerificationState();
    }

    if (event is HomeTemperaryUnBlockCustomDialogEvent) {
      yield HomeTemperaryUnBlockCustomDialogState();
    }

    if (event is HomePermanantUnBlockCustomDialogEvent) {
      yield HomePermanantUnBlockCustomDialogState();
    }
    if (event is HomeCardUnLockCustomDialogEvent) {
      yield HomeCardUnLockCustomDialogState(event.cardPreference);
    }

    if (event is HomeCardLockCustomDialogEvent) {
      yield HomeCardLockCustomDialogState(event.cardPreference);
    }
  }
}
