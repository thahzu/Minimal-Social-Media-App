import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/post/domain/entities/comment.dart';
import 'package:social_media/features/post/domain/entities/post.dart';
import 'package:social_media/features/post/domain/repos/post_repo.dart';
import 'package:social_media/features/post/presentation/cubits/post_states.dart';
import 'package:social_media/features/storage/domain/sotorage_repo.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostInitial());

  // create a new post
  Future<void> createPost(Post post, {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      // handle image upload for mobile platforms
      if (imagePath != null) {
        emit(PostUpLoading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      // handle image upload for web platforms
      else if (imageBytes != null) {
        emit(PostUpLoading());
        imageUrl = await storageRepo.uploadProfileImageWeb(imageBytes, post.id);
      }

      // give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // create post in backend
      postRepo.createPost(newPost);

      // re-fetch all posts
      fetchAllPosts();
    } catch (e) {
      // Emit post creation error state
      emit(PostsError("Failed to create post: $e"));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to fetch posts: $e"));
    }
  }

  // delete posts
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {}
  }

  // toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }

  // add a comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

  // delete comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}
