import 'package:flutter/material.dart';
import 'package:rolling_dice/Models/Users.dart';
import 'package:rolling_dice/Presentation/shared/button.dart';
import 'package:rolling_dice/Services/databaseService.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

final BorderRadius borderRight = BorderRadius.only(
  topRight: Radius.circular(20),
  bottomLeft: Radius.circular(20),
);
final BorderRadius borderLeft = BorderRadius.only(
  topLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);
final EdgeInsets edgeLeft =
    EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 5);
final EdgeInsets edgeRight =
    EdgeInsets.only(right: 30, top: 10, bottom: 10, left: 5);

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: [
          Color(0xFFB15252),
          Color.fromARGB(255, 255, 136, 34),
          Color(0xFFAFAB40)
        ])),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "LeaderBoard",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<UserProfile>>(
                  stream: DatabaseService.allUserProfiles,
                  builder: (context, snapshot) => snapshot.connectionState !=
                          ConnectionState.active
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => Card(
                                margin: index % 2 == 0 ? edgeLeft : edgeRight,
                                shape: RoundedRectangleBorder(
                                    borderRadius: index % 2 == 0
                                        ? borderRight
                                        : borderLeft),
                                elevation: 5,
                                shadowColor: Colors.teal,
                                //                           <-- Card
                                child: SizedBox(
                                  width: 50,
                                  child: ListTile(
                                    title: Text(snapshot.data![index].name),
                                    trailing: Text(snapshot
                                        .data![index].highestScore
                                        .toString()),
                                  ),
                                ),
                              ))),
            ),
          ],
        ),
      ),
    ));
  }
}
