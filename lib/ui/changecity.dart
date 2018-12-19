import 'package:flutter/material.dart';

class ChangeCity extends StatelessWidget {

  var _cityFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Enter City Name")
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/white_snow.png', height: 900.0 ,fit: BoxFit.fitHeight,),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter City Name",
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                )
              ),
              ListTile(
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'enter': _cityFieldController.text
                    });
                  },
                  textColor: Colors.white70,
                  color: Colors.blueAccent,
                  child: Text("Get The Weather"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}