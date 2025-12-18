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

class CheckboxDisplay extends StatelessWidget {
  const CheckboxDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Icon(Icons.check, size: 12, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class SliderDisplay extends StatelessWidget {
  const SliderDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.6,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.6 - 96,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchDisplay extends StatelessWidget {
  const SwitchDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 36,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class RadioDisplay extends StatelessWidget {
  const RadioDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 2),
          ),
        ),
      ],
    );
  }
}

class TransferDisplay extends StatelessWidget {
  const TransferDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBox(),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chevron_right, size: 16, color: Colors.blue),
            const SizedBox(height: 4),
            Icon(Icons.chevron_left, size: 16, color: Colors.grey),
          ],
        ),
        const SizedBox(width: 8),
        _buildBox(),
      ],
    );
  }

  Widget _buildBox() {
    return Container(
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (index) => Container(
                  width: 28,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorPickerDisplay extends StatelessWidget {
  const ColorPickerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 0.1, blurRadius: 2)
            ],
          ),
        ),
      ],
    );
  }
}

