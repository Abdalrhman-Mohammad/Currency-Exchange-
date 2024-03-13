import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_exchange/services/api_services.dart';

part 'update_data_state.dart';

class UpdateDataCubit extends Cubit<UpdateDataState> {
  UpdateDataCubit() : super(UpdateDataInitial());
  ApiServices apiServices = ApiServices.instance;
  String firstCurrency = "JOD";
  String secondCurrency = "ILS";
  TextEditingController controllerOfFirstCurrency = TextEditingController();
  TextEditingController controllerOfSecondCurrency = TextEditingController();
  void getLocalUpadte({
    String? newFirstCurrency,
    String? newSecondCurrency,
    TextEditingController? firstCurrencyController,
    TextEditingController? secondCurrencyController,
  }) async {
    controllerOfFirstCurrency =
        firstCurrencyController ?? controllerOfFirstCurrency;
    controllerOfSecondCurrency =
        secondCurrencyController ?? controllerOfSecondCurrency;
    try {
      firstCurrency = newFirstCurrency ?? firstCurrency;
      secondCurrency = newSecondCurrency ?? secondCurrency;
      double factor = (apiServices.currunciesWithValues[secondCurrency]!) /
          (apiServices.currunciesWithValues[firstCurrency]!);

      if (newFirstCurrency == null) {
        if (controllerOfSecondCurrency.text.isNotEmpty) {
          controllerOfFirstCurrency.text =
              (double.parse(controllerOfSecondCurrency.text) * (1 / factor))
                  .toStringAsFixed(3);
        }
      } else if (newSecondCurrency == null) {
        if (controllerOfFirstCurrency.text.isNotEmpty) {
          controllerOfSecondCurrency.text =
              (double.parse(controllerOfFirstCurrency.text) * factor)
                  .toStringAsFixed(3)
                  .trimRight();
        }
      } else {
        controllerOfFirstCurrency.text = controllerOfSecondCurrency.text = "";
      }
      emit(UpdatedData(
        message: apiServices.lastDate,
        readyCurrencies: apiServices.currunciesWithValues,
        factor: factor,
        firstCurrency: firstCurrency,
        secondCurrency: secondCurrency,
        controllerOfFirstCurrency: controllerOfFirstCurrency,
        controllerOfSecondCurrency: controllerOfSecondCurrency,
      ));
    } catch (e) {
      emit(UpdatingDataError(error: e.toString()));
    }
  }

  void getApiUpadte() async {
    try {
      emit(UpdatingData());
      await apiServices.checkData();
      double factor = (apiServices.currunciesWithValues[secondCurrency]!) /
          (apiServices.currunciesWithValues[firstCurrency]!);
      emit(UpdatedData(
        message: apiServices.lastDate,
        readyCurrencies: apiServices.currunciesWithValues,
        factor: factor,
        firstCurrency: firstCurrency,
        secondCurrency: secondCurrency,
        controllerOfFirstCurrency: controllerOfFirstCurrency,
        controllerOfSecondCurrency: controllerOfSecondCurrency,
      ));
    } catch (e) {
      emit(UpdatingDataError(error: e.toString()));
    }
  }
}
