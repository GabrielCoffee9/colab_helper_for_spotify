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
    return Stack(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          style: IconButton.styleFrom(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
            hoverColor: colors.onSecondaryContainer.withOpacity(0.08),
            focusColor: colors.onSecondaryContainer.withOpacity(0.12),
            highlightColor: colors.onSecondaryContainer.withOpacity(0.12),
          ),
          icon: Icon(
            iconButton,
            size: 24,
            color: colors.primary,
          ),
        ),
        Positioned(
          right: 1,
          top: 1,
          child: badges.Badge(
            showBadge: notificationCounter > 0,
            badgeContent: Text((notificationCounter).toString()),
            badgeAnimation: badges.BadgeAnimation.fade(),
          ),
        ),
      ],
    );
  }
}
