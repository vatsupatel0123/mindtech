import 'app_env.dart';

class AppUrl {
  static String MAIN_URL = Environment.apiUrl;

  static String IMG_URL = MAIN_URL+"storage/";
  static String BASE_URL = MAIN_URL+"api/";
  static String PRIVACY_POLICY_URL = MAIN_URL+"privacy-policy";
  static String TERMS_AND_CONDITIONS_URL = MAIN_URL+"terms-and-conditions";
  static const String LOGIN = "login";
  static const String REGISTER = "register";
  static const String VERIFY_OTP = "verifyotp";
  static const String RESEND_OTP = "resendotp";
  static const String CHECK_GOOGLEUSER = "checkgoogleuser";
  static const String GOOGLE_REGISTER = "register/google";
  static const String CHECK_USER = "checkuser";
  static const String UPDATE_PASSWORD = "updatepassword";
  static const String CHANGE_PASSWORD = "changepassword";
  static const String GET_HOMEDATA = "dashboard";
  static const String SAVE_MOOD = "savedailymood";
  static const String GET_APPOINTMENTS = "appointments";
  static const String SAVED_APPOINTMENT = "savedappointment";
  static const String GET_MOODS = "moods";
  static const String GET_NOTIFICATIONS = "notifications";
  static const String GET_EXPERTS = "experts";
  static const String SAVED_EXPERT_REVIEW = "savedReview";
  static const String GET_EXPERTS_SLOTS = "expertsavailablity";
  static const String GET_SUPPORT_DETAILS = "supportdetails";
  static const String GET_PROFILE_QUESTION = "profile/question";
  static const String SAVED_PROFILE_QUESTION = "profile/submitanswer";
  static const String UPDATE_PROFILE = "profile/update";
  static const String GET_EXPERT_APPOINTMENTS = "expertappointments";
  static const String CHANGE_APPOINTMENT_STATUS = "changeappointmentstatus";
}
