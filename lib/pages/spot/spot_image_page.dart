import 'dart:io';

import 'package:fishspot_app/widgets/alert_modal.dart';
import 'package:fishspot_app/widgets/button.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/models/spot_image.dart';
import 'package:fishspot_app/pages/spot/spot_fish_page.dart';
import 'package:fishspot_app/providers/spot_data_provider.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SpotImagePage extends StatefulWidget {
  const SpotImagePage({super.key});

  @override
  State<SpotImagePage> createState() => _SpotImagePageState();
}

class _SpotImagePageState extends State<SpotImagePage> {
  final NavigationService _navigationService = NavigationService();

  _handleNextButton(BuildContext context) {
    _navigationService.push(
      context,
      MaterialPageRoute(builder: (context) => SpotFishPage()),
    );
  }

  _handleAddImage() async {
    const int imagesLimit = 30;
    const List<String> imagesExtensions = [".png", ".jpg", ".jpeg"];
    var spotProvider = Provider.of<SpotDataProvider>(context, listen: false);
    var images = spotProvider.getImages();

    var picker = ImagePicker();
    var pickedFiles = await picker.pickMultiImage(
      limit: imagesLimit - images.length,
    );

    if (pickedFiles.isEmpty) {
      return;
    }

    for (var pickedFile in pickedFiles) {
      var id = Uuid();
      var file = File(pickedFile.path);
      var fileExtension = path.extension(file.path);

      if (!imagesExtensions.contains(fileExtension) && mounted) {
        _renderDialog(
          context,
          "Uma ou mais imagens não possuem a extensão esperada (PNG, JPG, JPEG)",
        );
        continue;
      }

      spotProvider.addImages([
        SpotImage(id: id, file: file),
      ]);
    }
  }

  _handleRemoveImage(BuildContext context, Uuid id) {
    var spotProvider = context.read<SpotDataProvider>();
    var images = spotProvider.getImages();

    var updatedImages = images.where((file) => file.id != id).toList();
    spotProvider.setImages(updatedImages);
  }

  @override
  Widget build(BuildContext buildContext) {
    return Consumer<SpotDataProvider>(builder: (context, value, widget) {
      return Scaffold(
        appBar: _renderAppBar(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: _renderImages(context, value), flex: 9),
            Flexible(child: _renderNext(context, value), flex: 1),
            SizedBox(height: 30),
          ],
        ),
      );
    });
  }

  _renderImages(BuildContext context, SpotDataProvider value) {
    var images = value.getImages();

    if (images.isEmpty) {
      return _renderEmptyImages(context);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fotos Selecionadas',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Expanded(child: _renderPickedImages(context, value))
        ],
      ),
    );
  }

  _renderPickedImages(BuildContext context, SpotDataProvider value) {
    var images = value.getImages();

    return GridView.builder(
      primary: true,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        var image = images[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(image.file),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _handleRemoveImage(context, image.id),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(25),
                    ),
                    color: ColorsConstants.white50,
                  ),
                  padding: EdgeInsets.fromLTRB(8, 5, 5, 8),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: ColorsConstants.gray350,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _renderEmptyImages(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.no_photography,
          color: Theme.of(context).textTheme.headlineLarge?.color,
          size: 90,
        ),
        Text(
          'Nenhuma Imagem \n registrada',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  _renderNext(BuildContext context, SpotDataProvider value) {
    var images = value.getImages();

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Button(
            label: images.isEmpty ? "Pular" : "Proximo",
            onPressed: () => _handleNextButton(context),
            fixedSize: Size(182, 48),
          ),
        ],
      ),
    );
  }

  _renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      titleSpacing: 0,
      title: Row(
        children: [
          Text(
            'Fotos de Pesca',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _handleAddImage,
          icon: Icon(Icons.add_a_photo_outlined),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        SizedBox(width: 10)
      ],
    );
  }

  _renderDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertModal(
          type: CustomDialogAlertType.warn,
          title: 'Imagens com Problemas',
          message: message,
          button: Button(
            label: 'Ok',
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              _navigationService.pop(context);
            },
          ),
        );
      },
    );
  }
}
