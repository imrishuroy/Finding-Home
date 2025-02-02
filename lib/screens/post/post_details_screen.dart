import 'package:url_launcher/url_launcher_string.dart';
import '/screens/edit-post/edit_post_screen.dart';
import '/widgets/show_snackbar.dart';
import '/config/shared_prefs.dart';
import '/screens/post/widgets/map_view.dart';
import '/cubits/cubit/liked_posts_cubit.dart';
import '/models/post.dart';
import '/screens/dashboard/widgets/icon_count.dart';
import '/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/panorama_screen.dart';

class PostDetailsArgs {
  final Post? post;

  ///AIzaSyCMbk9Bug3L7-HFZ6WEBhILQDsxpZDsGwA
  PostDetailsArgs({required this.post});
}

class PostDetails extends StatelessWidget {
  final Post? post;
  static const String routeName = '/postDetails';
  const PostDetails({Key? key, required this.post}) : super(key: key);

  static Route route({required PostDetailsArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => PostDetails(post: args.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final likedPostsState = context.watch<LikedPostsCubit>().state;
    final isWishlist = likedPostsState.likedPostIds.contains(post?.postId);
    final _canvas = MediaQuery.of(context).size;
    print('Post details lat ${post?.geoPoint?.latitude}');
    print('Post details long ${post?.geoPoint?.longitude}');
    print('get post details -- ${SharedPrefs().getUserType}');
    return Scaffold(
      floatingActionButton: SharedPrefs().getUserType == rentee
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                if (post?.owner?.phoneNo != null) {
                  // launchUrl('');
                  launchUrlString('tel://${post?.owner?.phoneNo}');
                  //  UrlLauncher.launch('tel: xxxxxxxx');
                }
              },
              child: const Icon(Icons.call),
            )
          : null,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(PanormaScreen.routeName),
              icon: const Icon(Icons.view_in_ar)),
          if (SharedPrefs().getUserType == owner)
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                  EditPostScreen.routeName,
                  arguments: EditPostScreenArgs(post: post)),
              icon: const Icon(
                Icons.edit,
                size: 20.0,
              ),
            ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                ImageSlider(
                  imgList: post?.images,
                  bottomRadius: 12.0,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _canvas.width * 0.8,
                      child: Text(
                        post?.title ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (SharedPrefs().getUserType == rentee)
                      GestureDetector(
                        onTap: () {
                          if (isWishlist) {
                            context
                                .read<LikedPostsCubit>()
                                .unlikePost(post: post!);
                          } else {
                            ShowSnackBar.showSnackBar(context,
                                title:
                                    '${post?.title ?? 'Post'} added to your wishlist');
                            context
                                .read<LikedPostsCubit>()
                                .likePost(post: post);
                          }
                        },
                        child: Icon(
                          isWishlist ? Icons.bookmark : Icons.bookmark_add,
                          color: isWishlist ? Colors.blue : Colors.blue,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '₹${post?.price ?? ''}',
                        style: const TextStyle(
                          color: Colors.blue,
                          //color: Color(0xff00c6e9),
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                      TextSpan(
                        text: ' /mo',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14.0,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  post?.description ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // bed, kitchen baathroom
                    IconCount(
                      icon: Icons.bed,
                      count: post?.noOfBedRoom ?? 'N/A',
                      label: ' Bedroom',
                    ),
                    const Spacer(),
                    IconCount(
                      icon: Icons.kitchen_rounded,
                      count: post?.noOfKitchen,
                      label: '  Kitchen',
                    ),
                    const Spacer(),
                    IconCount(
                      icon: Icons.bathroom_outlined,
                      // icon: FontAwesomeIcons.bath,
                      count: post?.noOfBathRoom,
                      label: ' Bathroom',
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 15.0,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5.0),
                    SizedBox(
                      width: _canvas.width * 0.75,
                      child: Text(
                        post?.address ?? 'N/A',
                        style: const TextStyle(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: Colors.green,
                      size: 20.0,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(child: Text('${post?.owner?.phoneNo} (owner)')),
                  ],
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 230.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: MapView(
                      lat: post?.geoPoint?.latitude,
                      long: post?.geoPoint?.longitude,
                      enableZoomControls: false,
                    ),
                  ),
                ),
                // Image.network(
                //   'https://www.fluttercampus.com/img/uploads/web/2022/01/47a658229eb2368a99f1d032c8848542.webp',
                //   height: 250.0,
                //   width: double.infinity,
                // ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
