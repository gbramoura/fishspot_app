import 'package:fishspot_app/components/custom_button.dart';
import 'package:fishspot_app/utils/hex_color_utils.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderUserDescription(context),
            Divider(color: HexColor('#E2E8F0'), thickness: 0.3),
            _renderSpotRegistered(context),
          ],
        ),
      ),
    );
  }

  _renderUserDescription(dynamic context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: HexColor('#D9D9D9'),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: HexColor('#D9D9D9')),
                ),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/fish-spot-icon.png'),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gabriel Alves de Moura',
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Trabalho com programação, entretanto sou pescador nas horas vagas 🐟 🐟 🐟 🐟 🦈',
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('1'),
                  Text('Registros'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text('4'),
                  Text('Peixes'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text('6'),
                  Text('Iscas'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
          child: CustomButton(
            label: 'Editar Perfil',
            onPressed: () {},
            fixedSize: Size(double.maxFinite, 38),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  _renderSpotRegistered(dynamic context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pescas Registradas',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          Column(
            // TODO: Make the list after create the spot
            children: [
              Container(
                width: 124,
                height: 124,
                decoration: BoxDecoration(
                  color: HexColor('#D9D9D9'),
                  border: Border.all(width: 1, color: HexColor('#D9D9D9')),
                ),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/fish-spot-icon.png'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _renderAppBar(dynamic context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          //SizedBox(width: 5),
          Text(
            'FishSpot',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.headlineLarge?.color,
              fontSize: 22,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
          color: Theme.of(context).textTheme.headlineLarge?.color,
          iconSize: 32,
        ),
        SizedBox(width: 10)
      ],
    );
  }
}
