import 'package:equatable/equatable.dart';

class MenuHistory extends Equatable{
  final String menuLabel;
  final String menuPath;

  const MenuHistory({
    required this.menuLabel,
    required this.menuPath,
  });

  @override
  List<Object?> get props => [menuLabel,menuPath];
}
