import 'package:flutter/material.dart';

class AutocompleteDisplay extends StatelessWidget {
  const AutocompleteDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 26,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
              ]),
          child: Row(
            children: [
              const Text(
                'ABC',
                style: TextStyle(color: Colors.grey),
              ),
              const Text(
                '|',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 26,
          margin: const EdgeInsets.only(left: 48, right: 48),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xffe4e7ed),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          child: const Text(
            'ABCD',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 26,
          margin: const EdgeInsets.only(left: 48, right: 48),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xffcbe4f9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: const Text(
            'ABCDE',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class DatePickerDisplay extends StatelessWidget {
  const DatePickerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          height: 26,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
              ]),
          child: Row(
            children: [
              const Text(
                'YY-MM-DD',
                style: TextStyle(color: Colors.grey),
              ),
              Spacer(),
              Icon(
                Icons.date_range,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          alignment: Alignment.centerLeft,
          height: 26,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
              ]),
          child: Row(
            children: [
              const Text(
                'HH-mm-ss',
                style: TextStyle(color: Colors.grey),
              ),
              Spacer(),
              Icon(
                Icons.watch_later_outlined,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InputDisplay extends StatelessWidget {
  const InputDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return        Container(
      alignment: Alignment.centerLeft,
      height: 26,
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
          ]),
      child: Row(
        children: [
          const Text(
            'ABC',
            style: TextStyle(color: Colors.grey),
          ),
          const Text(
            '|',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );

  }
}

class SelectDisplay extends StatelessWidget {
  const SelectDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return         Container(
      alignment: Alignment.centerLeft,
      height: 26,
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
          ]),
      child: Row(
        children: [
          const Text(
            'ABC',
            style: TextStyle(color: Colors.grey),
          ),
          Spacer(),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: Colors.grey,
          ),
        ],
      ),
    );

  }
}

