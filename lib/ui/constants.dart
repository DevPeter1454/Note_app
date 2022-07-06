import 'package:flutter/material.dart';

class CatIcons {
  String text;
  IconData icon;
  Color? color;
  CatIcons({
    required this.text,
    required this.icon,
    required this.color,
  });
}

var tabIcons = [
  CatIcons(
    text: 'Uncategorized',
    icon: Icons.grid_view_outlined,
    color: Colors.green[500],
  ),
  CatIcons(
    text: 'Business',
    icon: Icons.business_center_rounded,
    color: Colors.red[500],
  ),
  CatIcons(
    text: 'Home Affair',
    icon: Icons.home_filled,
    color: Colors.purple[500],

  ),
  CatIcons(
    text: 'Study',
    icon: Icons.import_contacts_rounded,
    color: Colors.blue[500],

  ),
  CatIcons(
    text: 'Personal',
    icon: Icons.person,
    color: Colors.pink[500],


  ),
];
