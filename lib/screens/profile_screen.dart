import 'package:dosemate/screens/login_screen.dart';
import 'package:dosemate/widgets/profile_header_card.dart';
import 'package:dosemate/widgets/profile_option_tile.dart';
import 'package:dosemate/widgets/profile_stats_row.dart';
import 'package:flutter/material.dart';
import 'package:dosemate/core/constant/app_style.dart';
import 'package:dosemate/core/constant/constant_colors.dart';
import 'package:dosemate/db/user.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('تسجيل الخروج', style: AppStyles.subtitle),
          content: const Text(
            'هل أنت تأكد من أنك تريد تسجيل الخروج من التطبيق؟',
            style: AppStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                currentUser = null;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false,);
              },
              child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final userName = user?.name ?? 'المستخدم';
    final userEmail = user?.email ?? '';

    return Scaffold(
      backgroundColor: ConstantColors.tertiaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'الملف الشخصي',
          style: AppStyles.pageTitle.copyWith(color: ConstantColors.primaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ProfileHeaderCard(
                    userName: userName,
                    userEmail: userEmail,
                    onEditPressed: () {},
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(),
                  ),
                  const ProfileStatsRow(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              shadowColor: Colors.black.withOpacity(0.04),
              child: Column(
                children: [
                  ProfileOptionTile(
                    icon: Icons.person_outline,
                    title: 'تعديل البيانات الشخصية',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ProfileOptionTile(
                    icon: Icons.notifications_none,
                    title: 'تنبيهات الجرعات',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeColor: ConstantColors.primaryColor,
                      onChanged: (val) {
                        setState(() {
                          _notificationsEnabled = val;
                        });
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ProfileOptionTile(
                    icon: Icons.medical_services_outlined,
                    title: 'سجل الجرعات والتقارير',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              shadowColor: Colors.black.withOpacity(0.04),
              child: Column(
                children: [
                  ProfileOptionTile(
                    icon: Icons.help_outline,
                    title: 'المساعدة والدعم',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ProfileOptionTile(
                    icon: Icons.info_outline,
                    title: 'عن التطبيق',
                    subtitle: 'الإصدار 1.0.0',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ProfileOptionTile(
                    icon: Icons.logout,
                    title: 'تسجيل الخروج',
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    trailing: const SizedBox.shrink(),
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}