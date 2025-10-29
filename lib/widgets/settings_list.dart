import 'package:flutter/material.dart';

class SettingList extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingList({
    Key? key,
    required this.title,
    this.icon,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
