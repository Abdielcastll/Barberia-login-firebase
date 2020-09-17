import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nuevoproyecto/src/pages/details_page.dart';
import 'package:nuevoproyecto/src/widgets/graph.dart';

enum GraphType{
  LINE,
  PIE,
}

class Month extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> services;
  final GraphType graphType;
  final int month;
  final String userName;
  final String userPhoto;

  Month({Key key, this.documents, this.userName, this.userPhoto, this.month, this.graphType, days}) :
  total = documents.map((doc) => doc.get('value'))
      .fold(0.0, (a, b) => a + b),
  perDay = List.generate(days, (int index) {
    return documents.where((doc) => doc.get('day') == (index + 1))
      .map((doc) => doc.get('value'))
      .fold(0.0, (a, b) => a + b);
  }),
  services = documents.fold({}, (Map<String, double>map, document){
    if (!map.containsKey(document.get('name'))){
      map[document.get('name')] = 0.0;
    }
      map[document.get('name')] += document.get('value');
      return map;
  }),
  super(key: key);

  @override
  _MonthState createState() => _MonthState();
}

class _MonthState extends State<Month> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
       child: ListView(
         children: [
          _expenses(),
          _graph(),
          Container(
            height: 16.0,
            color: Theme.of(context).accentColor.withOpacity(0.2),
          ),
          _list()
         ],
       )
    );
  }

   Widget _expenses() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                image: DecorationImage(image: NetworkImage(widget.userPhoto))
              ),
            ),
            Text(widget.userName, style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total generado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.blueGrey
          ),
        ),
        Text('\$${widget.total.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        Text('20% Ganancia: \$${(widget.total * 0.2).toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    )
      ],
    );
    
    
    
  }

  Widget _graph() {
    if(widget.graphType == GraphType.LINE){
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      height: 200.0,
      child: LinesGraphWidget(
        data: widget.perDay
      )
    );
    } else {
      var perServices = widget.services.keys.map((name) => widget.services[name] / widget.total).toList();
      return  Container(
      height: 200.0,
      child: PieGraphWidget(
        data: perServices
      )
    );
    }
  } 

  Widget _list() {
    return Expanded(
      child: SizedBox(height: MediaQuery.of(context).size.height,
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.services.keys.length,
          itemBuilder: (context, index) {
           var key = widget.services.keys.elementAt(index);
           var data = widget.services[key];
           return _item(FontAwesomeIcons.cut, key, (data * 0.20).toString(), data);
          },
          separatorBuilder: (context, index) { 
            return Container(
              height: 8.0,
              color: Theme.of(context).accentColor.withOpacity(0.2),
            );
          }
        ),
      ),
    );
  }

  Widget _item(IconData icon, String name, String precio, double value,){
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/details', arguments: DetailsParams(name, widget.month));
      },
      leading: Icon(icon, color: Colors.deepOrangeAccent,),
      title: Text(name,
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
      ),
      subtitle: Text('Ganancia: \$$precio',
        style: TextStyle(
          fontSize: 16.0,
          color: Theme.of(context).accentColor
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("\$$value",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold
            ),  
          ),
        ),
      ),
    );
  }
}