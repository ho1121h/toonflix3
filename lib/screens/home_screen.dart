import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// 상태 클라스, 1500초에서 -1 으로 새로고침 진행
class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false; //1.false 상태
  int totalPomodoros = 0;
  late Timer timer; // 타이머 설정 (타이머)

  void onTick(Timer timer) {
    //2. 타이머 시작 (매 초마다 실행되는 메서드)
    if (totalSeconds == 0) {
      // 시간이 모드 소모되면
      setState(() {
        //다음과 같은 상태로 초기화
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    // 버튼을 누르면 진행함
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true; // true라서 움직이기 시작함
    });
  }

// 타이머를 멈추는 역할을하는 함수
  void onPausePressed() {
    timer.cancel();
    setState(() {
      // 상태 변화함수
      isRunning = false;
    });
  }

  void onStopPressed() {
    // 버튼을 누르면
    timer.cancel();
    totalSeconds = twentyFiveMinutes;
    setState(() {
      isRunning = false;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);

    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning
                        ? onPausePressed
                        : onStartPressed, //작동중인 상태에 따라 다른 함수 실행함
                    icon: Icon(isRunning //아이콘 : 정지, 재생버튼
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline),
                  ),
                  IconButton(
                    // 좀더 간격이 좁게
                    iconSize: 80,
                    color: Theme.of(context).cardColor,
                    onPressed: onStopPressed,
                    icon: const Icon(Icons.restart_alt_outlined),
                  ),
                ],
              ),
            ),
          ),
          // Flexible(
          //     flex: 2,
          //     child: Center(
          //       child: IconButton(
          //         iconSize: 80,
          //         color: Theme.of(context).cardColor,
          //         onPressed: onStopPressed,
          //         icon: const Icon(Icons.stop),
          //       ),
          //     )),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  //확장하는 위젯젯
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
