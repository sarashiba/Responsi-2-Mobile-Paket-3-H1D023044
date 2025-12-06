import 'package:responsi2mobile_paket3_h1d023044/helpers/user_info.dart';

class LogoutBloc {
  static Future logout() async {
    await UserInfo().logout();
  }
}