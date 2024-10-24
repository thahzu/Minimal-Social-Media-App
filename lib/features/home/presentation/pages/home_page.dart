import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/home/presentation/component/my_drawer.dart';
import 'package:social_media/features/post/presentation/components/post_tile.dart';
import 'package:social_media/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_media/features/post/presentation/cubits/post_states.dart';
import 'package:social_media/features/post/presentation/pages/upload_post_page.dart';
import 'package:social_media/responsive/constrained_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// BUILD UI
class _HomePageState extends State<HomePage> {
  // post cubit
  late final postCubit = context.read<PostCubit>();

  // on startup
  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    // Thực hiện xóa bài viết
    postCubit.deletePost(postId);

    // Cập nhật lại danh sách bài viết trong UI sau khi xóa
    setState(() {
      postCubit.fetchAllPosts();  // Hoặc cập nhật trực tiếp danh sách nếu có dữ liệu cục bộ
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: const Text("INSTAGRAM"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPostPage()),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // loading..
          if (state is PostsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(
                child: Text("No post available"),
              );
            }
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                final post = allPosts[index];

                return PostTile(
                  post: post,
                  onDeletePressed: () {
                    deletePost(post.id);
                    setState(() {
                      allPosts.removeAt(index);
                    });
                  },
                );
              },
            );
          }

          // error
          else if (state is PostsError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
