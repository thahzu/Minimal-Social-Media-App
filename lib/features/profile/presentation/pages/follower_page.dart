import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/app.dart';
import 'package:social_media/features/profile/presentation/components/user_title.dart';
import 'package:social_media/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media/responsive/constrained_scaffold.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;
  const FollowerPage({
    super.key,
    required this.following,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {

    // TAB CONTROLLER
    return DefaultTabController(
        length: 2,
        child: ConstrainedScaffold(
          // app bar
          appBar:AppBar(

            // Tab bar
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
            Tab(text: "Followers"),
            Tab(text: "Following"),
          ],
          ),
        ),

          // Tab bar view
          body: TabBarView(children: [
            _buildUserList(followers, "No follower", context),
            _buildUserList(following, "No following", context),
            ]),
        ),
    );
  }

  // build user list, given a list of profile uids
Widget _buildUserList(
    List<String> uids, String emptyMessage, BuildContext context){
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
      itemCount: uids.length,
        itemBuilder: (context, index){
        // get each uid
          final uid = uids[index];

          return FutureBuilder(
              future: context.read<ProfileCubit>().getUserProfile(uid),
              builder: (context, snapshot){
                // users loaded
                if(snapshot.hasData){
                  final user = snapshot.data!;
                  return UserTitle(user: user);
                }

                //loading...
                else if(snapshot.connectionState ==
                ConnectionState.waiting){
                  return ListTile(title: Text("Loading.."));
                }

                // not found...
                else{
                  return ListTile(title: Text("User not found.."));
                }
              },
          );
        }
    );
}

}
