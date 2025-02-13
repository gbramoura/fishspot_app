import 'package:fishspot_app/src/utils/hex_color_utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor('#292A2C'),
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Image(
                    height: 250,
                    width: 250,
                    image: AssetImage('assets/images/fish-spot-icon.png'),
                  ),
                ),
              ),
              Text(
                'Bem-Vindo',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: HexColor('#F8FAFC'),
                    fontWeight: FontWeight.w500,
                    fontSize: 42),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 45),
                child: Text(
                  "Seja bem vindo ao aplicativo para registro de locais de pesca",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HexColor('#E2E8F0'),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'E-mail',
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Senha',
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      color: HexColor('#F8FAFC'),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(286, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: HexColor('#00D389'),
                  ),
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      color: HexColor('#35383A'),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não possui uma conta?',
                        style: TextStyle(
                          color: HexColor('#F8FAFC'),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Registre-se',
                          style: TextStyle(
                            color: HexColor('#00D389'),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
