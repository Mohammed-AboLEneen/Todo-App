// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hive/hive.dart';
// import 'package:todo_list_app/features/homePage/data/models/task_card_model/task_card_model.dart';
//
// import '../../../../constents.dart';
// import '../../../../cores/methods/check_internet_status.dart';
//
// class HomePageRemoteSource {
//   var collection = FirebaseFirestore.instance.collection('users');
//
//   Future<void> addNewTask({required TaskCardModel task}) async {
//     bool statusOfInternet = await checkInternetStatus();
//
//     if (statusOfInternet == false) {
//       Box box1 = Hive.box<TaskCardModel>('changes');
//       var changedTask = task.copyWith();
//       changedTask.change[0] = 'add';
//       await box1.put(task.key, changedTask);
//
//       box1.values.toList().forEach((element) {
//         print('key: ${element.title}, change: ${element.change}');
//       });
//       return;
//     }
//
//     Map<String, dynamic> data = task.toJson();
//
//     collection.doc(uId).collection('All').add(data);
//     collection.doc(uId).collection('Not Done').add(data);
//   }
//
//   Future<List<TaskCardModel>> getData() async {
//     // Get docs from collection reference
//     QuerySnapshot querySnapshot =
//         await collection.doc(uId).collection('All').get();
//
//     // Get data from docs and convert map to List
//     List<TaskCardModel> allData = querySnapshot.docs.isEmpty
//         ? []
//         : querySnapshot.docs
//             .map((doc) => TaskCardModel.fromJson(
//                   doc.data() as Map<String, dynamic>,
//                 ))
//             .toList();
//
//     Box box1 = Hive.box<TaskCardModel>('All');
//     for (TaskCardModel task in allData) {
//       box1.put(task.key, task);
//     }
//
//     QuerySnapshot querySnapshot2 =
//         await collection.doc(uId).collection('Done').get();
//
//     List<TaskCardModel> doneData = querySnapshot2.docs.isEmpty
//         ? []
//         : querySnapshot2.docs
//             .map((doc) => TaskCardModel.fromJson(
//                   doc.data() as Map<String, dynamic>,
//                 ))
//             .toList();
//
//     // Get data from docs and convert map to List
//     Box box2 = Hive.box<TaskCardModel>('Done');
//     for (TaskCardModel task in doneData) {
//       box2.put(task.key, task);
//     }
//
//     QuerySnapshot querySnapshot3 =
//         await collection.doc(uId).collection('Not Done').get();
//
//     // Get data from docs and convert map to List
//     List<TaskCardModel> notDoneData = querySnapshot3.docs.isEmpty
//         ? []
//         : querySnapshot3.docs
//             .map((doc) => TaskCardModel.fromJson(
//                   doc.data() as Map<String, dynamic>,
//                 ))
//             .toList();
//
//     Box box3 = Hive.box<TaskCardModel>('Not Done');
//     for (TaskCardModel task in notDoneData) {
//       box3.put(task.key, task);
//     }
//
//     return allData;
//   }
//
//   Future<void> deleteTask({required TaskCardModel task}) async {
//     bool statusOfInternet = await checkInternetStatus();
//     if (statusOfInternet == false) {
//       Box box1 = Hive.box<TaskCardModel>('changes');
//
//       if (box1.containsKey(task.key)) {
//         var changedTask = box1.get(task.key);
//         changedTask.change?[3] = 'delete';
//
//         changedTask = changedTask.copyWith(
//             change: changedTask.change,
//             createTime: task.createTime,
//             title: task.title,
//             date: task.date,
//             status: task.status);
//
//         print('key: ${changedTask.key} change: ${changedTask.change}');
//         await box1.put(
//             task.key, changedTask.copyWith(change: changedTask.change));
//       } else {
//         task.change[3] = 'delete';
//         await box1.put(task.key, task.copyWith());
//       }
//       box1.values.toList().forEach((element) {
//         print('key: ${element.title}, change: ${element.change}');
//       });
//       return;
//     }
//
//     var snapshotAll = await collection
//         .doc(uId)
//         .collection('All')
//         .where('key', isEqualTo: task.key)
//         .limit(1)
//         .get();
//
//     var snapshot = await collection
//         .doc(uId)
//         .collection(task.status == 1 ? 'Done' : 'Not Done')
//         .where('key', isEqualTo: task.key)
//         .limit(1)
//         .get();
//
//     if (snapshotAll.docs.isNotEmpty) {
//       collection
//           .doc(uId)
//           .collection('All')
//           .doc(snapshotAll.docs[0].id)
//           .delete();
//     }
//
//     if (snapshot.docs.isNotEmpty) {
//       collection
//           .doc(uId)
//           .collection(task.status == 1 ? 'Done' : 'Not Done')
//           .doc(snapshot.docs[0].id)
//           .delete();
//     }
//   }
//
//   Future<void> editTask({required TaskCardModel task}) async {
//     bool statusOfInternet = await checkInternetStatus();
//     if (statusOfInternet == false) {
//       Box box1 = Hive.box<TaskCardModel>('changes');
//
//       // print('task: ${t.title}, key: ${t.key} change: ${t.change}');
//       if (box1.containsKey(task.key)) {
//         var changedTask = box1.get(task.key);
//         changedTask.change?[1] = 'edit';
//         changedTask = changedTask.copyWith(
//             change: changedTask.change,
//             createTime: task.createTime,
//             title: task.title,
//             date: task.date,
//             status: task.status);
//
//         print('key: ${changedTask.key} change: ${changedTask.change}');
//         await box1.put(
//             task.key, changedTask.copyWith(change: changedTask.change));
//       } else {
//         var changedTask = task.copyWith();
//         changedTask.change[1] = 'edit';
//         await box1.put(task.key, changedTask);
//       }
//
//       box1.values.toList().forEach((element) {
//         print('key: ${element.title}, change: ${element.change}');
//       });
//       return;
//     }
//
//     var snapshotAll = await collection
//         .doc(uId)
//         .collection('All')
//         .where('key', isEqualTo: task.key)
//         .get();
//     var snapshot = await collection
//         .doc(uId)
//         .collection(task.status == 1 ? 'Done' : 'Not Done')
//         .where('key', isEqualTo: task.key)
//         .get();
//
//     if (snapshotAll.docs.isNotEmpty) {
//       snapshotAll.docs.first.reference.update(task.toJson());
//     }
//
//     if (snapshot.docs.isNotEmpty) {
//       snapshot.docs.first.reference.update(task.toJson());
//     }
//   }
//
//   Future<void> changeTaskStatus({
//     required TaskCardModel task,
//   }) async {
//     // this condition will be applied only if there is task status is already in the box and converted.
//     int newStatus = task.status;
//     if (task.change[2] != 'status') {
//       if (task.status == 1) {
//         newStatus = 0;
//       } else {
//         newStatus = 1;
//       }
//     }
//     bool statusOfInternet = await checkInternetStatus();
//     if (statusOfInternet == false) {
//       Box box1 = Hive.box<TaskCardModel>('changes');
//
//       if (box1.containsKey(task.key)) {
//         TaskCardModel changedTask = box1.get(task.key);
//         changedTask.change[2] = 'status';
//
//         changedTask = changedTask.copyWith(
//             change: changedTask.change,
//             createTime: task.createTime,
//             title: task.title,
//             date: task.date,
//             status: newStatus);
//
//         print('key: ${changedTask.key} change: ${changedTask.change}');
//         await box1.put(
//             task.key, changedTask.copyWith(change: changedTask.change));
//       } else {
//         var changedTask = task.copyWith();
//         changedTask.change[2] = 'status';
//
//         changedTask = changedTask.copyWith(
//             change: changedTask.change,
//             createTime: task.createTime,
//             title: task.title,
//             date: task.date,
//             status: newStatus);
//         await box1.put(task.key, changedTask);
//       }
//       box1.values.toList().forEach((element) {
//         print('key: ${element.title}, change: ${element.change}');
//       });
//       return;
//     }
//
//     var snapshotAll = await collection
//         .doc(uId)
//         .collection('All')
//         .where('key', isEqualTo: task.key)
//         .limit(1)
//         .get();
//
//     var snapshotNotDone = await collection
//         .doc(uId)
//         .collection('Not Done')
//         .where('key', isEqualTo: task.key)
//         .limit(1)
//         .get();
//
//     var snapshotDone = await collection
//         .doc(uId)
//         .collection('Done')
//         .where('key', isEqualTo: task.key)
//         .limit(1)
//         .get();
//
//     collection
//         .doc(uId)
//         .collection('All')
//         .doc(snapshotAll.docs[0].id)
//         .update(task.copyWith(status: newStatus).toJson());
//
//     print('newStatus: ${newStatus}');
//     if (newStatus == 1) {
//       if (snapshotDone.docs.isEmpty) {
//         collection
//             .doc(uId)
//             .collection('Done')
//             .add(task.copyWith(status: newStatus).toJson());
//       }
//
//       if (snapshotNotDone.docs.isNotEmpty) {
//         collection
//             .doc(uId)
//             .collection('Not Done')
//             .doc(snapshotNotDone.docs[0].id)
//             .delete();
//       }
//     } else {
//       if (snapshotNotDone.docs.isEmpty) {
//         collection
//             .doc(uId)
//             .collection('Not Done')
//             .add(task.copyWith(status: newStatus).toJson());
//       }
//
//       if (snapshotDone.docs.isNotEmpty) {
//         collection
//             .doc(uId)
//             .collection('Done')
//             .doc(snapshotDone.docs[0].id)
//             .delete();
//       }
//     }
//   }
// }
