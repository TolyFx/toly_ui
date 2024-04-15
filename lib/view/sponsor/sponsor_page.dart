import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SponsorPage extends StatelessWidget {
  const SponsorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 128,
                  actions: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    //   child: Text('赞助墙'),
                    // ),
                  ],
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('赞助项目',style: TextStyle(fontSize: 32),),
                      const SizedBox(height: 8,),
                      Text(
                        '如果项目对您有所帮助, 可以通过赞赏支持我的创作',
                        style: TextStyle(
                            fontSize: 14, color: Color(0xff606266),fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '商务合作，请通过 1981462002@qq.com 联系我。',
                        style: TextStyle(
                            fontSize: 14, color: Color(0xff606266),fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: '支付宝',
                      ),
                      Tab(
                        text: '微信1',
                      ),
                      Tab(
                        text: '微信2',
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: TabBarView(
                          children: [
                            Image.asset(
                              'assets/images/coffee_zfb.webp',
                            ),
                            Image.asset('assets/images/coffee_wx.webp'),
                            Image.asset('assets/images/coffee_wx_ac.webp'),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 54,)
                  ],
                )),
          ),
        ),
        VerticalDivider(),
        SizedBox(
          width: 240,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text('赞助墙',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              ),
              Text('赞助时，可以写下称谓和寄语\n赞助信息将展示在赞助墙上:',
                // textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 12,color: Colors.grey
              ),),
            ],
          ),
        )
      ],
    );
  }
}
//          Text('TolyUI 为开源的免费项目:\n'
//               'https://github.com/TolyFx/toly_ui\n'
//               '。'),
