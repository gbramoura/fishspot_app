import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class ProfileImageCard extends StatelessWidget {
  final String image;
  final String title;
  final void Function()? onTap;

  final ImageService _imageService = ImageService();

  ProfileImageCard({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final decorationIcon = DecorationImage(
      image: Svg('assets/no-photography.svg'),
      fit: BoxFit.none,
    );

    final decorationImage = DecorationImage(
      fit: BoxFit.cover,
      image: NetworkImage(_imageService.getImagePath(context, image)),
    );

    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: ColorsConstants.gray75,
          image: image.isNotEmpty ? decorationImage : decorationIcon,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                height: 32,
                padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                color: Color.fromRGBO(0, 0, 0, 0.35),
                child: Center(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorsConstants.gray50,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
