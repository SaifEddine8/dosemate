import 'package:flutter/material.dart';
import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback? onEditPressed;

  const ProfileHeaderCard({
    super.key,
    required this.userName,
    required this.userEmail,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: ConstantColors.primaryColor.withOpacity(0.1),
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                style: AppStyles.subtitle.copyWith(
                  fontSize: 32,
                  color: ConstantColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: onEditPressed,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: ConstantColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          userName,
          style: AppStyles.subtitle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        if (userEmail.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: AppStyles.body.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}