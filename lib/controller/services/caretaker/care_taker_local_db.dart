import 'package:care_connect/model/care_taker_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CareTakerLocalService {
  final box = GetStorage();
  // Store the JSON representation in GetStorage
  void saveToGetStorage(Map<String, dynamic> data) {
    box.write('caretaker', data);
  }

  // Retrieve from GetStorage
  CareTakerModel retrieveFromGetStorage() {
    final a = box.read('caretaker') ?? {};
    CareTakerModel careTakerModel =
        CareTakerModel.fromJson(a as Map<String, dynamic>);
    return careTakerModel;
  }

  // Update in GetStorage
  void updateInGetStorage(Map<String, dynamic> data) {
    debugPrint(data.toString());

    box.write('caretaker', data);
  }

  // Delete from GetStorage
  void deleteFromGetStorage() {
    box.remove('caretaker');
  }
}
