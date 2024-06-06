import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/constents.dart';
import 'package:todo_list_app/features/homePage/presentation/view/widgets/create_task_bottom_widget.dart';
import 'package:todo_list_app/features/homePage/presentation/view/widgets/tasks_listview.dart';
import '../../../../cores/utlis/app_fonts.dart';
import '../../../../cores/widgets/segment_button.dart';
import '../manager/home_page_cubit/home_page_cubit.dart';
import '../manager/home_page_cubit/home_page_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomePageCubit()..initCurrentTasksBox(),
        child: BlocConsumer<HomePageCubit, HomePageStates>(
            listener: (context, state) {},
            builder: (context, state) {
              HomePageCubit homePageCubit = HomePageCubit.get(context);

              return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      right: 20, left: 20, top: 25, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: AppFonts.textStyle30Medium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SegmentButtonList(),
                      const SizedBox(
                        height: 20,
                      ),
                      if (state is GetTaskLoadingState)
                        Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: mainColor,
                            ),
                          ),
                        ),
                      if (state is! GetTaskLoadingState ||
                          homePageCubit.tasks.isNotEmpty)
                        TasksListview(
                            tasks: homePageCubit.tasks,
                            tasksLen: homePageCubit.allTasksCount,
                            topic: homePageCubit
                                .topics[homePageCubit.currentTopicIndex]),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CreateTaskButtonWidget(
                          tasksLength: homePageCubit.allTasksCount,
                          topic: homePageCubit
                              .topics[homePageCubit.currentTopicIndex],
                        ),
                      ),
                    ],
                  ),
                )),
              );
            }));
  }
}
