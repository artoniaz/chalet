import 'package:chalet/models/index.dart';
import 'package:chalet/widgets/index.dart';
import 'package:flutter/material.dart';

class ImagesHorizontalListView extends StatelessWidget {
  final ChaletModel chalet;
  const ImagesHorizontalListView({
    Key? key,
    required this.chalet,
  }) : super(key: key);

  void _openPhotoGallery(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (_) => ProductDetailsPhotoGallery(
              chaletModelUrlList: chalet.images,
              initialPage: index,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: chalet.images.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => _openPhotoGallery(context, index),
        child: Container(
          width: 160,
          child: Hero(
            tag: chalet.images[index].imageUrlOriginalSize,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: CustomCachedNetworkImage(
                itemUrl: chalet.images[index].imageUrlOriginalSize,
              ),
            ),
          ),
        ),
      ),
      separatorBuilder: (context, index) => HorizontalSizedBox4(),
    );
  }
}
