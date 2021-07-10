import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:open_settings/open_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// phone orientation modes
onlyLandscapeMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
onlyPortraitMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
allOrientationModes(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

// something
const double GoldenRatio=1.618;
double screenHeight=null,screenWidth=null,screenMin=null,screenMax=null;
setScreenSize(context){
  screenHeight=(screenHeight!=null)?screenHeight:MediaQuery.of(context).size.height;
  screenWidth=(screenWidth!=null)?screenWidth:MediaQuery.of(context).size.width;
  screenMin=(screenMin!=null)?screenMin:min<double>(screenWidth, screenHeight);
  screenMax=(screenMax!=null)?screenMax:max<double>(screenWidth, screenHeight);
}

getVisitingFlag()async{
  SharedPreferences preferences=await SharedPreferences.getInstance();
  List cred=(await preferences.getStringList("wifi"))??["","",""];
  cnctr.socketAddress=cred[2];
  cnctr.WFssid=cred[0];
  cnctr.WFpassword=cred[1];
}
setVisitingFlag(ssid,pass,addr)async{
  SharedPreferences preferences=await SharedPreferences.getInstance();
  await preferences.setStringList("wifi",[ssid,pass,addr]);
}

FlutterBluetoothSerial bluetooth=FlutterBluetoothSerial.instance;
Connectivity connectivity=Connectivity();
class Cnctr extends ChangeNotifier{
  List<BluetoothDevice> pairedDevices=[];
  String socketAddress="",WFssid="",WFpassword="";
  bool isBTConnected=false;
  bool isWFConnected=false,addressBool=false;
  BluetoothConnection connected_device=null;
  //Socket socket;
  BluetoothDevice selected_device;

  Cnctr(){
    getVisitingFlag();
  }

  getPairedDevices()async{
    List tempDev;
    if(!(await bluetooth.isEnabled)){
      await bluetooth.requestEnable();return;
    }
    tempDev=await bluetooth.getBondedDevices();
    //await Future.delayed(Duration(milliseconds: 1000));
    pairedDevices=(tempDev!=null)?tempDev:pairedDevices;
  }

  checkBTConnectionActive(){
    if(connected_device==null){isBTConnected=false;return;}
    isBTConnected=connected_device.isConnected;
  }
  checkWFConnectionActive()async{
    var connectivityResult=await connectivity.checkConnectivity();
    isWFConnected=(connectivityResult==ConnectivityResult.wifi);
    print(isWFConnected);
  }

  getConnectedTo(index)async{
    selected_device=pairedDevices[index];
    connected_device=await BluetoothConnection.toAddress(selected_device.address);
    isBTConnected=connected_device.isConnected;
  }
  getWFConnectedTo()async{
    await OpenSettings.openWIFISetting();
    checkWFConnectionActive();
  }

  getDisconnected()async{
    await connected_device.dispose();
    connected_device=null;
    isBTConnected=false;
  }
  getWFDisconected()async{
    await OpenSettings.openWIFISetting();
    checkWFConnectionActive();
  }

  Future sendBT(String data) async {
    connected_device.output.add(ascii.encode(data));
    await connected_device.output.allSent;
  }

  // SocketSetup()async{
  //   socket=await Socket.connect(socketAddress,80);
  // }
  // SocketDispose()async{
  //   await socket.close();
  //   socket=null;
  // }

  sendWF(String data)async{
    // port 80=http request,21 for ftp,23 for telnet
    // for(int i=0;i<data.length;i++){
    //   socket.write(data[i]);
    // }
    await http.get(Uri.http(socketAddress, "/look",{"data":data}));
    //await http.post(Uri.http(socketAddress, "/look"),body: {"data":data});
  }

  Future receiveBT()async{
    try{
      await connected_device.input.listen((Uint8List data) {
        var temp=ascii.decode(data);
        print(temp);
        if(temp.contains("!")){
          return true;
        }
      });
    }catch(e){
      print(e);
    }
  }
  receiveWF()async{
    try{
      //var data=socket. read or listen
    }catch(e){
      print(e);
    }
  }
}

Cnctr cnctr=Cnctr();

class Coords{
  double x,y,r;
  double shiftX=0,shiftY=0;
  Coords({this.x,this.y,this.r});
  setShifts(sX,sY){
    shiftX=sX;
    shiftY=sY;
  }
}

class sldr extends ChangeNotifier{
  double val;
  sldr({this.val});
  onChanged(value){
    if(val==value)return;
    cnctr.checkBTConnectionActive();
    String id=stpt.ids[11];
    if(cnctr.isBTConnected) {
      val=value;
      String data = "$id "+val.toStringAsFixed(0)+"\n";
      print(data);
      cnctr.sendBT(data);
    }
    cnctr.checkWFConnectionActive();
    if(cnctr.isWFConnected && cnctr.addressBool){
      val=value;
      String data = "$id "+val.toStringAsFixed(0)+"\n";
      print(data);
      cnctr.sendWF(data);
    }
    notifyListeners();
  }
}

class joyCoords extends ChangeNotifier{
  Coords containerVal;
  Coords bgCenter;
  Coords knobCenter;
  bool canDrag;bool bigger;
  joyCoords({this.containerVal,this.bgCenter,this.knobCenter,this.bigger,this.canDrag});

  checkCanDrag(){
    cnctr.checkBTConnectionActive();
    cnctr.checkWFConnectionActive();
    canDrag=cnctr.isBTConnected || (cnctr.isWFConnected && cnctr.addressBool);
    notifyListeners();
  }
  Timer timer;
  cancelTimer() {
    if (timer != null && timer.isActive) {
      timer?.cancel();
      timer = null;
    }
  }
  onPanStart(dragDetails)async{
    checkCanDrag();
    if(!canDrag) return onPanEnd(dragDetails);
    timer=Timer.periodic(Duration(milliseconds: 100), (_) {
      var x=knobCenter.shiftX;
      var y=knobCenter.shiftY;
      var d=pow(pow(x, 2)+pow(y, 2), 0.5);
      x=(x/d)*255;y=(-y/d)*255;
      /*
      * - - | + -     - + | + +
      * ----+----- => ----+-----
      * - + | + +     - - | + -
      */
      SendingData(bigger?stpt.ids[9]:stpt.ids[10],x.toStringAsFixed(0)+" "+y.toStringAsFixed(0));
    });
  }
  onPanUpdate(dragDetails)async{
    checkCanDrag();
    if(!canDrag) return onPanEnd(dragDetails);
    var x=dragDetails.localPosition.dx-bgCenter.x;
    var y=dragDetails.localPosition.dy-bgCenter.y;
    var d=pow(pow(x, 2)+pow(y, 2), 0.5);
    double _radAngle = atan2(y,x);

    d=d<(bgCenter.r/2)?d:(bgCenter.r/2);
    x=d*cos(_radAngle);
    y=d*sin(_radAngle);

    knobCenter.setShifts(x, y);
    notifyListeners();
  }
  onPanEnd(dragDetails){
    knobCenter.setShifts(0.0, 0.0);
    cancelTimer();
    notifyListeners();
  }
}

exitApp(context){
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(
            "Do you wish to exit?",
            style: TextStyle(
                fontSize: 18,
                fontFamily: "josefinSans",
                color: Colors.black
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    setVisitingFlag(cnctr.WFssid, cnctr.WFpassword, cnctr.socketAddress);
                    // if(cnctr.socket!=null){
                    //   cnctr.SocketDispose();
                    // }
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      child: Text(
                        "Yes,Exit",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "josefinSans",
                            color: Colors.green
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      child: Text(
                        "No",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "josefinSans",
                            color: Colors.redAccent
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      }
  );
}

SendingData(id,val){
  cnctr.checkBTConnectionActive();bool flag1=false;
  cnctr.checkWFConnectionActive();bool flag2=false;
  String data = "$id $val\n";
  print(data);
  if(cnctr.isBTConnected) {
    cnctr.sendBT(data);
    flag1=true;
  }
  if(cnctr.isWFConnected && cnctr.addressBool){
    cnctr.sendWF(data);
    flag2=true;
  }
  return flag1 || flag2;
}

class WifiPageInputs{
  String tempSSID="",tempPassword="",tempAddress="";

  setValues1(){
    tempPassword=cnctr.WFpassword;
    tempSSID=cnctr.WFssid;
  }
  setValues2(){
    tempAddress=cnctr.socketAddress;
  }
  WifiPageInputs(){
    tempPassword=cnctr.WFpassword;
    tempSSID=cnctr.WFssid;
    tempAddress=cnctr.socketAddress;
  }
  submitted1(){
    cnctr.WFssid=tempSSID;
    cnctr.WFpassword=tempPassword;
    setVisitingFlag(cnctr.WFssid, cnctr.WFpassword, cnctr.socketAddress);
  }

  submitted2(){
    cnctr.socketAddress=tempAddress;
    setVisitingFlag(cnctr.WFssid, cnctr.WFpassword, cnctr.socketAddress);
  }
}
WifiPageInputs wfpi=WifiPageInputs();

class SettingsInputs{
  int count=13;
  List<String> icons=[];
  List<String> ids=[];
  SettingsInputs(){
    initialValues();
  }

  initialValues(){
    if(icons.isEmpty){
      icons=["0","1","2","3","4","5","6","7","Arrow","BigJ","Lilj","Slider","Fire"];
    }
    if(ids.isEmpty){
      ids=["B","C","D","E","G","H","I","K","a","J","j","A","F"];
      // recommended to keep single char possibly alphabet
    }
  }

  saveValues()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    await preferences.setStringList("stpticons",icons);
    await preferences.setStringList("stptids",ids);
  }
  getValues()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    List cred1=(await preferences.getStringList("stpticons"))??[];
    List cred2=(await preferences.getStringList("stptids"))??[];
    icons=(cred1!=[])?cred1:icons;
    //icons=["0","1","2","3","4","5","6","7","Arrow","BigJ","Lilj","Slider","Fire"];
    ids=(cred2!=[])?cred2:ids;
    //ids=["B","C","D","E","G","H","I","K","a","J","j","A","F"];
  }
}
SettingsInputs stpt=SettingsInputs();






