import 'package:flutter/cupertino.dart';
import 'package:ghana_to_germany/Application/Abstractions/Services/IAuthProvider.dart';
import 'package:ghana_to_germany/Application/Providers/shared/errorNotifier.mixin.dart';
import 'package:ghana_to_germany/Application/Providers/shared/form_status.dart';
import 'package:ghana_to_germany/Application/UseCases/_usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/completeProfile.usecase.dart';
import 'package:ghana_to_germany/Application/UseCases/getProfile.usecase.dart';
import 'package:ghana_to_germany/Domain/Profile/profile.dart';

class ProfileViewModel extends ChangeNotifier with ErrorNotifierMixin {
  final IAuthProvider authProvider;
  final CompleteProfileUseCase completeProfileUseCase;
  final GetProfileUseCase getProfileUseCase;

  ProfileViewModel({required this.authProvider, required this.completeProfileUseCase, required this.getProfileUseCase});

  bool? _isProfilePending;
  bool? get isProfilePending => _isProfilePending;

  Profile? _profile;
  Profile? get profile => _profile;

  // add form status
  FormStatus _status = FormStatus.INIT;
  FormStatus get status => _status;

  // create text editing controllers for complete profile payload
  final TextEditingController _firstNameController = TextEditingController();
  TextEditingController get firstNameController => _firstNameController;

  final TextEditingController _lastNameController = TextEditingController();
  TextEditingController get lastNameController => _lastNameController;

  final TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController get phoneNumberController => _phoneNumberController;

  final TextEditingController _countryController = TextEditingController();
  TextEditingController get countryController => _countryController;


  void getProfileCompletionStatus() {
    //_isProfilePending = authProvider.getProfileCompletionStatus();
    notifyListeners();
  }

  Future getProfile() async
  {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var profile = await getProfileUseCase.execute(Nothing());
      _profile = profile;

      if (_profile == null) {
        _isProfilePending = true;
      } else {
        _isProfilePending = false;
      }

      notifyListeners();
    } catch (e) {
      _status = FormStatus.FAILED;
      notifyListeners();

      notifyError(e.toString());
    }
  }

  // code to complete profileÏ
  Future completeProfileSetup() async {
    try {
      _status = FormStatus.LOADING;
      notifyListeners();

      var payload = CompleteProfilePayload(
        firstName: _firstNameController.value.text,
        lastName: _lastNameController.value.text,
        phoneNumber: _phoneNumberController.value.text,
        country: _countryController.value.text,
      );

      await completeProfileUseCase.execute(payload);

      // set profile completion status to true
      authProvider.setProfileCompletionStatus(false);
      _isProfilePending = false;
      _status = FormStatus.SUCCESSFUL;
      notifyListeners();
    } catch (e) {
      _status = FormStatus.FAILED;
      notifyListeners();

      notifyError(e.toString());
    }
  }

  void resetState() {
    _status = FormStatus.INIT;

    // clear text editing controllers
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneNumberController.clear();
    _countryController.clear();

    notifyListeners();
  }
}
