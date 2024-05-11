Map<String,dynamic> get displayNodes => {
  'NotificationDemo1': {
    'title': 'Notification 全局通知',
    'desc': r'使用 $message.xxxNotice 弹出全局通知。时长设置为 0，可以取消自动关闭，由用户手动关闭。',
    'code': r"""class MessageDemo1 extends StatelessWidget {
  const MessageDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 40,
      children: [
        buildDisplay1(),
      ],
    );
  }

  Widget buildDisplay1() {
    return  DebugDisplayButton(info: 'Show Message',
    onPressed: (){
      $message.emit();
    },);
  }

}"""
  },
  'NotificationDemo2': {
    'title': 'Notification 类型与定位',
    'desc': r'position 属性的 NoticePosition 枚举有左上、左下、右上、右下四种定位方式。另外，info、success、error、warning 四种提示类型可通过对应的 $message.xxxNotice 弹出。',
    'code': r"""class NotificationDemo2 extends StatelessWidget {
  const NotificationDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [display1(), display2(), display3(), display4()],
    );
  }
  
  Widget display1() {
    return DebugDisplayButton(
      info: 'topLeft',
      onPressed: () {
        $message.infoNotice(
            position: NoticePosition.topLeft,
            title: const Text(
              'Info Notification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('This is a Notification from topLeft.' * 3));
      },
    );
  }

  Widget display2() {
    return DebugDisplayButton(
      info: 'topRight',
      onPressed: () {
        $message.errorNotice(
            position: NoticePosition.topRight,
            title: const Text(
              'Error Notification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('This is a Notification from topRight.' * 3));
      },
    );
  }

  Widget display3() {
    return DebugDisplayButton(
      onPressed: () {
        $message.successNotice(
            position: NoticePosition.bottomLeft,
            title: const Text(
              'Success Notification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('This is a Notification from bottomLeft.' * 3));
      },
      info: 'bottomLeft',
    );
  }

  Widget display4() {
    return DebugDisplayButton(
      onPressed: () {
        $message.warningNotice(
            position: NoticePosition.bottomRight,
            title: const Text(
              'Warning Notification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('This is a Notification from bottomRight.' * 3));
      },
      info: 'bottomRight',
    );
  }
}
"""
  },
  'NotificationDemo3': {
    'title': 'Notification 自定义内容和偏移',
    'desc': r'通过 $message.emitNotice 方法可以自定义通知内容组件，其中回调的 close 函数用于关闭通知。offset 属性可以设置提示面板偏移量。',
    'code': r"""class MessageDemo1 extends StatelessWidget {
  const MessageDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 40,
      children: [
        buildDisplay1(),
      ],
    );
  }

  Widget buildDisplay1() {
    return  DebugDisplayButton(info: 'Show Message',
    onPressed: (){
      $message.emit();
    },);
  }

}"""
  },
};