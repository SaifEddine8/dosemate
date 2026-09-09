import 'package:flutter/material.dart';
import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? ConstantColors.primaryColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor ?? ConstantColors.primaryColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: AppStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppStyles.small.copyWith(color: Colors.grey))
          : null,
      trailing: trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}