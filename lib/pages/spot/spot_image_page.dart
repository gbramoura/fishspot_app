import 'dart:io';

import 'package:fishspot_app/components/custom_alert_dialog.dart';
import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/enums/custom_dialog_alert_type.dart';
import 'package:fishspot_app/pages/spot/spot_fish_page.dart';
import 'package:fishspot_app/repositories/add_spot_repository.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SpotImagePage extends StatefulWidget {
  const SpotImagePage({super.key});

  @override
  State<SpotImagePage> createState() => _SpotImagePageState();
}

class _SpotImagePageState extends State<SpotImagePage> {
  final Map<Uuid, File> _images = {};

  _handleNextButton(dynamic context) {
    var route = MaterialPageRoute(builder: (context) => SpotFishPage());
    var addSpot = Provider.of<AddSpotRepository>(context, listen: false);

    if (_images.isNotEmpty) {
      addSpot.setImages(_images.entries.map((e) => e.value).toList());
    }

    NavigationService.push(context, route);
  }

  _handleAddImage() async {
    const int imagesLimit = 30;
    const List<String> imagesExtensions = [".png", ".jpg", ".jpeg"];

    var picker = ImagePicker();
    var pickedFiles = await picker.pickMultiImage(
      limit: imagesLimit - _images.length,
    );

    if (pickedFiles.isEmpty) {
      return;
    }

    for (var pickedFile in pickedFiles) {
      var id = Uuid();
      var file = File(pickedFile.path);
      var fileExtension = extension(file.path);

      if (!imagesExtensions.contains(fileExtension)) {
        _renderDialog(
          context,
          "Uma ou mais imagens não possuem a extensão esperada (PNG, JPG, JPEG)",
        );
        continue;
      }

      setState(() {
        _images.addAll({id: file});
      });
    }
  }

  _handleRemoveImage(Uuid id) {
    setState(() {
      _images.removeWhere((uuid, file) => uuid == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Flexible(child: _renderImages(context), flex: 7),
            Flexible(child: _renderNext(context), flex: 1),
          ],
        ),
      ),
    );
  }

  _renderImages(dynamic context) {
    if (_images.isEmpty) {
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
          Expanded(
            child: _renderPickedImages(context),
          )
        ],
      ),
    );
  }

  _renderPickedImages(dynamic context) {
    return GridView.count(
      primary: true,
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: _images.entries.map((e) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(e.value.path),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _handleRemoveImage(e.key),
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
      }).toList(),
    );
  }

  _renderEmptyImages(dynamic context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
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
            ),
          ),
        ],
      ),
    );
  }

  _renderNext(dynamic context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            label: _images.isEmpty ? "Pular" : "Proximo",
            onPressed: () => _handleNextButton(context),
            fixedSize: Size(182, 48),
          ),
        ],
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
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

  _renderDialog(dynamic context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: CustomDialogAlertType.warn,
          title: 'Imagens com Problemas',
          message: message,
          button: CustomButton(
            label: 'Ok',
            fixedSize: Size(double.infinity, 48),
            onPressed: () {
              NavigationService.pop(context);
            },
          ),
        );
      },
    );
  }
}
