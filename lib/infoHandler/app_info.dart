import 'package:flutter/cupertino.dart';

import '../models/directions.dart';
import '../models/trips_history_model.dart';


class AppInfo extends ChangeNotifier
{
  Directions? userPickUpLocation, userDropOffLocation;
  int ? countTotalTrips;
  String ? driverTotalEarnings ="0";
  String ? driverAverageRatings ="0";
  List<String> historyTripsKeysList =[];
  List<TripsHistoryModel> allTripsHistoryInformationList = [];


  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress)
  {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  updateOverAllTripsCounter(int overAllTripsCounter){
    countTotalTrips = overAllTripsCounter;
    notifyListeners();
  }
  updateOverAllTripsKey(List<String> tripsKeyList){
    historyTripsKeysList = tripsKeyList;
    notifyListeners();
  }
  updateOverTripsHistoryInformation(TripsHistoryModel eachTripHistory){
    this.allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }
  updateDriverTotalEarnings(String total){
    driverTotalEarnings = total;
    notifyListeners();
  }
  updateDriverAverageRatings(String driverRatings){
    driverAverageRatings = driverRatings;
    notifyListeners();
  }

  updateOverAllTripsHistoryInformation(TripsHistoryModel eachTripHistory)
  {
    allTripsHistoryInformationList.add(eachTripHistory);
    notifyListeners();
  }
  updateOverAllTripsKeys(List<String> tripsKeysList)
  {
    historyTripsKeysList = tripsKeysList;
    notifyListeners();
  }
}