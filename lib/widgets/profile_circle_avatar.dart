import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:flutter/material.dart';

class ProfileCircleAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ProfileCircleAvatar({
    super.key,
    required this.imageUrl,
    this.size = 1,
  });

  Widget _handleBuilder(dynamic ctx, String url, DownloadProgress download) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsConstants.gray75,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: ColorsConstants.gray350,
        ),
      ),
    );
  }

  Widget _handleError(dynamic ctx, String url, dynamic obj) {
    return _renderEmptyImage();
  }

  Widget _renderEmptyImage() {
    return Container(
      width: (100 * size),
      height: (100 * size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsConstants.gray75,
      ),
      child: Icon(
        Icons.person,
        size: (80 * size),
        color: ColorsConstants.gray150,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _renderEmptyImage();
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: (100 * size),
        fit: BoxFit.cover,
        progressIndicatorBuilder: _handleBuilder,
        errorWidget: _handleError,
      ),
    );
  }
}
