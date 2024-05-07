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

const String kGithubUrl = 'https://github.com/TolyFx/toly_ui';
const String kJuejinUrl = 'https://juejin.cn/user/149189281194766';
const String kBlibliUrl = 'https://space.bilibili.com/390457600';
const String kRxLayoutUrl = '/widgets/basic/layout';
const String kFxGithubUrl = 'https://github.com/TolyFx/fx';
const String kBeiAnUrl = 'https://beian.miit.gov.cn';
const String kWanBeiAnUrl = 'http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=34010202600392';