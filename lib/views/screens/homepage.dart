import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:animated_button/animated_button.dart';

class DClock extends StatefulWidget {
  const DClock({Key? key}) : super(key: key);

  @override
  State<DClock> createState() => _DClockState();
}

class _DClockState extends State<DClock> {
  String hour = "";
  TextEditingController thoughtcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff5B8FB9),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final List<String>? thoughts = prefs.getStringList('thoughts') ??
                  [
                    '  ',
                    '  ',
                    '  ',
                  ];

              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Color(0xff03001C),
                        title: Row(
                          children: [
                            Text(
                              "Saved Thoughts",
                              style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await prefs.remove('items');
                              },
                              icon: Icon(Icons.delete,color: Colors.white,),
                            )
                          ],
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Date   : ${thoughts![0]}",style: TextStyle(color: Colors.white),),
                            Text("Time   : ${thoughts[1]}",style: TextStyle(color: Colors.white),),
                            Text("Thought: ${thoughts[2]}",style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ));
            },
            icon: Icon(
              Icons.check_box,
              size: 30,
            ),
          ),
          SizedBox(width: 13),
        ],
        centerTitle: true,
        title: Text(
          "Digital Clock",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Neumorphic(
                child: Container(
                  height: size.height * 0.15,
                  width: size.width * 1,
                  decoration: BoxDecoration(
                    color: Color(0xff03001C),
                  ),
                  child: DigitalClock(
                    colon: Text(
                      ":",
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    ),
                    is24HourTimeFormat: false,
                    areaDecoration:
                        const BoxDecoration(color: Colors.transparent),
                    hourMinuteDigitTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                    ),
                    amPmDigitTextStyle:
                        Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xff5B8FB9)),
                    digitAnimationStyle: Curves.ease,
                    areaHeight: 100,
                    hourDigitDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    secondDigitTextStyle: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white, fontSize: 30),
                    secondDigitDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedButton(
              color: Color(0xff03001C),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Center(
                      child: Text(
                        "Add Your Thoughts",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ),
                    content: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text("Date: ${DateTime.now().day.toString()}-"),
                              Text("${DateTime.now().month.toString()}-"),
                              Text("${DateTime.now().year.toString()}"),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                  "Time: ${(DateTime.now().hour == 00) ? hour = "12" : (DateTime.now().hour == 12) ? hour = "12" : (DateTime.now().hour == 13) ? hour = "01" : (DateTime.now().hour == 14) ? hour = "02" : (DateTime.now().hour == 15) ? hour = "03" : (DateTime.now().hour == 16) ? hour = "04" : (DateTime.now().hour == 17) ? hour = "05" : (DateTime.now().hour == 18) ? hour = "06" : (DateTime.now().hour == 19) ? hour = "07" : (DateTime.now().hour == 20) ? hour = "08" : (DateTime.now().hour == 21) ? hour = "09" : (DateTime.now().hour == 22) ? hour = "10" : (DateTime.now().hour == 23) ? hour = "11" : hour = "12"}"),
                              Text(" : ${DateTime.now().minute.toString()}"),
                              Text(" : ${DateTime.now().second.toString()}"),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 100,
                            width: 300,
                            child: TextField(
                              controller: thoughtcontroller,
                              decoration: InputDecoration(
                                hintText: 'Enter Thought',
                                label: const Text("   Thought"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: size.height * 0.05,
                            width: size.width * 0.25,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Color(0xff03001C)),
                              ),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                await prefs.setStringList(
                                  'thoughts',
                                  [
                                    '${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}',
                                    '$hour : ${DateTime.now().minute.toString()} : ${DateTime.now().second.toString()}',
                                    '${thoughtcontroller.text}',
                                  ],
                                );
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                "Mark My Thoughts",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
