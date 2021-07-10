import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_settings/open_settings.dart';

import 'package:provider/provider.dart';
import 'package:robo_joystick/services/ControllerServices.dart';
import 'package:robo_joystick/services/generalServices.dart';

class ControllerScreen extends StatefulWidget {
  @override
  _ControllerScreenState createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {

  @override
  void initState(){
    onlyLandscapeMode();
    stpt.getValues();
    super.initState();
  }

  @override
  dispose(){
    allOrientationModes();
    cnctr.getDisconnected();
    // if(cnctr.socket!=null){
    //   cnctr.SocketDispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    return SafeArea(
        child: WillPopScope(
          onWillPop: ()async{
            cnctr.checkBTConnectionActive();
            if(cnctr.isBTConnected || (cnctr.isWFConnected && cnctr.addressBool)){return false;}
            exitApp(context);
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.blueGrey[50],
            body:Container(
              child: Column(
                children: [
                  Expanded(
                    flex:75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            RectButtonCtrl(
                              child: Center(
                                child: Text(
                                  stpt.icons[0],
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: "josefinSans",
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              function: (){
                                SendingData(stpt.ids[0], "1");// F fire
                              },
                            ),
                            RectButtonCtrl(
                              child: Center(
                                child: Text(
                                  stpt.icons[1],
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: "josefinSans",
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              function: (){
                                SendingData(stpt.ids[1], "1");// F fire
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            RectButtonCtrl(
                              child: Center(
                                child: Text(
                                  stpt.icons[2],
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: "josefinSans",
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              function: (){
                                SendingData(stpt.ids[2], "1");// F fire
                              },
                            ),
                            RectButtonCtrl(
                              child: Center(
                                child: Text(
                                  stpt.icons[3],
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: "josefinSans",
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              function: (){
                                SendingData(stpt.ids[3], "1");// F fire
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: (screenMin-100-25).toInt(),
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: JoystickCtrl(bigger:true)),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                flex:1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(flex:1,
                                        child: RectButtonCtrl(
                                          child: Center(
                                            child: Text(
                                              stpt.icons[4],
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: "josefinSans",
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                          function: (){
                                            SendingData(stpt.ids[4], "1");// F fire
                                          },
                                        ),),
                                    Expanded(flex:1,
                                        child: RectButtonCtrl(
                                          child: Center(
                                            child: Text(
                                              stpt.icons[5],
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: "josefinSans",
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                          function: (){
                                            SendingData(stpt.ids[5], "1");// F fire
                                          },
                                        ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            flex:1,
                                            child: CircularButtonCtrl(val:65,
                                              child: Icon(Icons.settings,size: 24,color: Colors.white,),
                                              function: ()async{
                                                await setScreenSize(context);
                                                await Future.delayed(Duration(milliseconds: 10));
                                                await Navigator.of(context).pushNamed('/settingspage');
                                                setState(() {
                                                  stpt.getValues();
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex:1,
                                            child: CircularButtonCtrl(val:65,
                                              child: Icon(CupertinoIcons.bluetooth,size: 24,color: Colors.white,),
                                              function: (){
                                                Navigator.of(context).pushNamed('/btpage');
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex:1,
                                            child: CircularButtonCtrl(val:65,
                                              child: Icon(Icons.wifi,size: 24,color: Colors.white,),
                                              function: (){
                                                Navigator.of(context).pushNamed('/wifipage');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(flex: 2,
                                        child: ArrowButtonCtrl()),
                                    Expanded(flex: 1,
                                        child: Column(
                                          children: [
                                            Expanded(flex: 1,
                                                child:RectButtonCtrl(
                                                  child: Center(
                                                    child: Text(
                                                      stpt.icons[6],
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontFamily: "josefinSans",
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                  function: (){
                                                    SendingData(stpt.ids[6], "1");// F fire
                                                  },
                                                ),),
                                            Expanded(flex: 1,
                                                child:RectButtonCtrl(
                                                  child: Center(
                                                    child: Text(
                                                      stpt.icons[7],
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontFamily: "josefinSans",
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                  function: (){
                                                    SendingData(stpt.ids[7], "1");// F fire
                                                  },                                                ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex:1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SliderCtrl(),
                                          RectButtonCtrl(
                                            child: Icon(FontAwesomeIcons.rocket,color: Colors.orange,),
                                            function: (){
                                              SendingData(stpt.ids[12], "1");// F fire
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: JoystickCtrl(
                                          bigger:false
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
        );
  }
}

class BTPage extends StatefulWidget {
  @override
  _BTPageState createState() => _BTPageState();
}

class _BTPageState extends State<BTPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "A v a i l a b l e  D e v i c e s",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "josefinSans",
                color: Colors.white
            ),
          ),
          actions: [
            Tooltip(
              message: "add new devices",
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: GestureDetector(
                    onTap: ()async{
                      //await bluetooth.openSettings();
                      await OpenSettings.openBluetoothSetting();
                    },
                    child: Icon(CupertinoIcons.add,),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20,),
            Tooltip(
              message: "refresh",
              child: Padding(
                padding: const EdgeInsets.only(right:20.0),
                child: Container(
                  child: GestureDetector(
                    onTap: ()async{
                      setState(() {
                        cnctr.getPairedDevices();
                      });
                    },
                    child: Icon(CupertinoIcons.refresh,),
                  ),
                ),
              ),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white,size: 26),
        ),
        backgroundColor: Colors.blueGrey[50],
        body: cnctr.pairedDevices.length==0?
        Center(
          child: Text(
            " R e f r e s h  a g a i n . . . ",
            style: TextStyle(
                fontSize: 24,
                fontFamily: "josefinSans",
                color: Colors.black
            ),
          ),
        ):
        Center(
          child: Container(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cnctr.pairedDevices.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          cnctr.pairedDevices[index].isConnected?
                          cnctr.getDisconnected():cnctr.getConnectedTo(index);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width:150,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(25),
                            color: cnctr.pairedDevices[index].isConnected?
                            Colors.greenAccent:Colors.blue[50],
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Color(0xff969696),
                                offset: Offset(
                                    -5,-5
                                ),
                              ),
                              BoxShadow(
                                blurRadius: 15,
                                color: Color(0xffffffff),
                                offset: Offset(
                                    5,5
                                ),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.bluetooth,
                                      size: 32,color: Colors.blue[800],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    cnctr.pairedDevices[index].name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "josefinSans",
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}


class WiFiPage extends StatefulWidget {
  @override
  _WiFiPageState createState() => _WiFiPageState();
}

class _WiFiPageState extends State<WiFiPage> {

  bool b1=cnctr.isWFConnected,b2=cnctr.addressBool;
  bool obsT1=true,obsT2=true;
  bool isEditable1=false,isEditable2=false;
  TextEditingController tec1=TextEditingController(),
      tec2=TextEditingController(),
      tec3=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "W i - F i",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "josefinSans",
                  color: Colors.white
              ),
            ),
            actions: [
              Tooltip(
                message: "refresh",
                child: Padding(
                  padding: const EdgeInsets.only(right:20.0),
                  child: Container(
                    child: GestureDetector(
                      onTap: ()async{
                        setState(() {
                          getVisitingFlag();
                          wfpi.setValues1();
                          wfpi.setValues2();
                          cnctr.checkWFConnectionActive();
                          b1=cnctr.isWFConnected;b2=b1&cnctr.addressBool;
                        });
                      },
                      child: Icon(CupertinoIcons.refresh,),
                    ),
                  ),
                ),
              ),
            ],
            iconTheme: IconThemeData(color: Colors.white,size: 26),
          ),
          backgroundColor: Colors.blueGrey[50],
          body: SingleChildScrollView(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(width:2),
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Color(0xff969696),
                                  offset: Offset(
                                      -5,-5
                                  ),
                                ),
                                BoxShadow(
                                  blurRadius: 15,
                                  color: Color(0xffffffff),
                                  offset: Offset(
                                      5,5
                                  ),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                cursorHeight: 25,
                                readOnly: obsT1,
                                controller: tec1,
                                onTap: (){
                                  tec1.text=wfpi.tempSSID;
                                },
                                decoration: InputDecoration(
                                  hintText: "ssid: "+wfpi.tempSSID,
                                  hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "josefinSans",
                                      color: Colors.black
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "josefinSans",
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                              height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(width:2),
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Color(0xff969696),
                                  offset: Offset(
                                      -5,-5
                                  ),
                                ),
                                BoxShadow(
                                  blurRadius: 15,
                                  color: Color(0xffffffff),
                                  offset: Offset(
                                      5,5
                                  ),
                                ),
                              ],
                            ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextField(
                                  cursorHeight: 25,
                                  readOnly: obsT1,
                                  controller: tec2,
                                  onTap: (){
                                    tec2.text=wfpi.tempPassword;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "password: "+wfpi.tempPassword,
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "josefinSans",
                                        color: Colors.black
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "josefinSans",
                                      color: Colors.black
                                  ),
                                ),
                              ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex:1,
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                onPressed: (){
                                  if(b1)return;
                                    setState(() {
                                      isEditable1=!isEditable1;
                                      obsT1=!obsT1;
                                    });
                                    if(!isEditable1){
                                      wfpi.tempSSID=tec1.text;
                                      wfpi.tempPassword=tec2.text;
                                      wfpi.submitted1();
                                    }
                                    },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                      //border: Border.all(width:2,color: Colors.white),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  child: Center(
                                      child: Text(
                                          isEditable1?"Save":"Edit",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: "josefinSans",
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex:1,
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                  onPressed: isEditable1?
                                      (){
                                    wfpi.setValues1();
                                    tec1.text=wfpi.tempSSID;
                                    tec2.text=wfpi.tempPassword;
                                  }:
                                      ()async{
                                    if(!b1) {
                                      await cnctr.getWFConnectedTo();
                                    }
                                    else{
                                      await cnctr.getWFDisconected();
                                    }
                                    },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: b1?Colors.greenAccent:Colors.black,
                                      //border: Border.all(width:2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                          isEditable1?"Cancel":"Connect",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: "josefinSans",
                                            color: b1?Colors.black:Colors.white
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border.all(width:2),
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Color(0xff969696),
                                    offset: Offset(
                                        -5,-5
                                    ),
                                  ),
                                  BoxShadow(
                                    blurRadius: 15,
                                    color: Color(0xffffffff),
                                    offset: Offset(
                                        5,5
                                    ),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextField(
                                  cursorHeight: 25,
                                  readOnly: obsT2,
                                  controller: tec3,
                                  onTap: (){
                                    tec3.text=wfpi.tempAddress;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "address:"+wfpi.tempAddress,
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "josefinSans",
                                        color: Colors.black
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "josefinSans",
                                      color: Colors.black
                                  ),
                                ),
                              ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex:1,
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                  onPressed: (){
                                    if(b2)return;
                                    setState(() {
                                      isEditable2=!isEditable2;
                                      obsT2=!obsT2;
                                    });
                                    if(!isEditable2) {
                                      wfpi.tempAddress = tec3.text;
                                      wfpi.submitted2();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      //border: Border.all(width:2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                        isEditable2?"Save":"Edit",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: "josefinSans",
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Expanded(
                              flex:1,
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                  onPressed: isEditable2?
                                      (){
                                        wfpi.setValues2();
                                        tec3.text=wfpi.tempAddress;
                                      }:
                                      (){
                                    setState(() {
                                      b2=!b2 && cnctr.isWFConnected;
                                      cnctr.addressBool=b2;
                                    });
                                    },
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: b2?Colors.greenAccent:Colors.black,
                                      //border: Border.all(width:2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Text(
                                          isEditable2?"Cancel":"Connect",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: "josefinSans",
                                            color: b2?Colors.black:Colors.white
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            " S e t t i n g s",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "josefinSans",
                color: Colors.white
            ),
          ),
          actions: [
            Tooltip(
              message: "refresh",
              child: Padding(
                padding: const EdgeInsets.only(right:20.0),
                child: Container(
                  child: GestureDetector(
                    onTap: ()async{
                      setState(() {
                        stpt.getValues();
                      });
                    },
                    child: Icon(CupertinoIcons.refresh,),
                  ),
                ),
              ),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white,size: 26),
        ),
        backgroundColor: Colors.blueGrey[50],
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height:screenMin/2,
                width: screenMax,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: 9+1+1+2,
                    //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,),
                    itemBuilder: (context,index){
                      return Container(
                        height:100,width: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: ()async{
                              await Navigator.pushNamed(context, '/editingpage',arguments:{"index":index});
                              setState(() {
                                stpt.getValues();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.blue[50],
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Color(0xff969696),
                                      offset: Offset(
                                          -5,-5
                                      ),
                                    ),
                                    BoxShadow(
                                      blurRadius: 15,
                                      color: Color(0xffffffff),
                                      offset: Offset(
                                          5,5
                                      ),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                    child: Text(
                                      stpt.icons[index]+"\n\n"+
                                      stpt.ids[index],
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: "josefinSans",
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditingPage extends StatefulWidget {
  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  int index;
  Map map;
  @override
  Widget build(BuildContext context) {
    TextEditingController tec1=TextEditingController();
    TextEditingController tec2=TextEditingController();
    map=(map!=null)?map:ModalRoute.of(context).settings.arguments;
    index=map['index'];
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: screenMin,
                child: Row(
                  children: [
                    Expanded(
                      flex:1,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border.all(width:2),
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Color(0xff969696),
                                    offset: Offset(
                                        -5,-5
                                    ),
                                  ),
                                  BoxShadow(
                                    blurRadius: 15,
                                    color: Color(0xffffffff),
                                    offset: Offset(
                                        5,5
                                    ),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextField(
                                  cursorHeight: 25,
                                  controller: tec1,
                                  onTap: (){
                                    tec1.text=stpt.icons[index];
                                  },
                                  decoration: InputDecoration(
                                    hintText: stpt.icons[index],
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "josefinSans",
                                        color: Colors.black
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "josefinSans",
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border.all(width:2),
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Color(0xff969696),
                                    offset: Offset(
                                        -5,-5
                                    ),
                                  ),
                                  BoxShadow(
                                    blurRadius: 15,
                                    color: Color(0xffffffff),
                                    offset: Offset(
                                        5,5
                                    ),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextField(
                                  cursorHeight: 25,
                                  controller: tec2,
                                  onTap: (){
                                    tec2.text=stpt.ids[index];
                                  },
                                  decoration: InputDecoration(
                                    hintText: stpt.ids[index],
                                    hintStyle: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "josefinSans",
                                        color: Colors.black
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "josefinSans",
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex:1,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  stpt.icons[index]=tec1.text!=""?tec1.text:stpt.icons[index];
                                  stpt.ids[index]=tec2.text!=""?tec2.text:stpt.ids[index];
                                  stpt.saveValues();
                                });
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  //border: Border.all(width:2),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: "josefinSans",
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  tec1.text=stpt.icons[index];
                                  tec2.text=stpt.ids[index];
                                });
                              },
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  //border: Border.all(width:2),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: "josefinSans",
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


