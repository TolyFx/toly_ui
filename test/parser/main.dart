import 'dart:convert';

import 'package:toly_ui/view/sponsor/sponsor_wall.dart';

void main(){
  List<SponsorItem> list = [SponsorItem(
    sponsorRecord: SponsorRecord(
        money: 20.0,
        name: "小麦穗",
        info: '寄语:大佬',
        date: '2024-04-15'),
  ),
    SponsorItem(
      sponsorRecord: SponsorRecord(
          money: 6.66,
          name: "*泽",
          info: '寄语:入股 TolyUI',
          date: '2024-04-15'),
    ),
    SponsorItem(
      sponsorRecord: SponsorRecord(
          money: 5.0,
          name: "LH",
          info: '寄语:支持一下',
          date: '2024-04-15'),
    ),
    SponsorItem(
      sponsorRecord: SponsorRecord(
          money: 8.88,
          name: "**齐",
          info: '寄语:支持一下',
          date: '2024-04-15'),
    ),
    SponsorItem(
      sponsorRecord: SponsorRecord(
          money: 6.66,
          name: "**平",
          info: '寄语:支持一下',
          date: '2024-04-15'),
    ),];
  String output= json.encode(list.map((e) => e.sponsorRecord).toList());
  print(output);
}