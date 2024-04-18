import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SponsorWall extends StatefulWidget {
  const SponsorWall({super.key});

  @override
  State<SponsorWall> createState() => _SponsorWallState();
}

class _SponsorWallState extends State<SponsorWall> {
  List<SponsorRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              '赞助墙',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '赞助时，可以写下称谓和寄语\n赞助信息将展示在赞助墙上:',
            // textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) =>
                  SponsorItem(sponsorRecord: _records[index]),
              itemCount: _records.length,
            ),
          )
        ],
      ),
    );
  }

  void _loadRecords() async {
    String src = await rootBundle.loadString('assets/data/sponsor.json');
    List data = jsonDecode(src) as List;
    setState(() {
      _records = data.map(SponsorRecord.fromMap).toList();
    });
  }
}

class SponsorRecord {
  final double money;
  final String info;
  final String name;
  final String? avatar;
  final String date;

  SponsorRecord({
    required this.money,
    required this.name,
    required this.info,
    this.avatar,
    required this.date,
  });

  factory SponsorRecord.fromMap(dynamic map) => SponsorRecord(
        money: map['money'],
        name: map['name'],
        info: map['info'],
        date: map['date'],
        avatar: map['avatar'],
      );

  Map<String, dynamic> toJson() => {
        "money": money,
        "name": name,
        "info": info,
        "date": date,
        "avatar": avatar,
      };
}

class SponsorItem extends StatelessWidget {
  final SponsorRecord sponsorRecord;

  const SponsorItem({super.key, required this.sponsorRecord});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Row(
        children: [
          Text('${sponsorRecord.name} '),
          Text('￥${sponsorRecord.money}',
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          Spacer(),
          Text(sponsorRecord.date,
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
      subtitle: Text(
        sponsorRecord.info,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

//          Text('TolyUI 为开源的免费项目:\n'
//               'https://github.com/TolyFx/toly_ui\n'
//               '。'),
