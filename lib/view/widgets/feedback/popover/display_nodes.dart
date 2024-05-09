Map<String,dynamic> get displayNodes => {
  'PopoverDemo1': {
    'title': 'Popover 基本使用',
    'desc': 'Popover 会将浮层弹框的控制器暴露给 build 方法。你可以通过任何手势事件来打开或关闭浮层弹框。',
    'code': r"""class PopoverDemo1 extends StatelessWidget {
  const PopoverDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      children: [
        buildDisplay1(),
        buildDisplay2(),
        // Spacer(),
      ],
    );
  }

  Widget buildDisplay1() {
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 200,
      overlay: const DisplayPanel(),
      builder: (_, ctrl, __) {
        return MouseRegion(
          onEnter: (_)=> ctrl.open(),
          child: const DebugDisplayButton(
            info: 'Hover Me',
          ),
        );
      },
    );
  }

  Widget buildDisplay2() {
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 200,
      overlay: const DisplayPanel(),
      builder: (_, ctrl, __) {
        return DebugDisplayButton(
          info: 'Click Me',
          onPressed: ctrl.open,
        );
      },
    );
  }
}

class DisplayPanel extends StatelessWidget {
  const DisplayPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
            child: Text(
              'Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: px1,thickness: px1,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
            child: Text(
              'this is content, this is content, this is content',
            ),
          ),
        ],
      ),
    );
  }
}"""
  },
  'PopoverDemo2': {
    'title': 'Popover 弹框控制隐藏',
    'desc': '使用 overlayBuilder 构造弹框内容，获取控制器。',
    'code': r"""class PopoverDemo2 extends StatelessWidget {
  const PopoverDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        buildDisplay1(),
        buildDisplay2(),
        // Spacer(),
      ],
    );
  }
  
  Widget buildDisplay1() {
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 200,
      overlayBuilder: (BuildContext context,ctrl) {
        return DeletePanel( ctrl: ctrl,);
      },
      builder: (_, ctrl, __) {
        return DebugDisplayButton(
          info: 'Delete',
          onPressed: ctrl.open,
        );
      },
    );
  }
  Widget buildDisplay2() {
    return TolyPopover(
      placement: Placement.bottomEnd,
      maxWidth: 180,
      overlayBuilder: (BuildContext context,ctrl) {
        return DisplayMenu(ctrl);
      },
      decorationConfig: const DecorationConfig(),
      builder: (_, ctrl, __) {
        return GestureDetector(
          onTap: ctrl.open,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              Icons.add_circle_outline,
              color: Color(0xff666666),
              // info: 'Click Me',
              // onPressed: ctrl.open,
            ),
          ),
        );
      },
    );
  }
}

class DisplayMenu extends StatelessWidget {
  final PopoverController ctrl;
  const DisplayMenu(this.ctrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem('发起群聊',Icons.chat_outlined),
          const Divider(color: Color(0xff515151),),
          _buildItem('添加朋友',Icons.add),
          const Divider(color: Color(0xff515151),),
          _buildItem('扫一扫',Icons.qr_code),
          const Divider(color: Color(0xff515151),),
          _buildItem('收付款',Icons.payment_sharp),
        ],
      ),
    );
  }

  Widget _buildItem(String title,IconData icon ){
   return GestureDetector(
     behavior: HitTestBehavior.opaque,
     onTap: ctrl.close,
     child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 8.0),
        child: Row(
          children: [
            Icon(icon,  color: Colors.white,size: 20,),
            const SizedBox(width: 12,),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14),
            ),
          ],
        ),
      ),
   );
  }
}


class DeletePanel extends StatelessWidget {
  final PopoverController ctrl;

  const DeletePanel({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
          child: Text(
            'Delete Tip',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(height: px1,thickness: px1,),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
          child: Text(
            'Are you sure delete this task?',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0,bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DebugDisplayButton(info: 'No',onPressed: ctrl.close,type: DebugButtonType.cancel,),
              const SizedBox(width: 8,),
              DebugDisplayButton(info: 'Yes',onPressed: ctrl.close,type: DebugButtonType.conform,)
            ],
          ),
        )
      ],
    );
  }
}"""
  },
  'PopoverDemo3': {
    'title': 'Popover 自定义装饰与偏移',
    'desc': '可以通过 overlayDecorationBuilder 可以自定义弹出浮层的装饰。通过 offsetCalculator 计算偏移',
    'code': r"""class PopoverDemo3 extends StatelessWidget {
  const PopoverDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        buildDisplay1(),
        buildDisplay2(),
        // Spacer(),
      ],
    );
  }

  Widget buildDisplay1() {
    String message =
        '21 世纪伟大的编程者、诗人、文学家、思想家。代表作有 《捷特诗集》、《幻将录》、《代码之海》、《Flutter 系列著作》等。';
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 240,
      overlayDecorationBuilder: (_) => BoxDecoration(
        gradient: LinearGradient(transform: GradientRotation(pi / 4), colors: [
          Colors.blue,
          Colors.brown,
          Colors.green,
          Colors.red,
        ]),
        borderRadius: BorderRadius.circular(4),
      ),
      overlay: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
        child: Text(
          message,
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
      ),
      builder: (_, ctrl, __) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(onTap: ctrl.open, child: const Text('张风捷特烈')),
        );
      },
    );
  }

  Widget buildDisplay2() {
    return TolyPopover(
      placement: Placement.rightStart,
      maxWidth: 250,
      overlayBuilder: (BuildContext context, ctrl) {
        return _DisplayPanel(ctrl);
      },
      overlayDecorationBuilder: (_) => BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 0,
          )
        ],
        borderRadius: BorderRadius.circular(4),
      ),
      offsetCalculator: (_, size, __, gap) {
        return Offset(-size.width / 2 - gap, size.height / 2);
      },
      builder: (_, ctrl, __) {
        return GestureDetector(
          onTap: ctrl.open,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/icon_head.webp'),
          ),
        );
      },
    );
  }
}

class _DisplayPanel extends StatelessWidget {
  final PopoverController ctrl;

  const _DisplayPanel(this.ctrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/icon_head.webp'),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '张风捷特烈',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '微信号: zdl1994328',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '地区: 安徽·合肥',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Wrap(
              spacing: 20,
              children: [
                DebugDisplayButton(info: '发消息'),
                DebugDisplayButton(info: '联系我',type: DebugButtonType.fillDisplay,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}"""
  },
  'PopoverDemo4': {
    'title': 'Popover 对齐方式',
    'desc': 'TolyPopover 提供 12 种不同方向的展示方式，以及气泡框包裹效果。',
    'code': r"""class PopoverDemo4 extends StatelessWidget {
  const PopoverDemo4({super.key});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: buildDisplay(Placement.topStart)),
              Expanded(child: buildDisplay(Placement.top)),
              Expanded(child: buildDisplay(Placement.topEnd)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: buildDisplay(Placement.leftStart)),
              Expanded(child: buildDisplay(Placement.left)),
              Expanded(child: buildDisplay(Placement.leftEnd)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: buildDisplay(Placement.rightStart)),
              Expanded(child: buildDisplay(Placement.right)),
              Expanded(child: buildDisplay(Placement.rightEnd)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: buildDisplay(Placement.bottomStart)),
              Expanded(child: buildDisplay(Placement.bottom)),
              Expanded(child: buildDisplay(Placement.bottomEnd)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDisplay(Placement placement){
    String info = placement.toString().split('.')[1];
    String buttonText = _nameMap[placement]!;
    return Center(
      child:
      TolyPopover(
        maxWidth: 200,
        placement: placement,
        gap: 12,
        overlay: _DisplayPanel(title: info,),
        builder: (_,ctrl,__)=>
            DebugDisplayButton(info: buttonText ,onPressed: ctrl.open,),
      ),
    );
  }
  static const Map<Placement,String> _nameMap = {
    Placement.top: 'Top',
    Placement.topStart: 'TStart',
    Placement.topEnd: 'TEnd',
    Placement.bottomEnd: 'BEnd',
    Placement.bottom: 'Bottom',
    Placement.bottomStart: 'BStart',
    Placement.rightEnd: 'REnd',
    Placement.right: 'Right',
    Placement.rightStart: 'RStart',
    Placement.leftEnd: 'LEnd',
    Placement.left: 'Left',
    Placement.leftStart: 'LStart',
  };

}

class _DisplayPanel extends StatelessWidget {
  final String title;
  const _DisplayPanel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              title.substring(0,1).toUpperCase()+title.substring(1),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              'this is content, this is content, this is content',
            ),
          ),
        ],
      ),
    );
  }
}"""
  },

};