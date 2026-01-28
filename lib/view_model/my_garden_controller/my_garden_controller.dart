import 'dart:developer';
import 'dart:typed_data';

import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';
import 'package:plantify/models/mushroom_db_model.dart';
import 'package:plantify/models/plant_identify_db_model.dart';

class MyGardenController extends GetxController {
  final gardenFilterList = ["Plants", "Mushroom", "Reminders"].obs;
  final box = GetStorage();
  final plants = <SavedPlantModel>[].obs;

  final mushrooms = <SavedMushroomModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // loadPlants();
  }

  void loadPlants() {
    final data = box.read('my_plants');

    // log('the data base loaded ${data}');
    if (data != null) {
      // log('the data base loaded ${data}');
      plants.value = (data as List)
          .map((e) => SavedPlantModel.fromJson(e))
          .toList();
    }
  }

  void addPlant(SavedPlantModel plant) {
    plants.add(plant);
    box.write('my_plants', plants.map((e) => e.toJson()).toList());
  }

  void loadMushrooms() {
    final data = box.read('my_mushrooms');
    if (data != null) {
      mushrooms.value = (data as List)
          .map((e) => SavedMushroomModel.fromJson(e))
          .toList();
    }
    log('🍄 Loaded mushrooms: ${mushrooms.length}');
  }

  void addMushroom(SavedMushroomModel mushroom) {
    mushrooms.add(mushroom);
    box.write('my_mushrooms', mushrooms.map((e) => e.toJson()).toList());
  }

  void deleteMushroom(int index) {
    mushrooms.removeAt(index);
    box.write('my_mushrooms', mushrooms.map((e) => e.toJson()).toList());
  }

  final selectFilter = 0.obs;
}
