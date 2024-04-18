import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

void goHome(BuildContext context) {
  context.go('/home');
}

void jumpUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    // throw Exception('Could not launch $url');
  }
}

String kGithubUrl = 'https://github.com/TolyFx/toly_ui';
String kFxGithubUrl = 'https://github.com/TolyFx/fx';
String kBeiAnUrl = 'https://beian.miit.gov.cn';
String kWanBeiAnUrl = 'http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=34010202600392';