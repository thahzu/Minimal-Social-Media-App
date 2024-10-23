import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/profile/domain/entities/profile_user.dart';
import 'package:social_media/features/profile/domain/repo/profile_repo.dart';
import 'package:social_media/features/profile/presentation/cubits/profile_state.dart';
import 'package:social_media/features/storage/domain/sotorage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.profileRepo,
    required this.storageRepo,
  }) : super(ProfileInitial());

  // Fetch user profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError("Error fetching user profile: $e"));
    }
  }

  // return user profile given uid -> useful for loading many profiles for posts
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  // Update bio and/or profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());

    try {
      // Fetch current profile first
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      // Profile picture update
      String? imageDownloadUrl;

      // Ensure there is an image
      if (imageWebBytes != null || imageMobilePath != null) {
        // For mobile
        if (imageMobilePath != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
          print('Mobile image upload result: $imageDownloadUrl');
        }
        // For web
        else if (imageWebBytes != null) {
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
          print('Web image upload result: $imageDownloadUrl');
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError("Failed to upload image"));
          return;
        }
      }

      // Update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      // Update in repo
      await profileRepo.updateProfile(updatedProfile);

      // Re-fetch updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}
