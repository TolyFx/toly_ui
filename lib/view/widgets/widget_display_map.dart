import 'package:flutter/material.dart';
import 'widgets.dart';

Widget widgetDisplayMap(String key) {
  return switch (key) {
    'IconDemo1' => const IconDemo1(),
    'TextDemo1' => const TextDemo1(),
    'TextDemo2' => const TextDemo2(),
    'TextDemo3' => const TextDemo3(),
    'ButtonDemo1' => const ButtonDemo1(),
    'ButtonDemo2' => const ButtonDemo2(),
    'ButtonDemo3' => const ButtonDemo3(),
    'ButtonDemo4' => const ButtonDemo4(),
    'LayoutDemo1' => const LayoutDemo1(),
    'LayoutDemo2' => const LayoutDemo2(),
    'LayoutDemo3' => const LayoutDemo3(),
    'LayoutDemo4' => const LayoutDemo4(),
    'LayoutDemo5' => const LayoutDemo5(),
    'LayoutDemo6' => const LayoutDemo6(),
    'LayoutDemo7' => const LayoutDemo7(),
    'LayoutDemo8' => const LayoutDemo8(),
    'LayoutDemo9' => const LayoutDemo9(),
    'LayoutDemo10' => const LayoutDemo10(),
    'LinkDemo1' => const LinkDemo1(),
    'LinkDemo2' => const LinkDemo2(),
    'LinkDemo3' => const LinkDemo3(),
    'InputDemo1' => const InputDemo1(),
    'InputDemo2' => const InputDemo2(),
    'InputDemo3' => const InputDemo3(),
    _ => const SizedBox()
  };
}
