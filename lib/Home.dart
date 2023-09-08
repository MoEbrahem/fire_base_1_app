
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  String? name,describtion;
  double? price;

  getName(name){
    this.name =name ;
  }
  getDescribtion(describtion){
    this.describtion =describtion ;
  }
  getPrice(price){
    this.price =double.parse(price) ;
  }

  createData(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Dishes").doc(name);
    Map<String,dynamic> dish ={
      "name": name ,
      "describtion" : describtion ,
      "price" : price
    };
    documentReference.set(dish).whenComplete(() {
      print("$name created");
    });
  }
  updateData(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Dishes").doc(name);
    Map<String,dynamic> dish ={
      "name": name ,
      "describtion" : describtion ,
      "price" : price
    };
    documentReference.update(dish).whenComplete(() {
      print("$name Updated");
    });  }
  deleteData(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Dishes").doc(name);
    documentReference.delete().whenComplete(() {
      print("$name deleted");
    });
  }
  readData(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("Dishes").doc(name);
    documentReference.get().then((datasnapshot) {
      print(datasnapshot["name"]);
      print(datasnapshot["describtion"]);
      print(datasnapshot["price"]);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Scaffold(
        appBar: AppBar(

          title: Text(
            'Firebase CRUD',
            style: TextStyle(
                color: Colors.blueAccent
            ),
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                TextFormField(
                  onChanged: (String name){
                    getName(name);
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "Enter your Name" ,
                      labelText: "Name "
                  ),
                  validator: (String? value){
                    return (value != null && value.contains("@")) ? 'Donot use the @ char': null ;
                  },
                ),
                TextFormField(
                  onChanged: (String name){
                    getDescribtion(name);
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      hintText: "Describtion" ,
                      labelText: "Describtion"
                  ),

                ),
                TextFormField(
                  onChanged: (String name){
                    getPrice(name);
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                      icon: Icon(Icons.money),
                      hintText: "Price" ,
                      labelText: "Price"
                  ),
                  validator: (value){
                    return (value != null ) ? 'Enter Your Price': null ;
                  },
                ),
              ],
            ),
            SizedBox(height: 15,),
            Padding(
              padding:EdgeInsets.all(5.0),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: ElevatedButton(onPressed: ()
                    {
                      createData();
                    },
                      style:ElevatedButton.styleFrom(primary: Colors.green),
                      child: Text('Create'),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: ElevatedButton(onPressed: ()
                    {
                      readData();
                    },
                      style:ElevatedButton.styleFrom(primary: Colors.lightBlue),
                      child: Text('Read'),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: ElevatedButton(onPressed: ()
                    {
                      updateData();
                    },
                      style:ElevatedButton.styleFrom(primary: Colors.orange),
                      child: Text('Update'),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: ElevatedButton(onPressed: ()
                    {
                      deleteData();
                    },
                      style:ElevatedButton.styleFrom(primary: Colors.red,),
                      child: Text('Delete'),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 15,),
                Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                      child: Text("ID",style: TextStyle(fontWeight: FontWeight.bold),)),
                    Expanded(
                      child: Text("Name",style: TextStyle(fontWeight: FontWeight.bold),),),
                    Expanded(
                      child: Text("Describtion",style: TextStyle(fontWeight: FontWeight.bold),)),
                    Expanded(

                      child: Text("Price",style: TextStyle(fontWeight: FontWeight.bold),)),
                ],
                ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Dishes").snapshots(),
              builder:(BuildContext context, snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder:(context, index){
                      int id = index +1 ;
                      DocumentSnapshot ds =snapshot.data!.docs[index];
                      return Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Expanded(
                              child: Text("$id")),
                          Expanded(
                              child: Text(ds["name"])),
                          Expanded(
                              child: Text(ds["describtion"])),
                          Expanded(
                              child: Text(ds["price"].toString())),
                        ],
                      );
                    },
                  );
                   }else {
                    return Align(
                      alignment: FractionalOffset.bottomCenter,
                        child: CircularProgressIndicator(),
                    );
                  }
              },
            ),

          ],
        ),
      ),
    );
  }
}
