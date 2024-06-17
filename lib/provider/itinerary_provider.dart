import 'dart:developer' as developer;
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:iterasi1/model/activity.dart';
import 'package:iterasi1/model/day.dart';
import 'package:iterasi1/model/itinerary.dart';

class ItineraryProvider extends ChangeNotifier {
  late Itinerary _itinerary;
  late Itinerary initialItinerary;
  Itinerary get itinerary => _itinerary;

  bool get isDataChanged =>
      _itinerary.toJsonString() != initialItinerary.toJsonString();

  void initItinerary(Itinerary newItinerary) {
    _itinerary = newItinerary.copy();
    initialItinerary = newItinerary.copy();
    notifyListeners();
  }

  void setNewItineraryTitle(String newTitle) {
    _itinerary.title = newTitle;
  }

  void addDay(Day newDay) {
    try {
      _itinerary.days = [..._itinerary.days, newDay];
    } catch (e) {
      developer.log("$e", name: 'qqq');
    }
    notifyListeners();
  }

  void initializeDays(List<DateTime> dates) {
    List<DateTime> sortedNewDates = dates..sort();

    List<DateTime> currentDates =
        _itinerary.days.map((e) => e.getDatetime()).toList();

    List<Day> finalDays = [];

    var i = 0;
    var j = 0;
    // Push semua currentDates yang gak ada di sortedNewDates
    while (i < sortedNewDates.length && j < currentDates.length) {
      if (currentDates[j].isBefore(sortedNewDates[i])) {
        j++;
      } else if (currentDates[j].isAfter(sortedNewDates[i]))
        finalDays.add(Day.from(sortedNewDates[i++]));
      else {
        finalDays.add(_itinerary.days[j].copy());
        j++;
        i++;
      }
    }
    while (i < sortedNewDates.length) {
      finalDays.add(Day.from(sortedNewDates[i++]));
    }

    _itinerary.days = finalDays;
    print('final : ${_itinerary.days[0].date}');

    notifyListeners();
  }

  List<Day> getDateTime() {
    return _itinerary.days;
  }

  // String convertDateTimeToString({required DateTime dateTime}) =>
  //     "${dateTime.day}/" "${dateTime.month}/" "${dateTime.year}";

  void updateActivity({
    required int updatedDayIndex,
    required int updatedActivityIndex,
    required Activity newActivity,
  }) {
    _itinerary = itinerary.copy(
        days: itinerary.days.mapIndexed((index, day) {
      if (index == updatedDayIndex) {
        return day.copy(
            activities: day.activities.mapIndexed((index, activity) {
          if (index == updatedActivityIndex) {
            return newActivity;
          }
          return activity;
        }).toList());
      }
      return day;
    }).toList());
    notifyListeners();
  }

  void insertNewActivity(
      {required List<Activity> activities, required Activity newActivity}) {
    print('new activity :${newActivity.endDateTime}');
    activities.add(newActivity);
    notifyListeners();
  }

  void removeActivity(
      {required List<Activity> activities, required int removedHashCode}) {
    activities.removeWhere((element) => element.hashCode == removedHashCode);
    notifyListeners();
  }

  void addPhotoActivity(
      {required Activity activity, required String pathImage}) {
    activity.images!.add(pathImage);
    log("ADD IMAGE $pathImage");
    notifyListeners();
  }

  void removePhotoActivity({
    required Activity activity,
    required String pathImage,
  }) {
    activity.removedImages!.add(pathImage);
    log("ADD TO REMOVED IMAGE $pathImage");
    log("removed images" + activity.removedImages.toString());
    notifyListeners();
  }

  void returnPhotoActivity({
    required Activity activity,
    required String pathImage,
  }) {
    activity.removedImages!.remove(pathImage);
    log("RETURN IMAGE $pathImage");
    log("removed images${activity.removedImages}");
    notifyListeners();
  }

  void cleanPhotoActivity({
    required Activity activity,
  }) {
    activity.images = [];
    developer.log("CLEANING");
    notifyListeners();
  }

  Future<List<Activity>> getSortedActivity(List<Activity> activities) async {
    return activities
      ..sort((a, b) {
        return a.startDateTime.compareTo(b.startDateTime);
      });
  }

  List<String> getImage(Activity activity) {
    return activity.images!;
  }
}
