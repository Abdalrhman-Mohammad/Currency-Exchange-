part of 'update_data_cubit.dart';

sealed class UpdateDataState {}

final class UpdateDataInitial extends UpdateDataState {}

final class UpdatingData extends UpdateDataState {}

final class UpdatedData extends UpdateDataState {
  UpdatedData({
    required this.factor,
    required this.secondCurrency,
    required this.firstCurrency,
    required this.controllerOfFirstCurrency,
    required this.controllerOfSecondCurrency,
    this.message,
    this.readyCurrencies,
  });


  String? message;
  Map<String, double>? readyCurrencies;
  double factor;
  String secondCurrency;
  String firstCurrency;
  TextEditingController controllerOfFirstCurrency;
  TextEditingController controllerOfSecondCurrency;
}

final class UpdatingDataError extends UpdateDataState {
  UpdatingDataError({
    required this.error,
  });

  String error;
}
