Map<String,dynamic> get displayNodes => {
  'MessageDemo1': {
    'title': 'Message 全局消息',
    'desc': r'使用 $message 弹出全局消息。',
    'code': r"""class MessageDemo1 extends StatelessWidget {
  const MessageDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [display1(), display2(), display3()],
    );
  }

  Widget display1() {
    return DebugDisplayButton(
      info: 'Show Message Top',
      onPressed: () {
        $message.info(message: 'This is a common message.');
      },
    );
  }

  Widget display2() {
    return DebugDisplayButton(
      info: 'Show Message Bottom',
      onPressed: () {
        $message.info(
          message: 'This is a common message.',
          position: MessagePosition.bottom,
        );
      },
    );
  }

  Widget display3() {
    InlineSpan span = const TextSpan(children: [
      TextSpan(text: '请通过此邮箱联系我 '),
      TextSpan(style: TextStyle(color: Colors.blue), text: '1981462002@qq.com ')
    ]);
    return DebugDisplayButton(
      onPressed: () {
        $message.info(richMessage: span);
      },
      info: '富文本',
    );
  }
}"""
  },
  'MessageDemo2': {
    'title': '四种样式简化使用',
    'desc': r'使用 $message 弹出全局消息。',
    'code': r"""class MessageDemo2 extends StatelessWidget {
  const MessageDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [display1(), display2(), dsplay3(), display4()],
    );
  }

  Widget display1() {
    return DebugDisplayButton(
      info: 'Success',
      onPressed: () {
        $message.success(message: 'Congrats, this is a success message.');
      },
    );
  }

  Widget display2() {
    return DebugDisplayButton(
      info: 'Warning',
      onPressed: () {
        $message.warning(message: 'Warning, this is a warning message.');
      },
    );
  }

  Widget dsplay3() {
    return DebugDisplayButton(
      onPressed: () {
        $message.info(message: 'This is a common message.');
      },
      info: 'Info',
    );
  }

  Widget display4() {
    return DebugDisplayButton(
      onPressed: () {
        $message.error(message: 'Oops, this is a error message.');
      },
      info: 'Error',
    );
  }
}"""
  },  'MessageDemo3': {
    'title': 'Message Plain 模式',
    'desc': r'设置 plain:true 可以让消息样式变为白色背景、阴影边框。',
    'code': r"""class MessageDemo3 extends StatelessWidget {
  const MessageDemo3({super.key});

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
    String message = 'Congrats, this is a success message.';
    return DebugDisplayButton(
      info: 'Success',
      onPressed: () {
        $message.success(plain: true, message:message );
      },
    );
  }

  Widget display2() {
    String message = 'Warning, this is a warning message.';
    return DebugDisplayButton(
      info: 'Warning',
      onPressed: () {
        $message.warning(plain: true, message: message);
      },
    );
  }

  Widget display3() {
    String message = 'This is a common message.';
    return DebugDisplayButton(
      onPressed: () {
        $message.info(plain: true, message: message);
      },
      info: 'Info',
    );
  }

  Widget display4() {
    String message = 'Oops, this is a error message.';
    return DebugDisplayButton(
      onPressed: () {
        $message.error(plain: true, message: message);
      },
      info: 'Error',
    );
  }
}"""
  }, 'MessageDemo4': {
    'title': 'Message 自定义消息内容',
    'desc': r'通过 emit 方法，产出自定义的组件提示信息。animaDuration 控制动画时长；duration 控制展示时长；offset 控制消息的偏移。',
    'code': r"""class MessageDemo4 extends StatelessWidget {
  const MessageDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [buildDisplay1(), buildDisplay2()],
    );
  }

  Widget buildDisplay1() {
    return DebugDisplayButton(
      info: '自定义内容',
      onPressed: () {
        $message.emit(
            child: const DebugDisplayPanel(
          image: 'assets/images/icon_head.webp',
          title: '张风捷特烈',
          info1: '微信号: zdl1994328',
          info2: '地区: 安徽·合肥',
        ));
      },
    );
  }

  Widget buildDisplay2() {
    return DebugDisplayButton(
      info: '动画时长',
      onPressed: () {
        $message.emit(
          animaDuration: const Duration(milliseconds: 500),
          child: const DebugDisplayPanel(
            image: 'assets/images/icon_head.webp',
            title: '张风捷特烈',
            info1: '微信号: zdl1994328',
            info2: '地区: 安徽·合肥',
          ),
        );
      },
    );
  }
}"""
  }, 'MessageDemo5': {
    'title': '可主动关闭的 Message',
    'desc': r'通过 closeable 设置消息是否可以被主动关闭；自定义的内容可以通过 builder 回调访问关闭函数。',
    'code': r"""class MessageDemo5 extends StatelessWidget {
  const MessageDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [display1(), display2()],
    );
  }

  Widget display1() {
    return DebugDisplayButton(
      info: '可关闭消息',
      onPressed: () {
        $message.success(
          closeable: true,
          duration: const Duration(seconds: 5),
          message: 'Congrats, this is a success message.',
        );
      },
    );
  }

  Widget display2() {
    return DebugDisplayButton(
      info: '关闭自定义消息',
      onPressed: () {
        $message.emit(
          duration: const Duration(seconds: 5),
          builder: (_, close) => DebugDisplayPanel(
            image: 'assets/images/icon_head.webp',
            title: '张风捷特烈',
            info1: '微信号: zdl1994328',
            info2: '地区: 安徽·合肥',
            onClose: close,
          ),
        );
      },
    );
  }
}"""
  },
};