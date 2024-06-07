import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/data/timeline/timeline_model.dart';
import 'timeline_painter.dart';

class TimelineElement extends StatelessWidget {
  final Color lineColor;
  final Color backgroundColor;
  final TimelineModel model;
  final bool firstElement;
  final bool lastElement;
  final Animation<double> controller;
  final Color? headingColor;
  final Color? descriptionColor;

  const TimelineElement(
      {super.key,
      required this.lineColor,
      required this.backgroundColor,
      required this.controller,
      required this.model,
      this.firstElement = false,
      this.lastElement = false,
      this.headingColor,
      this.descriptionColor});

  Widget _buildLine(BuildContext context, Widget? child) {
    return SizedBox(
      width: 40.0,
      child: CustomPaint(
        painter: TimelinePainter(
            lineColor: lineColor,
            backgroundColor: backgroundColor,
            firstElement: firstElement,
            lastElement: lastElement,
            controller: controller),
      ),
    );
  }

  Widget _buildContentColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          child: Text(
            model.title.length > 47 ? "${model.title.substring(0, 47)}..." : model.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: headingColor ?? Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Text(
            model.description != null
                ? (model.description!.length > 50 ? "${model.description!.substring(0, 50)}..." : model.description!)
                : "",
            // To prevent overflowing of text to the next element, the text is truncated if greater than 75 characters
            style: TextStyle(
              color: descriptionColor ?? Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRow(BuildContext context) {
    return Container(
      height: 80.0,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AnimatedBuilder(
            builder: _buildLine,
            animation: controller,
          ),
          Expanded(
            child: _buildContentColumn(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRow(context);
  }
}
