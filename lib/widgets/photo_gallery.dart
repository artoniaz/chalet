import 'package:Challet/models/image_model_url.dart';
import 'package:Challet/widgets/index.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/material.dart';

class ProductDetailsPhotoGallery extends StatefulWidget {
  final int initialPage;
  final List<ImageModelUrl> chaletModelUrlList;

  const ProductDetailsPhotoGallery({
    Key? key,
    required this.initialPage,
    required this.chaletModelUrlList,
  }) : super(key: key);

  @override
  _ProductDetailsPhotoGalleryState createState() => _ProductDetailsPhotoGalleryState();
}

class _ProductDetailsPhotoGalleryState extends State<ProductDetailsPhotoGallery> {
  late int currentIndex = widget.initialPage;
  late PageController pageController = PageController(initialPage: widget.initialPage);

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String pictureUrl = widget.chaletModelUrlList[index].imageUrlOriginalSize;
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(pictureUrl),
      tightMode: true,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: pictureUrl),
    );
  }

  void onPageChanged(int index) => setState(() => currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: GestureDetector(
          onTapUp: (_) => Navigator.pop(context),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.chaletModelUrlList.length,
                loadingBuilder: (context, e) => CustomLoadingBuilder(),
                pageController: pageController,
                backgroundDecoration: BoxDecoration(),
                onPageChanged: onPageChanged,
                scrollDirection: Axis.horizontal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
