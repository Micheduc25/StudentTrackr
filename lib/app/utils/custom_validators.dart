import 'package:get/get.dart';

class CustomFormValidators {
  // Form input validators

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) return "This field is required";

    return null;
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) return "This field is required";

    if (value.length < 6) return "The username must be at least 6 characters";

    if (!GetUtils.isUsername(value)) {
      return "The username provided is not a valid";
    }

    return null;
  }

  static String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) return "This field is required";

    if (!GetUtils.isPhoneNumber(value)) {
      return "The phone number provided is not a valid";
    }

    return null;
  }

  static String? passwordValidator(String? value, [String? confirmPassword]) {
    if (value == null || value.isEmpty) return "This field is required";

    if (value.length < 6) return "The password must be at least 6 characters";

    if (GetUtils.isOneAKind(value) ||
        GetUtils.isNumericOnly(value) ||
        GetUtils.isAlphabetOnly(value)) {
      return "Your password is too weak. Mix letters, numbers and symbols";
    }

    if (confirmPassword != null && value != confirmPassword) {
      return "The two passwords don't match";
    }

    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) return "This field is required";

    if (!GetUtils.isEmail(value)) {
      return "The provided value is not a valid email address";
    }

    return null;
  }
}
