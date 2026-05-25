import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../ representative/shipment/presentation/map_location_picker_screen.dart';
import '../data/profile_repository.dart';

class PersonalInfoController extends ChangeNotifier {
  String? profileImagePath;
  String? existingProfileUrl;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

  double? pickedLat;
  double? pickedLng;
  String pickedAddress = '';

  String selectedGender = 'Male';
  final List<String> genders = ['Male', 'Female', 'Other'];

  bool isLoading = false;
  String errorMessage = '';

  final _repo = ProfileRepository(apiService: ApiService());

  int get bioCharCount => bioController.text.length;

  void onBioChanged() => notifyListeners();

  Future<void> loadProfile() async {
    isLoading = true;
    notifyListeners();
    try {
      final res = await _repo.getMyProfile();
      if (res['success'] == true) {
        final data = res['data'] as Map<String, dynamic>;
        fullNameController.text = data['fullName']?.toString() ?? '';
        addressController.text = data['address']?.toString() ?? '';
        bioController.text = data['bio']?.toString() ?? '';
        designationController.text = data['designation']?.toString() ?? '';
        existingProfileUrl = data['profileUrl']?.toString();
        final coords =
            (data['location'] as Map<String, dynamic>?)?['coordinates'] as List?;
        if (coords != null && coords.length >= 2) {
          pickedLng = (coords[0] as num?)?.toDouble();
          pickedLat = (coords[1] as num?)?.toDouble();
          if (pickedLat != null && pickedLng != null) {
            pickedAddress =
                '${pickedLat!.toStringAsFixed(6)}, ${pickedLng!.toStringAsFixed(6)}';
          }
        }
        errorMessage = '';
      }
    } catch (_) {}
    isLoading = false;
    notifyListeners();
  }

  Future<void> pickLocation(BuildContext context) async {
    final initial = (pickedLat != null && pickedLng != null)
        ? LatLng(pickedLat!, pickedLng!)
        : null;
    final result = await Navigator.push<LocationPickResult>(
      context,
      MaterialPageRoute(
        builder: (_) => MapLocationPickerScreen(initialPosition: initial),
      ),
    );
    if (result != null) {
      pickedLat = result.lat;
      pickedLng = result.lng;
      pickedAddress = result.address;
      notifyListeners();
    }
  }

  Future<void> useCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      pickedLat = pos.latitude;
      pickedLng = pos.longitude;
      pickedAddress =
          '${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)}';
      notifyListeners();
    } catch (_) {}
  }

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      profileImagePath = picked.path;
      notifyListeners();
    }
  }

  void setGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final map = <String, dynamic>{
        'fullName': fullNameController.text.trim(),
        'bio': bioController.text.trim(),
      };
      if (addressController.text.trim().isNotEmpty) {
        map['address'] = addressController.text.trim();
      }
      if (designationController.text.trim().isNotEmpty) {
        map['designation'] = designationController.text.trim();
      }
      // GeoJSON: [longitude, latitude]
      if (pickedLat != null && pickedLng != null) {
        map['coordinates'] = [pickedLng!, pickedLat!];
      }
      if (profileImagePath != null) {
        map['profile'] = await MultipartFile.fromFile(
          profileImagePath!,
          filename: 'profile.jpg',
        );
      }

      final res = await _repo.updateMyProfile(FormData.fromMap(map));
      if (res['success'] == true) {
        isLoading = false;
        notifyListeners();
        return true;
      }
      errorMessage = res['message']?.toString() ?? 'Update failed';
    } on ServerException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    dobController.dispose();
    bioController.dispose();
    designationController.dispose();
    super.dispose();
  }
}
