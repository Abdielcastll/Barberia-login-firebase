
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nuevoproyecto/src/login_state.dart';
import 'package:nuevoproyecto/src/utils/utils.dart';
import 'package:nuevoproyecto/src/widgets/month_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller;
  int currentPage = DateTime.now().month - 1;
  Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINE;
  
 
  @override
  void initState() { 
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4
    );
  }

  Widget _bottonAction(IconData icon, Function callback){
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
        child: Icon(icon,size: 30.0,),
      ),
      onTap: callback,
    );
  }
  @override
  Widget build(BuildContext context) {
    
    return Consumer<LoginState>(
      builder: (context, value, child){
          var user = Provider.of<LoginState>(context).currentUser();
            _query = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('services')
            .where('month', isEqualTo: currentPage + 1)
            .snapshots();

        return Scaffold(
        bottomNavigationBar: BottomAppBar(

          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            _bottonAction(FontAwesomeIcons.chartLine, (){
              setState(() {
                currentType = GraphType.LINE;
              });
            }),
            _bottonAction(FontAwesomeIcons.chartPie, (){
              setState(() {
                currentType = GraphType.PIE;
              });
            }),
            SizedBox(width: 40.0,),
            _bottonAction(FontAwesomeIcons.wallet, (){
              Navigator.of(context).pushNamed('/allUser');
            }),
            _bottonAction(FontAwesomeIcons.signOutAlt, (){
              Provider.of<LoginState>(context).logout();
            })
          ],)
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed('/add');
            } 
        ),
        body: _body(),
      );},
    );
  }

  Widget _body() {

    return SafeArea(
      child: Expanded(
          child: Column(
            children: [
              _selector(),
              StreamBuilder<QuerySnapshot>(
                stream: _query,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                  if (snapshot.hasData) {
                   var user = Provider.of<LoginState>(context).currentUser();

                  return Month(
                    days: daysInMonth(currentPage + 1),
                    documents: snapshot.data.docs,
                    graphType: currentType,
                    month: currentPage + 1,
                    userName: user.displayName,
                    userPhoto: user.photoURL,
                  );
                  }
                    return Center(child: CircularProgressIndicator());
                }
              ),
            ],
          ),
      ),
      
    );
  }

  Widget _pageItem(String name, int position){
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey
    );
    final unSelected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4)
    );

    if(position == currentPage){
      _alignment = Alignment.center;
    } else if (position > currentPage){
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }
   
    return Align(
      alignment: _alignment,
      child: Text(name,
        style: position == currentPage ? selected : unSelected,
      )
    );
  }
  
  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            var user = Provider.of<LoginState>(context).currentUser();
            currentPage = newPage;
            _query = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('services')
            .where('month', isEqualTo: currentPage + 1)
            .snapshots();
          });
        },
        controller: _controller,
        children: [
          _pageItem('Enero', 0),
          _pageItem('Febrero', 1),
          _pageItem('Marzo', 2),
          _pageItem('Abril', 3),
          _pageItem('Mayo', 4),
          _pageItem('Junio', 5),
          _pageItem('Julio', 6),
          _pageItem('Agosto', 7),
          _pageItem('Septiembre', 8),
          _pageItem('Octubre', 9),
          _pageItem('Noviembre', 10),
          _pageItem('Diciembre', 11),
        ],
      ),
    );
  }
}