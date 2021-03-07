import 'package:flutter/material.dart';

class Anwser extends StatelessWidget {
  final Function selectHandler;
  final String? anwserText;

  Anwser(this.selectHandler, this.anwserText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(anwserText!),
        onPressed: selectHandler as void Function()?,
      ),
    );
  }
}
