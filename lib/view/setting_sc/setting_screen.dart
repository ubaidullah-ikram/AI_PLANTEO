import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 18),
        ),
        backgroundColor: Color(0xffF9F9F9),
        surfaceTintColor: Color(0xffF9F9F9),
        centerTitle: false,
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: AppFonts.sfPro,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),
        ),
      ),

      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support',
                style: TextStyle(
                  fontFamily: AppFonts.sfPro,
                  fontSize: 16,
                  color: Color(0xff797979),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // ListTile(
                    //   leading: SvgPicture.asset(AppIcons.share, height: 16),
                    //   title: Text(
                    //     'Share Planteo',
                    //     style: TextStyle(fontSize: 15),
                    //   ),
                    // ),
                    // Divider(color: Color(0xffF3F3F3)),
                    // ListTile(
                    //   leading: SvgPicture.asset(AppIcons.rate, height: 18),
                    //   title: Text(
                    //     'Rate Your Experience',
                    //     style: TextStyle(fontSize: 15),
                    //   ),
                    // ),
                    // Divider(color: Color(0xffF3F3F3)),
                    ListTile(
                      onTap: () {
                        _launchURL(
                          'https://pioneerdigital.tech/privacy-policy.html',
                        );
                      },
                      leading: SvgPicture.asset(AppIcons.privacy, height: 18),
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Divider(color: Color(0xffF3F3F3)),
                    ListTile(
                      onTap: () {
                        _launchURL(
                          'https://pioneerdigital.tech/terms-and-conditions.html',
                        );
                      },
                      leading: SvgPicture.asset(AppIcons.terms, height: 16),
                      title: Text(
                        'Term Of Services',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlN) async {
    final Uri url = Uri.parse(urlN); // jis URL par jana hy
    await launchUrl(
      url,
      // mode: LaunchMode.externalApplication, // external browser khulega
    );
  }
}
