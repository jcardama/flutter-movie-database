import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback onTryAgain;

  ErrorMessage({
    @required this.message,
    @required this.icon,
    this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.message,
            style: Theme.of(context).textTheme.subhead,
          ),
          SizedBox(
            height: 15,
          ),
          Icon(
            this.icon,
            color: Colors.black54,
          ),
          Visibility(
            visible: this.onTryAgain != null,
            child: RaisedButton(
              child: Text('Try again'),
              color: Theme.of(context).primaryColor,
              onPressed: () => onTryAgain(),
            ),
          )
        ],
      ),
    );
  }
}
