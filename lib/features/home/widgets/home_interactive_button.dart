import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class HomeInteractiveButton extends StatelessWidget {
  const HomeInteractiveButton({
    super.key,
    required this.onPressed,
    required this.colors,
    required this.iconButton,
    required this.notificationCounter,
  });
  final ColorScheme colors;
  final VoidCallback onPressed;
  final IconData iconButton;
  final int notificationCounter;

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      showBadge: notificationCounter > 0,
      badgeContent: Text((notificationCounter).toString()),
      badgeAnimation: badges.BadgeAnimation.fade(),
    
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          foregroundColor: colors.onSecondaryContainer,
          backgroundColor: colors.secondaryContainer,
          disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
          hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
          focusColor: colors.onSecondaryContainer.withOpacity(0.12),
          highlightColor: colors.onSecondaryContainer.withOpacity(0.12),
        ),
        icon: Icon(iconButton, size: 24),
      ),
    );
  }
}
