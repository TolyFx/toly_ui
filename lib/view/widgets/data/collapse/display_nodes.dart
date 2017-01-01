Map<String,dynamic> get displayNodes => {
  'CollapseDemo1': {
    'title': '基础用法',
    'desc': '通过 TolyCollapse 可以折叠和展开一个面板，并且过程中带有透明度和尺寸渐变的动画效果。可指定动画时长、动画曲线。自定义标题、面板内容：',
    'code': r'''class CollapseDemo1 extends StatelessWidget {
  const CollapseDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        display1(),
        const Divider(),
        display2(),
        const Divider(),
        display3(),
        const Divider(),
      ],
    );
  }

  Widget display1(){
    const String title = '《春》· 朱自清';
    const String content = """盼望着，盼望着，东风来了，春天的脚步近了。
一切都像刚睡醒的样子，欣欣然张开了眼。山朗润起来了，水涨起来了，太阳的脸红起来了。
小草偷偷地从土里钻出来，嫩嫩的，绿绿的。园子里，田野里，瞧去，一大片一大片满是的。坐着，躺着，打两个滚，踢几脚球，赛几趟跑，捉几回迷藏。风轻悄悄的，草绵软软的。
桃树、杏树、梨树，你不让我，我不让你，都开满了花赶趟儿。红的像火，粉的像霞，白的像雪。花里带着甜味，闭了眼，树上仿佛已经满是桃儿、杏儿、梨儿！花下成千成百的蜜蜂嗡嗡地闹着，大小的蝴蝶飞来飞去。野花遍地是：杂样儿，有名字的，没名字的，散在草丛里，像眼睛，像星星，还眨呀眨的。""";
    return const TolyCollapse(
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content:Text(content),
      duration: Duration(milliseconds: 400),
    );
  }

  Widget display2(){
    const String title = '《应龙》· 张风捷特烈';
    const String content = """一游小池两岁月，\n洗却凡世几闲尘。\n时逢雷霆风会雨，\n应乘扶摇化入云。""";
    return const TolyCollapse(
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      duration: Duration(milliseconds: 300),
    );
  }

  Widget display3(){
    const String title = '《朝花夕拾》· 鲁迅';
    const String content = """《朝花夕拾》原名《旧事重提》，是现代文学家鲁迅的散文集，收录鲁迅于1926年创作的10篇回忆性散文， 1928年由北京未名社出版，现编入《鲁迅全集》第2卷。
此文集作为“回忆的记事”，多侧面地反映了作者鲁迅青少年时期的生活，形象地反映了他的性格和志趣的形成经过。前七篇反映他童年时代在绍兴的家庭和私塾中的生活情景，后三篇叙述他从家乡到南京，又到日本留学，然后回国教书的经历；揭露了半殖民地半封建社会种种丑恶的不合理现象，同时反映了有抱负的青年知识分子在旧中国茫茫黑夜中，不畏艰险，寻找光明的困难历程，以及抒发了作者对往日亲友、师长的怀念之情。
文集以记事为主，饱含着浓烈的抒情气息，往往又夹以议论，做到了抒情、叙事和议论融为一体，优美和谐，朴实感人。作品富有诗情画意，又不时穿插着幽默和讽喻；形象生动，格调明朗，有强烈的感染力 。
    """;
    return const TolyCollapse(
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      duration: Duration(milliseconds: 600),
    );
  }
}'''
  },
  'CollapseDemo2': {
    'title': '灵活可定制化',
    'desc': '开发者通过 CollapseController 自主控制打开和关闭；标题如果想要感知动画和控制器，展开过程中自定义内容，可以通过 titleBuilder 构建标题，如下第二个案例，只有点击图标时才会展开/关闭。',
    'code': r'''class CollapseDemo2 extends StatefulWidget {
   const CollapseDemo2({super.key});

  @override
  State<CollapseDemo2> createState() => _CollapseDemo2State();
}

class _CollapseDemo2State extends State<CollapseDemo2> {
  final CollapseController ctrl = CollapseController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        display1(),
        const Divider(),
        display2(),
        const Divider(),
      ],
    );
  }

  Widget display1(){
    const String title = '《春》· 朱自清';
    const String content = """盼望着，盼望着，东风来了，春天的脚步近了。
一切都像刚睡醒的样子，欣欣然张开了眼。山朗润起来了，水涨起来了，太阳的脸红起来了。
小草偷偷地从土里钻出来，嫩嫩的，绿绿的。园子里，田野里，瞧去，一大片一大片满是的。坐着，躺着，打两个滚，踢几脚球，赛几趟跑，捉几回迷藏。风轻悄悄的，草绵软软的。
桃树、杏树、梨树，你不让我，我不让你，都开满了花赶趟儿。红的像火，粉的像霞，白的像雪。花里带着甜味，闭了眼，树上仿佛已经满是桃儿、杏儿、梨儿！花下成千成百的蜜蜂嗡嗡地闹着，大小的蝴蝶飞来飞去。野花遍地是：杂样儿，有名字的，没名字的，散在草丛里，像眼睛，像星星，还眨呀眨的。""";
    return  TolyCollapse(
      controller: ctrl,
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(content),
          ),
          Divider(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){
                ctrl.close();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('收起面板 ↑',style: TextStyle(color: Colors.blue),),
              ),
            ),
          )
        ],
      ),
      duration: Duration(milliseconds: 400),
    );
  }

  Widget display2(){
    const String title = '《应龙》· 张风捷特烈';
    const String content = """一游小池两岁月，\n洗却凡世几闲尘。\n时逢雷霆风会雨，\n应乘扶摇化入云。""";
    return  TolyCollapse(
      titleBuilder: _buildTitle,
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      duration: Duration(milliseconds: 600),
    );
  }
  
  Widget _buildTitle(BuildContext context, Animation<double> anima, CollapseController ctrl) {
    return Row(
      children: [
        Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: AnimatedBuilder(
              animation: anima,
              builder: (_, __) => Text(
                '《应龙》· 张风捷特烈',
                style: TextStyle(fontWeight: FontWeight.bold,color: Color.lerp(Colors.black, Colors.blue, Curves.ease.transform(anima.value))),
              ),
            ),
            )),
        Spacer(),
        GestureDetector(
            onTap: () async{
              await Clipboard.setData(ClipboardData(text: """一游小池两岁月，\n洗却凡世几闲尘。\n时逢雷霆风会雨，\n应乘扶摇化入云。"""));
              $message.success(message: '代码复制成功!');
            },
            child: const TolyTooltip(
                message: '复制代码',
                gap: 20,
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                child: Icon(Icons.copy_rounded, size: 20,color: Color(0xff828282),))),
        const SizedBox(width: 16,),

        TolyTooltip(
          message: '查看源码',
          gap: 20,
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
          child: GestureDetector(
            onTap: (){
              ctrl.toggle();
            },
            child: AnimatedBuilder(
                animation: anima,
                builder: (_, child) {
                  Color? color = Color.lerp(const Color(0xff828282), Colors.blue, Curves.ease.transform(anima.value));
                  return Transform.rotate(
                  angle: pi/2 * Curves.ease.transform(anima.value),
                  child: Icon(Icons.code,color: color,),
                );
                },
               ),
          ),
        )
      ],
    );
  }
}'''
  },
  'CollapseDemo3': {
    'title': '手风琴效果',
    'desc': '通过 onOpen/onClose 回调可以感知打开和关闭的时机，以此完成关闭其他已打开面板的功能。下面是 Column 中包含若干个 TolyCollapse，大量数据时，你也可以使用 ListView：',
    'code': r'''class CollapseDemo3 extends StatefulWidget {
  const CollapseDemo3({super.key});

  @override
  State<CollapseDemo3> createState() => _CollapseDemo3State();
}

class _ItemData {
  final String title;
  final String content;

  _ItemData({
    required this.title,
    required this.content,
  });
}

class _CollapseDemo3State extends State<CollapseDemo3> {
  List<_ItemData> data = [
    _ItemData(title: '《春》· 朱自清', content: """盼望着，盼望着，东风来了，春天的脚步近了。
一切都像刚睡醒的样子，欣欣然张开了眼。山朗润起来了，水涨起来了，太阳的脸红起来了。
小草偷偷地从土里钻出来，嫩嫩的，绿绿的。园子里，田野里，瞧去，一大片一大片满是的。坐着，躺着，打两个滚，踢几脚球，赛几趟跑，捉几回迷藏。风轻悄悄的，草绵软软的。
桃树、杏树、梨树，你不让我，我不让你，都开满了花赶趟儿。红的像火，粉的像霞，白的像雪。花里带着甜味，闭了眼，树上仿佛已经满是桃儿、杏儿、梨儿！花下成千成百的蜜蜂嗡嗡地闹着，大小的蝴蝶飞来飞去。野花遍地是：杂样儿，有名字的，没名字的，散在草丛里，像眼睛，像星星，还眨呀眨的。"""),
    _ItemData(
        title: '《应龙》· 张风捷特烈',
        content: """一游小池两岁月，\n洗却凡世几闲尘。\n时逢雷霆风会雨，\n应乘扶摇化入云。"""),
    _ItemData(
        title: '《朝花夕拾》· 鲁迅',
        content: """《朝花夕拾》原名《旧事重提》，是现代文学家鲁迅的散文集，收录鲁迅于1926年创作的10篇回忆性散文， 1928年由北京未名社出版，现编入《鲁迅全集》第2卷。
此文集作为“回忆的记事”，多侧面地反映了作者鲁迅青少年时期的生活，形象地反映了他的性格和志趣的形成经过。前七篇反映他童年时代在绍兴的家庭和私塾中的生活情景，后三篇叙述他从家乡到南京，又到日本留学，然后回国教书的经历；揭露了半殖民地半封建社会种种丑恶的不合理现象，同时反映了有抱负的青年知识分子在旧中国茫茫黑夜中，不畏艰险，寻找光明的困难历程，以及抒发了作者对往日亲友、师长的怀念之情。
文集以记事为主，饱含着浓烈的抒情气息，往往又夹以议论，做到了抒情、叙事和议论融为一体，优美和谐，朴实感人。作品富有诗情画意，又不时穿插着幽默和讽喻；形象生动，格调明朗，有强烈的感染力 。
    """),
  ];

  Map<_ItemData, CollapseController> ctrlMap = {};

  @override
  void initState() {
    super.initState();
    _initCtrlMap();
  }

  void _initCtrlMap(){
    ctrlMap.clear();
    for (_ItemData item in data) {
      ctrlMap[item] = CollapseController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(2*data.length+1, _buildItem),
    );
  }

  Widget _buildItem(int index) {
    if(index%2==0){
      return const Divider();
    }
    _ItemData item = data[index~/2];
    return TolyCollapse(
      sizeCurve: Curves.ease,
      controller: ctrlMap[item],
      onOpen: () => _closeOther(item),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(item.content),
      duration: const Duration(milliseconds: 400),
    );
  }

  void _closeOther(_ItemData me) {
    ctrlMap.forEach((k, v) {
      if (k != me && v.isOpen) {
        v.close();
      }
    });
  }
}'''
  },

};