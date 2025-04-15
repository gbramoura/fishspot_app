import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/repositories/add_spot_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpotImagePage extends StatefulWidget {
  const SpotImagePage({super.key});

  @override
  State<SpotImagePage> createState() => _SpotImagePageState();
}

class _SpotImagePageState extends State<SpotImagePage> {
  List<String> _images = [];

  _handleNextButton() {
    //var route = MaterialPageRoute(builder: (context) => SpotFishPage());
    var addSpot = Provider.of<AddSpotRepository>(context, listen: false);

    if (_images.isEmpty) {
      addSpot.setImages(_images);
    }
    //NavigationService.push(context, route);
  }

  _handleAddImage() {
    // TODO: Make this to add a file an display a list of it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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

    // TODO: render the images that was add
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
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            label: _images.isEmpty ? "Pular" : "Proximo",
            onPressed: _handleNextButton,
          ),
        ],
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      shadowColor: ColorsConstants.gray350,
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
}
