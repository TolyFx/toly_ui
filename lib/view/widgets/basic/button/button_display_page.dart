import 'package:flutter/material.dart';
import 'package:toly_ui/components/node_display.dart';
import 'package:toly_ui/view/widgets/widget_display_map.dart';

import 'display_nodes.dart';

class ButtonDisplayPage extends StatelessWidget {
  const ButtonDisplayPage({super.key});

  ButtonStyle get outLineStyle {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };

      if (states.any(interactiveStates.contains)) {
        return Color(0xffecf5ff);
      }
      return Colors.red;
    }

    Color? getForegroundColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(0xff409eff);
      }
      return Color(0xff606266);
    }

    BorderSide? getSide(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.contains(MaterialState.pressed)) {
        return BorderSide(color: Color(0xff409eff));
      }
      if (states.any(interactiveStates.contains)) {
        return BorderSide(color: Color(0x44409eff));
      }
      return BorderSide(color: Color(0xffd9d9d9));
    }

    return ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      overlayColor: MaterialStateProperty.resolveWith(getColor),
      side: MaterialStateProperty.resolveWith((getSide)),
      foregroundColor: MaterialStateProperty.resolveWith(getForegroundColor),
      backgroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
    );
  }

  ButtonStyle get primaryStyle {
    //
    // OutlinedButton.styleFrom(
    //     backgroundColor: Color(0xff1890ff),
    //     foregroundColor: Colors.white,
    //     surfaceTintColor: Colors.transparent,
    //     splashFactory: NoSplash.splashFactory,
    //     elevation: 0,
    //     padding: EdgeInsets.symmetric(horizontal: 16),
    //     enableFeedback: false,
    //     shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(4)))

    Color? getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.contains(MaterialState.pressed)) {
        return Color(0xff096dd9);
      }
      if (states.any(interactiveStates.contains)) {
        return Color(0xff40a9ff);
      }
      return null;
    }

    Color? getForegroundColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.white;
    }

    BorderSide? getSide(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.contains(MaterialState.pressed)) {
        return BorderSide(color: Color(0xff409eff));
      }
      if (states.any(interactiveStates.contains)) {
        return BorderSide(color: Color(0x44409eff));
      }
      return BorderSide(color: Color(0xffecf5ff));
    }

    return ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      overlayColor: MaterialStateProperty.resolveWith(getColor),
      // side: MaterialStateProperty.resolveWith((getSide)),
      foregroundColor: MaterialStateProperty.resolveWith(getForegroundColor),
      backgroundColor: MaterialStateProperty.all(Color(0xff1890ff)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, index) {
          return NodeDisplay(
            display: widgetDisplayMap(keys[index]),
            node: Node.fromMap(data[index]),
          );
        },
        itemCount: displayNodes.length,
      ),
    );
  }
}

enum ButtonType {
  primary,
  default$,
  link,
}

enum ColorType {
  backGround,
}

class TolyButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback onPressed;
  final Set<(ColorType, Color)>? palette;
  final Widget child;

  const TolyButton(
      {super.key,
      required this.type,
      required this.onPressed,
      required this.child,
      this.palette});

  ButtonStyle get outlineStyle {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };

      if (states.any(interactiveStates.contains)) {
        return Color(0xffecf5ff);
      }
      return Colors.red;
    }

    Color? getForegroundColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(0xff409eff);
      }
      return Color(0xff606266);
    }

    BorderSide? getSide(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.contains(MaterialState.pressed)) {
        return BorderSide(color: Color(0xff409eff));
      }
      if (states.any(interactiveStates.contains)) {
        return BorderSide(color: Color(0x44409eff));
      }
      return BorderSide(color: Color(0xffd9d9d9));
    }

    return ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      overlayColor: MaterialStateProperty.resolveWith(getColor),
      side: MaterialStateProperty.resolveWith((getSide)),
      foregroundColor: MaterialStateProperty.resolveWith(getForegroundColor),
      backgroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
    );
  }

  ButtonStyle get primaryStyle {
    //
    // OutlinedButton.styleFrom(
    //     backgroundColor: Color(0xff1890ff),
    //     foregroundColor: Colors.white,
    //     surfaceTintColor: Colors.transparent,
    //     splashFactory: NoSplash.splashFactory,
    //     elevation: 0,
    //     padding: EdgeInsets.symmetric(horizontal: 16),
    //     enableFeedback: false,
    //     shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(4)))

    Color? getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.contains(MaterialState.pressed)) {
        return Color(0xff096dd9);
      }
      if (states.any(interactiveStates.contains)) {
        return Color(0xff40a9ff);
      }
      return null;
    }

    Color? getForegroundColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.white;
    }

    BorderSide? getSide(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.contains(MaterialState.pressed)) {
        return BorderSide(color: Color(0xff409eff));
      }
      if (states.any(interactiveStates.contains)) {
        return BorderSide(color: Color(0x44409eff));
      }
      return BorderSide(color: Color(0xffecf5ff));
    }

    return ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      overlayColor: MaterialStateProperty.resolveWith(getColor),
      // side: MaterialStateProperty.resolveWith((getSide)),
      foregroundColor: MaterialStateProperty.resolveWith(getForegroundColor),
      backgroundColor: MaterialStateProperty.all(Color(0xff1890ff)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
    );
  }

  ButtonStyle get linkStyle {
    return ButtonStyle(
      elevation: MaterialStatePropertyAll(0),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      // side: MaterialStateProperty.resolveWith((getSide)),
      foregroundColor: MaterialStateProperty.all(Color(0xff409eff)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: child,
      style: switch (type) {
        ButtonType.primary => primaryStyle,
        ButtonType.default$ => outlineStyle,
        ButtonType.link => linkStyle,
      },
    );
  }
}
