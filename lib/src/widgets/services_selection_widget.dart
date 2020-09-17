import 'package:flutter/material.dart';

class ServicesSelectionWidget extends StatefulWidget {
  final Map<String, IconData> services;
  final Function(String) onValueChanged;

  ServicesSelectionWidget({Key key, this.services, this.onValueChanged}) : super(key: key);

  @override
  _ServicesSelectionWidgetState createState() => _ServicesSelectionWidgetState();
}

class ServiceWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected; 
  const ServiceWidget({Key key, this.name, this.icon, this.selected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: selected ? Theme.of(context).accentColor : Colors.grey,
                width: selected ? 3.0 : 1.0 
              )
            ),
            child: Icon(icon),
          ),
          Text(name, style: TextStyle(
            color: selected ? Theme.of(context).accentColor : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          ),)
        ],
      ),
    );
  }
}

class _ServicesSelectionWidgetState extends State<ServicesSelectionWidget> {
  String currentItem = '';
  
  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widget.services.forEach((name, icon) {
      widgets.add(
        GestureDetector(
          onTap: (){
            setState(() {
              currentItem = name;
            });
            widget.onValueChanged(name);
          },
          child: ServiceWidget(
            name: name,
            icon: icon,
            selected: name == currentItem,
          ),
        )
      );
    });
    
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
       
  }
}