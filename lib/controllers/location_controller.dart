import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  var currentAddress = 'Tap to set location...'.obs;
  var isLoading = false.obs;
  var savedAddresses = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data.containsKey('address')) {
            currentAddress.value = data['address'];
          }
          if (data.containsKey('savedAddresses') && data['savedAddresses'] is List) {
            final List<dynamic> list = data['savedAddresses'];
            savedAddresses.value = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          } else {
            _seedDefaultAddresses();
          }
        } else {
          _seedDefaultAddresses();
        }
      } catch (e) {
        _seedDefaultAddresses();
      }
    } else {
      _seedDefaultAddresses();
    }
  }

  void _seedDefaultAddresses() {
    savedAddresses.value = [
      {
        'title': 'Other',
        'distance': 0.4,
        'address': '1288, Platinum hostel, 1288, Phase 5, Sector 59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
        'type': 'other',
      },
      {
        'title': 'Other (2)',
        'distance': 0.6,
        'address': '1895, 1895, Phase 5, Sector 59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
        'type': 'other',
      },
      {
        'title': 'Home',
        'distance': 0.2,
        'address': '1567, 1566, Phase 5, sector:59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
        'type': 'home',
      },
      {
        'title': 'Work',
        'distance': 202.8,
        'address': 'khalsa college, computer science department, 17, Near Bhandari Bridge, Katra Jaimal Singh, Kt. Jaim...',
        'type': 'work',
      },
    ];
  }

  Future<void> addAddress({
    required String title,
    required String address,
    double distance = 0.5,
    String type = 'other',
  }) async {
    savedAddresses.add({
      'title': title,
      'distance': distance,
      'address': address,
      'type': type,
    });
    await _saveSavedAddressesToFirebase();
  }

  Future<void> deleteAddress(int index) async {
    if (index >= 0 && index < savedAddresses.length) {
      savedAddresses.removeAt(index);
      await _saveSavedAddressesToFirebase();
    }
  }

  Future<void> _saveSavedAddressesToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {'savedAddresses': savedAddresses.toList()},
          SetOptions(merge: true),
        );
      } catch (e) {
        // Silently handle if offline
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
