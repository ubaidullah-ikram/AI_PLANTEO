import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/services/admanager_services.dart';
import 'package:plantify/services/remote_config_service.dart';
import 'package:plantify/view/analyzing_sc/analyzing_screen.dart';
import 'package:plantify/view_model/onb_instruction_controller/onb_instruction_controller.dart';
import 'package:plantify/view_model/pro_screen_controller/pro_screen_controller.dart';
import 'package:svg_flutter/svg.dart';

class InstructionScreens extends StatefulWidget {
  const InstructionScreens({Key? key}) : super(key: key);

  @override
  State<InstructionScreens> createState() => _InstructionScreensState();
}

class _InstructionScreensState extends State<InstructionScreens>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  var instructionController = Get.put(OnbInstructionController());
  int _currentIndex = 0;
  bool isBannerAdLoaded = false;
  bool inbannerForBottom = false;

  // ✅ Har controller ki apni banner ad
  BannerAd? bannerAd;
  // Har screen ke liye selected options store karne ke liye
  Map<int, Set<int>> _selectedOptions = {};
  void _loadBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.of(context).size.width.truncate(),
        );
    bannerAd = BannerAd(
      adUnitId: AdIds.bannerAdIdId,
      size: size ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Banner Loaded");
          setState(() {
            isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("❌ Banner Failed: $error");
          setState(() {
            isBannerAdLoaded = false;
          });
        },
      ),
    );
    bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    if (RemoteConfigService().banner_ads_for_IOS ||
        RemoteConfigService().banner_ads_for_android) {
      // _loadBannerAd();
      // _loadBottomBannerAd();
    } else {}
    // Initialize empty sets for each screen
    for (int i = 0; i < instructionController.screens.length; i++) {
      _selectedOptions[i] = {};
    }
  }

  bool _isAdInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isAdInitialized) {
      if (RemoteConfigService().banner_ads_for_IOS ||
          RemoteConfigService().banner_ads_for_android) {
        if (!Get.find<ProScreenController>().isUserPro.value) {
          _loadBannerAd();
          _loadBottomBannerAd();

          _isAdInitialized = true;
        }
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    AdManager.disposeBanner(bannerAd);
    AdManager.disposeBanner(bottomBannerAd);
    super.dispose();
  }

  void _toggleOption(int optionIndex) {
    setState(() {
      if (_selectedOptions[_currentIndex]!.contains(optionIndex)) {
        _selectedOptions[_currentIndex]!.remove(optionIndex);
      } else {
        _selectedOptions[_currentIndex]!.add(optionIndex);
      }
    });
  }

  void _nextScreen() {
    if (_currentIndex < instructionController.screens.length - 1) {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentIndex++;
        });
        _fadeController.forward();
      });
    } else {
      // Last screen par "Done" button press hone par
      // Navigator.of(context).pop();
      Get.to(() => AnalyzingScreen());
    }
  }

  void _previousScreen() {
    if (_currentIndex > 0) {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentIndex--;
        });
        _fadeController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _previousScreen,
                    child: Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: _currentIndex > 0
                          ? Colors.black
                          : Colors.grey[300],
                    ),
                  ),
                  // Progress Indicator
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      instructionController.screens.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          height: 4,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: index <= _currentIndex
                                ? AppColors.themeColor
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Skip action
                      // Navigator.of(context).pop();
                      Get.to(() => AnalyzingScreen());
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: SizeConfig.h(20)),
                        _currentIndex == 0
                            ? Column(
                                children: [
                                  isBannerAdLoaded
                                      ? SizedBox.shrink()
                                      : SizedBox(height: SizeConfig.h(70)),
                                  isBannerAdLoaded
                                      ? SizedBox(
                                          width: bannerAd!.size.width
                                              .toDouble(),
                                          height: bannerAd!.size.height
                                              .toDouble(),
                                          child: AdWidget(ad: bannerAd!),
                                        )
                                      : SizedBox(),
                                  isBannerAdLoaded
                                      ? SizedBox(height: SizeConfig.h(20))
                                      : SizedBox.shrink(),
                                  Center(
                                    child: Text(
                                      'Identify Your Plants & mushrooms',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.themeColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: [
                                      Text(
                                        'Find out which plant or mushroom it is',
                                        style: TextStyle(
                                          fontSize: 14,
                                          // color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  Center(
                                    child: Image.asset(
                                      height: SizeConfig.h(300),
                                      AppImages.instruction_mashroom,
                                    ),
                                  ),
                                ],
                              )
                            : _currentIndex == 1
                            ? Column(
                                children: [
                                  isBannerAdLoaded
                                      ? SizedBox.shrink()
                                      : SizedBox(height: SizeConfig.h(70)),
                                  isBannerAdLoaded
                                      ? SizedBox(
                                          width: bannerAd!.size.width
                                              .toDouble(),
                                          height: bannerAd!.size.height
                                              .toDouble(),
                                          child: AdWidget(ad: bannerAd!),
                                        )
                                      : SizedBox(),
                                  isBannerAdLoaded
                                      ? SizedBox(height: SizeConfig.h(20))
                                      : SizedBox.shrink(),
                                  Center(
                                    child: Text(
                                      'Our plants deserve better care we help you give it.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.themeColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: [
                                      Text(
                                        'Scan, diagnose, and improve plant \nhealth with ease.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          // color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  Center(
                                    child: Image.asset(
                                      height: SizeConfig.h(300),
                                      AppImages.instruction_plant_img,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  instructionController
                                      .screens[_currentIndex]
                                      .title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.themeColor,
                                  ),
                                ),
                              ),

                        const SizedBox(height: 32),
                        // Options List
                        if (instructionController
                            .screens[_currentIndex]
                            .options
                            .isNotEmpty)
                          _currentIndex == 0 || _currentIndex == 1
                              ? Column(children: [])
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    children: List.generate(
                                      instructionController
                                          .screens[_currentIndex]
                                          .options
                                          .length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: OptionButton(
                                          icons: instructionController
                                              .screens[_currentIndex]
                                              .icons[index],
                                          text: instructionController
                                              .screens[_currentIndex]
                                              .options[index],
                                          isSelected:
                                              _selectedOptions[_currentIndex]!
                                                  .contains(index),
                                          onTap: () {
                                            _toggleOption(index);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentIndex ==
                                  instructionController.screens.length - 1
                              ? 'Done'
                              : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_currentIndex == 2 ||
                      _currentIndex == 3 ||
                      _currentIndex == 4 ||
                      _currentIndex == 5)
                    inbannerForBottom
                        ? SizedBox(
                            width: bottomBannerAd!.size.width.toDouble(),
                            height: bottomBannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: bottomBannerAd!),
                          )
                        : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BannerAd? bottomBannerAd;
  void _loadBottomBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.of(context).size.width.truncate(),
        );
    bottomBannerAd = BannerAd(
      adUnitId: AdIds.bannerAdIdId,
      size: size ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Banner Loaded");
          setState(() {
            inbannerForBottom = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("❌ Banner Failed: $error");
          setState(() {
            inbannerForBottom = false;
          });
        },
      ),
    );
    bottomBannerAd!.load();
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final String icons;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.text,
    required this.icons,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.themeColor.withOpacity(0.9)
                : Colors.grey[300] ?? Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFE0F2F0) : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 8),
            SvgPicture.asset(
              icons,
              height: 26,
              color: isSelected ? AppColors.themeColor : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? AppColors.themeColor : Colors.black,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2BA84A),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
