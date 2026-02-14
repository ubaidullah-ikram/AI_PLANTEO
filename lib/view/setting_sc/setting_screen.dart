import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:share_plus/share_plus.dart';
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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, size: 18),
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
                        if (Platform.isAndroid) {
                          Share.share(
                            "Check out this amazing plant app 🌱\nhttps://play.google.com/store/apps/details?id=com.planteo.ai.plant.identifier.scanner.disease.diagnose.garden.care.reminder",
                          );
                        } else {
                          Share.share(
                            "Check out this amazing plant app 🌱\nhttps://apps.apple.com/app/id6758267377",
                          );
                        }
                      },
                      leading: SvgPicture.asset(AppIcons.share, height: 16),
                      title: Text(
                        'Share Planteo',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),

                    Divider(color: Color(0xffF3F3F3)),
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

                    Divider(color: Color(0xffF3F3F3)),
                    ListTile(
                      onTap: () {
                        final Uri email = Uri(
                          scheme: 'mailto',
                          path: 'lohang097@gmail.com',
                          query:
                              'subject=App Feedback&body=Write your feedback here...',
                        );
                        launchUrl(email);
                      },
                      leading: Icon(
                        Icons.feedback_outlined,
                        size: 18,
                        color: Colors.green,
                      ),
                      title: Text('Feedback', style: TextStyle(fontSize: 15)),
                    ),
                    Divider(color: Color(0xffF3F3F3)),
                    ListTile(
                      onTap: () {
                        if (Platform.isAndroid) {
                          _launchURL(
                            'https://play.google.com/store/apps/developer?id=InnovationAI',
                          );
                        } else {
                          _launchURL(
                            'https://apps.apple.com/us/developer/ubaid-ullah-ikram/id1850132313',
                          );
                        }
                      },
                      leading: Icon(
                        Icons.more_outlined,
                        size: 18,
                        color: Colors.green,
                      ),
                      title: Text('More Apps', style: TextStyle(fontSize: 15)),
                    ),
                    Divider(color: Color(0xffF3F3F3)),

                    ListTile(
                      onTap: () {
                        showDisclaimerDialog(context);
                      },
                      leading: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.green,
                        size: 18,
                      ),
                      title: Text('Disclaimer', style: TextStyle(fontSize: 15)),
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

  void showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ⚠️ Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 14),

                /// Title
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Disclaimer",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff134E4A),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Description
                const Text(
                  "This app identifies and diagnoses plants using AI for guidance only. Accuracy may vary always verify with a botanist.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 20),

                /// Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
