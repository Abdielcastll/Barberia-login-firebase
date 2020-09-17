import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nuevoproyecto/src/login_state.dart';
import 'package:nuevoproyecto/src/widgets/services_selection_widget.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String service;
  int value = 0;
  bool onPress = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Servicios',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close,
              color: Colors.grey,
            ), 
            onPressed: (){
              Navigator.of(context).pop();
            }
          )
        ],
      ),
      body: _body(),   
    );
  }

  Widget _body(){
    return Column(
      children: [
        _servicesSelector(),
        _currentValue(),
        _numPad(),
        _submit()
      ],
    );
  }

  Widget _servicesSelector() {
    return Container(
      height: 80.0,
      child: ServicesSelectionWidget(
        services: {
          'Corte' : Icons.content_cut,
          'Tinte' : FontAwesomeIcons.tint,
          'Secado': Icons.beach_access,
          'Barba' : Icons.face,
          'Facial': Icons.mood,
        },
        onValueChanged: (newService) => service = newService,
      ),
    );
  } 
  
  
  Widget _currentValue() {
    var realValue = value / 100.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:30.0),
      child: Text('\$${realValue.toStringAsFixed(2)}',
        style: TextStyle(
          fontSize: 50.0,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _num(String text, double height){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onPress = true;
        setState(() {
          if(text == ','){
            value = value * 100;
          } else{
            value = value * 10 + int.parse(text);
          }
        });
      },
      child: Container(
        height: height,
        child: Center(
          child: Text(text, 
          style: TextStyle(
            fontSize: 40.0, 
            color: Theme.of(context).accentColor.withOpacity(0.5)),
          )
        )
      ),
    );
  }

  Widget _numPad() {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          var height = constraints.biggest.height / 4;
         
          return Table(
          border: TableBorder.all(
            color: Theme.of(context).accentColor.withOpacity(0.5),
            width: 1.0
          ),
            children: [
              TableRow(
                children: [
                  _num('1', height,),
                  _num('2', height,),
                  _num('3', height,),
                ]
              ),
              TableRow(
                children: [
                  _num('4', height),
                  _num('5', height),
                  _num('6', height),
                ]
              ),
              TableRow(
                children: [
                  _num('7', height),
                  _num('8', height),
                  _num('9', height),
                ]
              ),
              TableRow(
                children: [
                  _num(',', height),
                  _num('0', height),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      setState(() {
                        value = value ~/ 10 + (value - value.toInt());
                      });
                    },
                    child: Container(
                      height: height,
                      child: Center(
                        child: Icon(
                          Icons.backspace,
                          color: Theme.of(context).accentColor.withOpacity(0.5),
                          size: 40.0,
                        )
                      )
                    ),
                  ),
                 ]
              ),
            ]         
          );
        },
      )
    );
  }

  Widget _submit() {
    return Builder(
      builder: (BuildContext context){
        return Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor
            ),
            child: MaterialButton(
              child: Text('Aceptar',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
                ),
              ),
              onPressed: (){
                var user = Provider.of<LoginState>(context).currentUser();
                if (value > 0 && service != null){
                  FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('services')
                  .doc()
                  .set({
                    'name'   : service,
                    'value'  : value / 100.0,
                    'month'  : DateTime.now().month, 
                    'day'    : DateTime.now().day
                  });
                  Navigator.of(context).pop();
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Seleccione un Servicio y su valor'),
                  ));
                }
              }
            )
        );
      }
    );
  }
}