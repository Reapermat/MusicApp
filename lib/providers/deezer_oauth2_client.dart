import 'package:meta/meta.dart';
import 'package:oauth2_client/oauth2_client.dart';

class DeezerOAuth2Client extends OAuth2Client {
  // to not really needed
  DeezerOAuth2Client(
      {@required String redirectUri,
      @required String customUriScheme,
      @required String appId,
      @required String appSecret,
      @required String code})
      : super(
            authorizeUrl:
                'https://connect.deezer.com/oauth/access_token.php?app_id=$appId&secret=$appSecret&code=$code',
            tokenUrl:
                'https://connect.deezer.com/oauth/access_token.php?app_id=$appId&secret=$appSecret&code=$code',
            // revo
            redirectUri: redirectUri,
            customUriScheme: customUriScheme) {
    // this.accessTokenRequestHeaders = {'Accept': 'application/json'};
  }
}
