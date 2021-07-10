import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robo_joystick/services/generalServices.dart';

class RectButtonCtrl extends StatefulWidget {
  double val;
  Widget child;
  Function function=null;
  RectButtonCtrl({this.child,this.function,this.val=75});

  @override
  _RectButtonCtrlState createState() => _RectButtonCtrlState();
}

class _RectButtonCtrlState extends State<RectButtonCtrl> {
  bool isNotPressed=true;

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onPanStart: (t){
          setState(() {
            isNotPressed=false;
            widget.function!=null?widget.function():null;
          });
        },
        onPanEnd: (t){
          setState(() {
            isNotPressed=true;
          });
        },
        child: Container(
          height: widget.val/GoldenRatio,
          width: widget.val,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            //border: Border.all(width: 2),
            color: Color(0xff000000),
            gradient: LinearGradient(
              stops: [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:isNotPressed?
              [Color(0xffc5c5c5), Color(0xff000000)]:
              [Color(0xff000000), Color(0xffc5c5c5)],
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: isNotPressed?10:5,
                color: Color(0xff969696),
                offset: isNotPressed?Offset(5,5):Offset(-5,-5),
              ),
              BoxShadow(
                blurRadius: isNotPressed?25:15,
                color: Color(0xffffffff),
                offset: isNotPressed?Offset(-5,-5):Offset(5,5),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class CircularButtonCtrl extends StatefulWidget {
  double val;
  Widget child;
  Function function=null;
  CircularButtonCtrl({this.child,this.function,this.val=100});

  @override
  _CircularButtonCtrlState createState() => _CircularButtonCtrlState();
}

class _CircularButtonCtrlState extends State<CircularButtonCtrl> {


  bool isNotPressed=true;

  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    return GestureDetector(
      onPanStart: (t){
        setState(() {
          isNotPressed=false;
          widget.function!=null?widget.function():null;
        });
      },
      onPanEnd: (t){
        setState(() {
          isNotPressed=true;
        });
      },
      child: Container(
        height: widget.val/GoldenRatio,
        width: widget.val,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          //borderRadius: BorderRadius.circular(15),
          //border: Border.all(width: 2),
          color: Color(0xff000000),
          gradient: LinearGradient(
            stops: [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:isNotPressed?
            [Color(0xffc5c5c5), Color(0xff000000)]:
            [Color(0xff000000), Color(0xffc5c5c5)],
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isNotPressed?7:3,
              color: Color(0xff969696),
              offset: isNotPressed?Offset(5,5):Offset(-5,-5),
            ),
            BoxShadow(
              blurRadius: isNotPressed?25:15,
              color: Color(0xffffffff),
              offset: isNotPressed?Offset(-5,-5):Offset(5,5),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

class SliderCtrl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>sldr(val: 1,),
      child: Consumer<sldr>(
        builder: (context,sldrobj,child){
          return Padding(
            padding: const EdgeInsets.only(left:40.0,right: 40.0,top: 20.0,bottom: 4.0),
            child: Container(
              decoration: BoxDecoration(
                //border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(25),
                color: Color(0xffd6d6d6),
                gradient: LinearGradient(
                  stops: [0, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                  [Color(0xffa1a1a1),Color(0xffe5e5e5)],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
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
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 10.0,
                  activeTrackColor: Colors.white10.withOpacity(0),
                  inactiveTrackColor: Colors.white10.withOpacity(0),
                  activeTickMarkColor: Colors.black,
                  inactiveTickMarkColor: Colors.black,
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.black,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                    min: 1,max:5,
                    divisions: 4,
                    label: sldrobj.val.toString(),
                    value: sldrobj.val,
                    onChanged: sldrobj.onChanged,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class JoystickCtrl extends StatelessWidget {

  bool bigger;

  JoystickCtrl({this.bigger});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<joyCoords>(
      create: (context)=>
          bigger?
          joyCoords(
              containerVal: Coords(r: screenMin-100-2),
              bgCenter: Coords(x: 37.5,y: 37.5,r: screenMin-175),
              knobCenter: Coords(x: 125,y: 125,r: screenMin-350),
              canDrag: false,bigger: bigger
          )
          :joyCoords(
              containerVal: Coords(r: (screenMin-100-2)/2),
              bgCenter: Coords(x: 37.5/2,y: 37.5/2,r: (screenMin-175)/2),
              knobCenter: Coords(x: 125/2,y: 125/2,r: (screenMin-350)/2),
              canDrag: false,bigger: bigger
      ),
      child: Consumer<joyCoords>(
        builder: (context,jc,child){
          return Container(
            height: jc.containerVal.r,
            width: jc.containerVal.r,
            //color: Colors.red,
            child: Stack(
              children: [
                Positioned(
                  left: jc.bgCenter.x,
                  top: jc.bgCenter.y,
                  child: Container(
                    height: jc.bgCenter.r,
                    width: jc.bgCenter.r,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //color: Colors.blueGrey[700],
                        //border: Border.all(width: 2),
                      gradient: LinearGradient(
                        stops: [0, 1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors:
                        [Color(0xffa1a1a1),Color(0xffe5e5e5)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
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
                  ),
                ),
                Positioned(
                  left: jc.knobCenter.x+jc.knobCenter.shiftX,
                  top: jc.knobCenter.y+jc.knobCenter.shiftY,
                  child: GestureDetector(
                    onPanStart: jc.onPanStart,
                    onPanUpdate: jc.onPanUpdate,
                    onPanEnd: jc.onPanEnd,
                    child: Container(
                      height: jc.knobCenter.r,
                      width: jc.knobCenter.r,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey[500],
                          //border: Border.all(width: 2)
                        gradient: LinearGradient(
                          stops: [0, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:
                          [Color(0xffc5c5c5), Color(0xff000000)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            color: Color(0xff969696),
                            offset: Offset(
                                5,5
                            ),
                          ),
                          BoxShadow(
                            blurRadius: 55,
                            color: Color(0xffffffff),
                            offset: Offset(
                                -5,-5
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ArrowButtonCtrl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //shape: BoxShape.circle,
        //color: Colors.blueGrey[700],
        //border: Border.all(width: 2),
        gradient: LinearGradient(
          stops: [0, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
          [Color(0xffa1a1a1),Color(0xffe5e5e5)],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1,
                child: CircularButtonCtrl(
                  child: Icon(Icons.keyboard_arrow_up,size: 36,color: Colors.white,),
                  function: (){
                    SendingData(stpt.ids[8],"1");
                  },
                )),
            Expanded(
              flex: 1,
              child: Row(children: [
                Expanded(flex: 1,
                    child: CircularButtonCtrl(
                      child: Icon(Icons.keyboard_arrow_left,size: 36,color: Colors.white,),
                      function: (){
                        SendingData(stpt.ids[8],"2");
                      },
                    )),
                Expanded(flex: 1,
                    child: CircularButtonCtrl(
                      child: Icon(Icons.keyboard_arrow_right,size: 36,color: Colors.white,),
                      function: (){
                        SendingData(stpt.ids[8],"3");
                      },
                    )),
              ],),
            ),
            Expanded(flex: 1,
                child: CircularButtonCtrl(
                  child: Icon(Icons.keyboard_arrow_down,size: 36,color: Colors.white,),
                  function: (){
                    SendingData(stpt.ids[8],"4");
                  },
                )),
          ],
        ),
      ),
    );
  }
}
