import 'package:flutter/material.dart';

class AlertDeleteList extends StatelessWidget {
  final primaryColor = Color(0xFFF21905);
  Function function;
  AlertDeleteList({
    this.function,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      backgroundColor: Colors.grey[100],
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: primaryColor,
                  size: 35,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(
              top: 50,
              bottom: 20,
            ),
            child: Column(
              children: [
                Center(
                    child: Icon(
                  Icons.circle,
                  color: primaryColor,
                  size: 50,
                )),
                Container(
                    padding: EdgeInsets.only(
                      top: 30,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Você deseja realmente apagar sua lista?',
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '\n\nApós confirmação, todos os dados seram apagados.',
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]),
                    )),
              ],
            ),
          ),
        ],
      ),
      content: GestureDetector(
          onTap: function,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: primaryColor,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: primaryColor,
              child: Center(
                child: Text('Apagar Lista',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    )),
              ),
            ),
          )),
    );
  }
}
