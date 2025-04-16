import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imageUrl;

  const CustomCircleAvatar({super.key, required this.imageUrl});

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
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsConstants.gray75,
      ),
      child: Icon(
        Icons.person,
        size: 80,
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
        width: 100,
        fit: BoxFit.cover,
        progressIndicatorBuilder: _handleBuilder,
        errorWidget: _handleError,
      ),
    );
  }
}
