import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  var currentAddress = 'Tap to set location...'.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()!.containsKey('address')) {
        currentAddress.value = doc['address'];
      }
    }
  }

  Future<void> updateAddress(String newAddress) async {
    if (newAddress.trim().isNotEmpty) {
      currentAddress.value = newAddress;
      await _saveToFirebase(newAddress);
    }
  }

  Future<void> _saveToFirebase(String address) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {'address': address},
        SetOptions(merge: true),
      );
    }
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled.');
        isLoading.value = false;
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied');
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied, we cannot request permissions.');
        isLoading.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        
        // Clean up leading commas or spaces if any fields are empty
        address = address.replaceAll(RegExp(r'(^,\s*)|(,\s*null)'), '').replaceAll(', , ', ', ');
        
        currentAddress.value = address;
        await _saveToFirebase(address);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
