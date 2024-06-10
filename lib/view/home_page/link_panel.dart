import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolyui/tolyui.dart';

import '../../app/logic/actions/navigation.dart';

class LinkPanel extends StatelessWidget {
  final bool isDense;

  const LinkPanel({super.key, this.isDense = false});

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(fontSize: 20, color: Color(0xff5d5d5f), fontWeight: FontWeight.bold);
    // TextStyle style=  TextStyle(fontSize: 20,color: Colors.white);
    TextStyle contentStyle = TextStyle(fontSize: 14, color: Colors.grey, fontFamily: '黑体');
    return DefaultTextStyle(
      style: contentStyle,
      child: ColoredBox(
        color: Colors.transparent,
        child: SizedBox(
          width: double.maxFinite,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: isDense ? 24 : 48),
              child: Wrap(
                spacing: 64,
                alignment: WrapAlignment.center,
                // crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 24,
                children: [
                  Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        '链接',
                        style: style,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TolyLink(href: kGithubUrl, text: 'Github', onTap: jumpUrl),
                      TolyLink(href: kGithubUrl, text: 'pub', onTap: jumpUrl),
                      TolyLink(href: kGithubUrl, text: '更新日志', onTap: jumpUrl),
                      TolyLink(href: kGithubUrl, text: '常见问题', onTap: jumpUrl),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        '讨论区',
                        style: style,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TolyLink(href: kGithubUrl, text: '建议反馈', onTap: jumpUrl),
                      TolyLink(href: kGithubUrl, text: 'QQ 群聊', onTap: jumpUrl),
                      TolyLink(href: kGithubUrl, text: '参与贡献', onTap: jumpUrl),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        '资源链接',
                        style: style,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TolyLink(
                        href: kJuejinUrl,
                        text: '掘金社区',
                        onTap: jumpUrl,
                        lineType: LineType.always,
                      ),
                      TolyLink(
                        href: kBlibliUrl,
                        text: '哔哩哔哩',
                        onTap: jumpUrl,
                        lineType: LineType.always,
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        '联系我',
                        style: style,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TolyLink(href: '/sponsor', text: '邮箱', onTap: context.go),
                      TolyLink(href: '/sponsor', text: '微信', onTap: context.go),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
