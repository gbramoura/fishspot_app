import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/models/spot_fish.dart';
import 'package:fishspot_app/pages/spot/spot_add_fish_page.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SpotFishPage extends StatefulWidget {
  const SpotFishPage({super.key});

  @override
  State<SpotFishPage> createState() => _SpotFishPageState();
}

class _SpotFishPageState extends State<SpotFishPage> {
  final Map<Uuid, SpotFish> _images = {};

  _handleNextButton(dynamic context) {
    // var route = MaterialPageRoute(builder: (context) => SpotFishPage());
    // var addSpot = Provider.of<AddSpotRepository>(context, listen: false);

    // NavigationService.push(context, route);
  }

  _handleAddFish() {
    NavigationService.push(
      context,
      MaterialPageRoute(builder: (context) => SpotAddFishPage()),
    );
  }

  _handleRemoveFish(Uuid id) {
    setState(() {
      _images.removeWhere((uuid, fish) => uuid == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Flexible(child: _renderFishes(context), flex: 7),
            Flexible(child: _renderNext(context), flex: 1),
          ],
        ),
      ),
    );
  }

  _renderFishes(dynamic context) {
    if (_images.isEmpty) {
      return _renderEmptyFishes(context);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Peixes Registrados',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: _renderPickedFishes(context),
          )
        ],
      ),
    );
  }

  _renderPickedFishes(dynamic context) {
    return Column();
  }

  _renderEmptyFishes(dynamic context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.image_not_supported,
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                  size: 90,
                ),
                Text(
                  'Nenhum peixe \n registrado',
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
            label: "Proximo",
            onPressed: _images.isEmpty ? null : _handleNextButton(context),
            fixedSize: Size(182, 48),
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
            'Especies de Peixe',
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
          onPressed: _handleAddFish,
          icon: Icon(Icons.add),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        SizedBox(width: 10)
      ],
    );
  }
}
