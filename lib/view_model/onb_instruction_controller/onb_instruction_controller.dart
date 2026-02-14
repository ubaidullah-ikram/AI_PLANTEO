import 'package:plantify/constant/app_icons.dart';

class OnbInstructionController {
  final List<InstructionScreen> screens = [
    InstructionScreen(
      title: 'What is your main goal with planteo?',
      options: [
        'Learn About Plant Care',
        'Identify Plants',
        'Identify Mushrooms',
        'Get Care Reminders',
        'Diagnose My Plants Diseases',
      ],
      icons: [
        AppIcons.learn_about_plant,
        AppIcons.identify_plant,
        AppIcons.identify_mushrooms,
        AppIcons.get_care_reminders,
        AppIcons.diagnose_plants,
      ],
    ),
    InstructionScreen(
      title: 'What’s your biggest challenge in plant care?',
      options: [
        'Keeping them alive',
        'Choosing the right plants',
        'remembering to water them',
        'managing pests or diseases',
        'Right care, for each plant',
      ],
      icons: [
        AppIcons.keep_them_alive,
        AppIcons.choose_the_right,
        AppIcons.remembering_water,
        AppIcons.managing_pests,
        AppIcons.right_care,
      ],
    ),
    InstructionScreen(
      title: 'What is your main goal with planteo?',
      options: [
        'Learn About Plant Care',
        'Identify Plants',
        'Identify Mushrooms',
        'Get Care Reminders',
        'Diagnose My Plants Diseases',
      ],
      icons: [
        AppIcons.learn_about_plant,
        AppIcons.identify_plant,
        AppIcons.identify_mushrooms,
        AppIcons.get_care_reminders,
        AppIcons.diagnose_plants,
      ],
    ),
    InstructionScreen(
      title: 'What’s your biggest challenge in plant care?',
      options: [
        'Keeping them alive',
        'Choosing the right plants',
        'remembering to water them',
        'managing pests or diseases',
        'Right care, for each plant',
      ],
      icons: [
        AppIcons.keep_them_alive,
        AppIcons.choose_the_right,
        AppIcons.remembering_water,
        AppIcons.managing_pests,
        AppIcons.right_care,
      ],
    ),
    InstructionScreen(
      title: 'How experienced are you with plant care?',
      options: [
        'Beginner: I’m new to plants',
        'Intermediate: I know the basics',
        'Advamce: I’ a plant enthusiast',
      ],
      icons: [AppIcons.beginner_im, AppIcons.intermediate, AppIcons.advance_ia],
    ),
    InstructionScreen(
      title: 'What notifications would you perfer?',
      options: [
        'Care reminder',
        'Tips and tricks',
        'Plant- related facts',
        "New features and updates",
      ],
      icons: [
        AppIcons.care_calender,
        AppIcons.tips_and_tricks,
        AppIcons.plant_related,
        AppIcons.new_features,
      ],
    ),
  ];
}

class InstructionScreen {
  final String title;
  final String subtitle;
  final List<String> options;
  final List<String> icons;

  InstructionScreen({
    required this.title,
    this.subtitle = '',
    required this.options,
    required this.icons,
  });
}
