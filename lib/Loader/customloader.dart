import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderExample extends StatefulWidget {
  const LoaderExample({Key? key}) : super(key: key);

  @override
  State<LoaderExample> createState() => _LoaderExampleState();
}

class _LoaderExampleState extends State<LoaderExample> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // backgroundColor: Colors.black38,
      body: Center(child: ElevatedButton(onPressed: (){
        showDialog(context: context, builder: (ctx){
          return  Center(
child: SpinKitFadingCircle(
  color: Colors.pink,
  size: 50.0,
));
            

        });
      }, child: Text('press'))
    ));
  }
}
