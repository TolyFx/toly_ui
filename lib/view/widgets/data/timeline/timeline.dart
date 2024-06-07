
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/data/timeline/timeline_element.dart';
import 'package:toly_ui/view/widgets/data/timeline/timeline_model.dart';

class TimelineComponent extends StatefulWidget {
  final List<TimelineModel> timelineList;

  final Color? lineColor;

  final Color? backgroundColor;

  final Color headingColor;

  final Color descriptionColor;

  const TimelineComponent(Key key,
      {this.timelineList = const [],
      this.lineColor,
      this.backgroundColor,
      this.headingColor = Colors.white24,
      this.descriptionColor = Colors.black87})
      : super(key: key);

  @override
  TimelineComponentState createState() {
    return  TimelineComponentState();
  }
}

class TimelineComponentState extends State<TimelineComponent> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  double fraction = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: widget.timelineList.length,
      itemBuilder: (_, index) {
        return TimelineElement(
          lineColor: widget.lineColor ?? Theme.of(context).canvasColor,
          backgroundColor: widget.backgroundColor ?? Colors.white,
          model: widget.timelineList[index],
          firstElement: index == 0,
          lastElement: widget.timelineList.length == index + 1,
          controller: controller,
          headingColor: widget.headingColor,
          descriptionColor: widget.descriptionColor,
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
