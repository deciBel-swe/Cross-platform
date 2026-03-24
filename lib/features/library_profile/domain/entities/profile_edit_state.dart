import 'dart:io';

class ProfileEditState {

  ProfileEditState({
    this.localProfilePic,
    this.localCoverPic,
    this.isLoading = false,
    this.errorMessage,
  });
  final File? localProfilePic;
  final File? localCoverPic;
  final bool isLoading;
  final String? errorMessage;

  ProfileEditState copyWith({
    File? localProfilePic,
    File? localCoverPic,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileEditState(
      localProfilePic: localProfilePic ?? this.localProfilePic,
      localCoverPic: localCoverPic ?? this.localCoverPic,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, 
    );
  }
}