/*

POST STATES

 */

import 'package:social_media/features/post/domain/entities/post.dart';

abstract class PostState{}

  // initial
class PostInitial extends PostState{}

// loading
class PostsLoading extends PostState{}

// uploading...
class PostUpLoading extends PostState{}

// error
class PostsError extends PostState{
  final String message;
  PostsError(this.message);
}

// loaded
class PostsLoaded extends PostState{
  final List<Post> posts;
  PostsLoaded(this.posts);
}