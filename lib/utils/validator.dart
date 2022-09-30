class Validator {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static ValidationState validate(String input, {required List<String> rules}) {
    for (var i = 0; i < rules.length; i++) {
      final String rule = rules[i];
      if (rule == "required") {
        if (input == null || input.trim() == "") {
          // ignore: avoid_redundant_argument_values
          return ValidationState(status: false, error: " is required");
        }
      }

      if (rule == "email") {
        if (input == null || input == "") {
          // ignore: avoid_redundant_argument_values
          return ValidationState(status: false, error: " is required");
        }
        if (!_emailRegExp.hasMatch(input)) {
          // ignore: avoid_redundant_argument_values
          return ValidationState(status: false, error: " format is invalid");
        }
      }

      if (rule.startsWith("min:")) {
        try {
          final int letterCount = int.tryParse(rule.replaceAll("min:", ""))!;
          if (input.length < letterCount) {
            return ValidationState(
                // ignore: avoid_redundant_argument_values
                status: false,
                error: " should be min $letterCount character long");
          }
        } catch (_) {
          // ignore: avoid_redundant_argument_values
          return ValidationState(status: false, error: " - $rule is incorrect");
        }
      }

      if (rule == "number_only") {
        final RegExp regex = RegExp(r"(\d+)");
        if (!regex.hasMatch(input)) {
          // ignore: avoid_redundant_argument_values
          return ValidationState(status: false, error: ' is not a number');
        }
      }

      if (rule == "mobile_number") {
        const String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        final RegExp regExp = RegExp(pattern);
        if (input.isEmpty) {
          return ValidationState(
              status: false, error: "Please enter mobile number");
        } else if (!regExp.hasMatch(input)) {
          return ValidationState(
              status: false, error: "Please enter valid mobile number");
        }
      }
    }

    return ValidationState(status: true);
  }
}

class ValidationState {
  bool status;
  String? error;

  ValidationState({this.status = false, this.error});
}
