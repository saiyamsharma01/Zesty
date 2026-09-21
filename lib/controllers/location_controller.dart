import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  var currentAddress = 'Tap to set location...'.obs;
  var detectedArea = 'Phase 5'.obs;
  var detectedSubArea = 'Sector 59, Industrial Area, SAS Nagar'.obs;
  var detectedLatitude = 30.7046.obs;
  var detectedLongitude = 76.7179.obs;
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
    final user = FirebaseAuth.instance.currentUser;
    final phone = user?.phoneNumber ?? '';
    final name = (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user.displayName!
        : 'User';

    savedAddresses.value = [
      {
        'title': 'Other',
        'distance': 0.4,
        'address': '1288, Platinum hostel, 1288, Phase 5, Sector 59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
        'type': 'other',
        'houseNo': '1288',
        'buildingBlock': 'Platinum Hostel',
        'landmark': 'Near Gurudwara',
        'receiverName': name,
        'receiverPhone': phone,
      },
      {
        'title': 'Other (2)',
        'distance': 0.6,
        'address': '1895, 1895, Phase 5, Sector 59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
        'type': 'other',
        'houseNo': '1895',
        'buildingBlock': '',
        'landmark': 'Phase 5 Park',
        'receiverName': name,
        'receiverPhone': phone,
      },
      {
        'title': 'Home',
        'distance': 0.2,
        'address': '1567, 1566, Phase 5, sector:59, Sahibzada Ajit Singh Nagar, Punjab 160059, India',
        'type': 'home',
        'houseNo': '1567',
        'buildingBlock': 'Block B',
        'landmark': 'Main Market',
        'receiverName': name,
        'receiverPhone': phone,
      },
      {
        'title': 'Work',
        'distance': 202.8,
        'address': 'Khalsa College, Computer Science Department, 17, Near Bhandari Bridge, Katra Jaimal Singh',
        'type': 'work',
        'houseNo': '17',
        'buildingBlock': 'CS Dept',
        'landmark': 'Bhandari Bridge',
        'receiverName': name,
        'receiverPhone': phone,
      },
    ];
  }

  Future<void> addAddress({
    required String title,
    required String address,
    double distance = 0.5,
    String type = 'other',
    String houseNo = '',
    String buildingBlock = '',
    String landmark = '',
    String receiverName = '',
    String receiverPhone = '',
    double? latitude,
    double? longitude,
  }) async {
    savedAddresses.add({
      'title': title,
      'distance': distance,
      'address': address,
      'type': type,
      'houseNo': houseNo,
      'buildingBlock': buildingBlock,
      'landmark': landmark,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'latitude': latitude ?? detectedLatitude.value,
      'longitude': longitude ?? detectedLongitude.value,
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
        Get.snackbar('Location Service', 'Please enable GPS on your device.');
        isLoading.value = false;
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permissions are denied');
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Permission Denied', 'Location permissions are permanently denied, please enable in settings.');
        isLoading.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      detectedLatitude.value = position.latitude;
      detectedLongitude.value = position.longitude;

      List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        final areaName = place.subLocality?.isNotEmpty == true
            ? place.subLocality!
            : (place.locality?.isNotEmpty == true ? place.locality! : 'Current Location');
        
        final subAreaParts = [
          if (place.street != null && place.street!.isNotEmpty) place.street,
          if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) place.subAdministrativeArea,
          if (place.locality != null && place.locality!.isNotEmpty && place.locality != areaName) place.locality,
          if (place.postalCode != null && place.postalCode!.isNotEmpty) place.postalCode,
        ];
        
        detectedArea.value = areaName;
        detectedSubArea.value = subAreaParts.join(', ');

        String address = '${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        address = address.replaceAll(RegExp(r'(^,\s*)|(,\s*null)'), '').replaceAll(', , ', ', ');
        
        currentAddress.value = address;
        await _saveToFirebase(address);
        Get.snackbar('Location Updated', 'Located: $areaName');
      }
    } catch (e) {
      Get.snackbar('Notice', 'Using default coordinates for preview.');
    } finally {
      isLoading.value = false;
    }
  }
}
