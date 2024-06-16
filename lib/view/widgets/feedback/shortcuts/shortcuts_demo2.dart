// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'Shortcuts 和 Actions 首先快捷键',
  desc: '基于 CallbackShortcuts 组件可以简便地使用快捷键。',
)
class CharacterActivatorExample extends StatefulWidget {
  const CharacterActivatorExample({super.key});

  @override
  State<CharacterActivatorExample> createState() => _CharacterActivatorExampleState();
}

class _CharacterActivatorExampleState extends State<CharacterActivatorExample> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        CharacterActivator('?'): HelpMenuIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          HelpMenuIntent: CallbackAction<HelpMenuIntent>(
            onInvoke: (HelpMenuIntent intent) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Keep calm and carry on~!')),
              );
              return null;
            },
          ),
        },
        child: const Focus(
          autofocus: true,
          child: Column(
            children: <Widget>[
              Text('Press question mark for help'),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpMenuIntent extends Intent {
  const HelpMenuIntent();
}
