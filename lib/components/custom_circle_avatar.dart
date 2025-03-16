import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imageUrl;

  const CustomCircleAvatar({super.key, required this.imageUrl});

  Widget _handleBuilder(dynamic ctx, Widget child, ImageChunkEvent? loading) {
    if (loading == null) {
      return child;
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsConstants.gray100,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: ColorsConstants.gray350,
        ),
      ),
    );
  }

  Widget _handleError(dynamic ctx, Object exception, StackTrace? trace) {
    return _renderEmptyImage();
  }

  Widget _renderEmptyImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsConstants.gray100,
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
      child: Image.network(
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        loadingBuilder: _handleBuilder,
        errorBuilder: _handleError,
      ),
    );
  }
}
