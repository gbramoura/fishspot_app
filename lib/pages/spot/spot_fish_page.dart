import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/constants/colors_constants.dart';
import 'package:fishspot_app/extensions/string_extension.dart';
import 'package:fishspot_app/pages/spot/spot_about_page.dart';
import 'package:fishspot_app/pages/spot/spot_add_fish_page.dart';
import 'package:fishspot_app/providers/spot_repository.dart';
import 'package:fishspot_app/services/navigation_service.dart';
import 'package:fishspot_app/utils/spot_view_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SpotFishPage extends StatefulWidget {
  const SpotFishPage({super.key});

  @override
  State<SpotFishPage> createState() => _SpotFishPageState();
}

class _SpotFishPageState extends State<SpotFishPage> {
  _handleNextButton(dynamic context) {
    NavigationService.push(
      context,
      MaterialPageRoute(builder: (context) => SpotAboutPage()),
    );
  }

  _handleAddFish() async {
    NavigationService.push(
      context,
      MaterialPageRoute(builder: (context) => SpotAddFishPage()),
    );
  }

  _handleRemoveFish(Uuid id) {
    var repo = Provider.of<SpotRepository>(context, listen: false);
    var fishes = repo.getFishes();

    var updatedFishes = fishes.where((file) => file.id != id).toList();
    repo.setFishes(updatedFishes);
  }

  @override
  Widget build(BuildContext buildContext) {
    return Consumer<SpotRepository>(builder: (context, value, widget) {
      return Scaffold(
        appBar: _renderAppBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Flexible(child: _renderFishes(context, value), flex: 9),
              Flexible(child: _renderNext(context, value), flex: 1),
              SizedBox(height: 30),
            ],
          ),
        ),
      );
    });
  }

  _renderFishes(BuildContext context, SpotRepository value) {
    var fishes = value.getFishes();

    if (fishes.isEmpty) {
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
            child: _renderPickedFishes(context, value),
          )
        ],
      ),
    );
  }

  _renderPickedFishes(BuildContext context, SpotRepository value) {
    var fishes = value.getFishes();

    return ListView.builder(
      scrollDirection: Axis.vertical,
      primary: false,
      shrinkWrap: true,
      itemCount: fishes.length,
      itemBuilder: (context, index) {
        final fish = fishes[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.headlineLarge?.color,
            border: Border.all(
              color: ColorsConstants.gray50,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          fish.name.toTitleCase,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.labelMedium?.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '●',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.labelMedium?.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${fish.weight} ${SpotViewUtils.getUnitMeasure(fish.unitMeasure)}',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.labelMedium?.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    Text(
                      fish.lures.join(', ').toTitleCase,
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelMedium?.color,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _handleRemoveFish(fish.id),
                      child: Icon(
                        Icons.delete,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                        size: 24,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _renderEmptyFishes(BuildContext context) {
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

  _renderNext(BuildContext context, SpotRepository value) {
    var fishes = value.getFishes();

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            label: "Proximo",
            onPressed: fishes.isEmpty ? null : () => _handleNextButton(context),
            fixedSize: Size(182, 48),
          ),
        ],
      ),
    );
  }

  _renderAppBar(BuildContext context) {
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
