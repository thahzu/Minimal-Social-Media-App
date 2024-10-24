import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/auth/domain/entities/app_user.dart';
import 'package:social_media/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media/features/post/presentation/components/post_tile.dart';
import 'package:social_media/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media/features/post/presentation/cubits/post_states.dart';
import 'package:social_media/features/profile/presentation/components/bio_box.dart';
import 'package:social_media/features/profile/presentation/components/follow_button.dart';
import 'package:social_media/features/profile/presentation/components/profile_stats.dart';
import 'package:social_media/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media/features/profile/presentation/cubits/profile_state.dart';
import 'package:social_media/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:social_media/features/profile/presentation/pages/follower_page.dart';
import 'package:social_media/responsive/constrained_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;

  // on startup,
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  /*

   FOLLOW/ UNFOLLOW

   */
  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return;
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    // optimistically update UI
    setState(() {
      // unfollow
      if(isFollowing){
        profileUser.followers.remove(currentUser!.uid);
      }

      // follow
      else{
        profileUser.followers.add(currentUser!.uid);
      }
    });

    // perform actual toggle in cubit
    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error){
      // revert update if there's an error
      setState(() {
        // unfollow
        if(isFollowing){
          profileUser.followers.add(currentUser!.uid);
        }

        // follow
        else{
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    // is own post
    bool isOwnPost = (widget.uid == currentUser!.uid);
    // SCAFFOLD
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // loaded
        if (state is ProfileLoaded) {
          // get loaded user
          final user = state.profileUser;
          return ConstrainedScaffold(
            // APPBAR
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                // edit profile button
                if(isOwnPost)
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        user: user,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),

            // BODY
            body: ListView(
              children: [
                // email
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // profile pic
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: user.profileImageUrl,
                      // loading
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      // error --> failed to load
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      // loaded
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // profile stats
                ProfileStats(
                  postCount: postCount,
                  followerCount: user.followers.length,
                  followingCount: user.following.length,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FollowerPage(
                            following: user.following,
                            followers: user.followers,
                        ),
                    ),
                  ),

                ),

                const SizedBox(height: 25),

                // follow button
                if(!isOwnPost)
                FollowButton(
                  onPressed: followButtonPressed,
                  isFollwing: user.followers.contains(currentUser!.uid),
                ),

                const SizedBox(height: 25),

                // bio box
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                BioBox(text: user.bio),

                // posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // list of posts from this user
                BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                  // posts loaded
                  if (state is PostsLoaded) {
                    // filter posts by user id
                    final userPosts = state.posts.where((post) => post.userId == widget.uid).toList();

                    postCount = userPosts.length;

                    return ListView.builder(
                        itemCount: postCount,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // get individual post
                          final post = userPosts[index];

                          // return as post title UI
                          return PostTile(
                            post: post,
                            onDeletePressed: () => context.read<PostCubit>().deletePost(post.id),
                          );
                        });
                  }
                  // posts loading..
                  else if (state is PostsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(
                      child: Text("No post.."),
                    );
                  }
                }),
              ],
            ),
          );
        }

        // loading..
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Center(
            child: Text("No profile found..."),
          );
        }
      },
    );
  }
}
