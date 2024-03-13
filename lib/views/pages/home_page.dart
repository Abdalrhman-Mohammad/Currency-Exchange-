import 'package:currency_exchange/utils/app_colors.dart';
import 'package:currency_exchange/view_models/theme_cubit/theme_cubit.dart';
import 'package:currency_exchange/view_models/update_cubit/update_data_cubit.dart';
import 'package:currency_exchange/views/widgets/updating_board.dart';
import 'package:currency_exchange/views/widgets/view_board.dart';
import 'package:currency_exchange/views/widgets/swap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TextEditingController controllerOfFirstCurrency;
  late TextEditingController controllerOfSecondCurrency;
  late final themeCubit;
  late final UpdateDataCubit updateDataCubit;
  late Animation<Offset> firstBoardAnimation;
  late final AnimationController _firstController;
  late Animation<Offset> secondBoardAnimation;
  late final AnimationController _secondController;
  late final ScrollController scrollController;
  double factor = -1;
  bool st = true;

  @override
  void initState() {
    super.initState();
    controllerOfFirstCurrency = TextEditingController();
    controllerOfSecondCurrency = TextEditingController();
    scrollController = ScrollController();
    themeCubit = BlocProvider.of<ThemeCubit>(context);
    updateDataCubit = BlocProvider.of<UpdateDataCubit>(context);
    _firstController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // )..repeat(reverse: true);
    firstBoardAnimation =
        Tween(begin: const Offset(0, 0), end: const Offset(0, 1.1)).animate(
            CurvedAnimation(parent: _firstController, curve: Curves.linear));
    _secondController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // )..repeat(reverse: true);
    secondBoardAnimation =
        Tween(begin: const Offset(0, 0), end: const Offset(0, -1.1)).animate(
            CurvedAnimation(parent: _secondController, curve: Curves.linear));
  }

  void changeLabels(bool whatEditingNow) {
    if (whatEditingNow) {
      if (controllerOfSecondCurrency.text.isEmpty) {
        controllerOfFirstCurrency.text = "";
        return;
      }
      controllerOfFirstCurrency.text =
          (double.parse(controllerOfSecondCurrency.text) * (1 / factor))
              .toStringAsFixed(3);
    } else {
      if (controllerOfFirstCurrency.text.isEmpty) {
        controllerOfSecondCurrency.text = "";
        return;
      }
      controllerOfSecondCurrency.text =
          (double.parse(controllerOfFirstCurrency.text) * factor)
              .toStringAsFixed(3)
              .trimRight();
    }
  }

  void swapBoardsData() {
    dynamic tmp;
    tmp = controllerOfSecondCurrency.text;
    controllerOfSecondCurrency.text = controllerOfFirstCurrency.text;
    controllerOfFirstCurrency.text = tmp;
    tmp = updateDataCubit.firstCurrency;
    updateDataCubit.firstCurrency = updateDataCubit.secondCurrency;
    updateDataCubit.secondCurrency = tmp;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          bloc: themeCubit,
          buildWhen: (previous, current) =>
              current is ThemeDark ||
              current is ThemeLight ||
              current is ThemeInitial,
          builder: (context, state) {
            Color boardColor;
            Color textColor;
            Color titleColor;
            if (state is ThemeInitial) {
              final mode =
                  Theme.of(context).scaffoldBackgroundColor == AppColors.silver
                      ? ThemeMode.light
                      : ThemeMode.dark;
              boardColor = mode == ThemeMode.light
                  ? AppColors.white
                  : AppColors.darkSilver;
              textColor =
                  mode == ThemeMode.light ? AppColors.black : AppColors.white;
              titleColor = mode == ThemeMode.light
                  ? AppColors.grey
                  : AppColors.darkSilver;
            } else if (state is ThemeLight) {
              boardColor = AppColors.white;
              textColor = AppColors.black;
              titleColor = AppColors.darkSilver;
            } else {
              boardColor = AppColors.darkSilver;
              textColor = AppColors.white;
              titleColor = AppColors.grey;
            }
            return BlocBuilder<UpdateDataCubit, UpdateDataState>(
              bloc: updateDataCubit,
              buildWhen: (previous, current) =>
                  current is UpdatedData ||
                  current is UpdatingData ||
                  current is UpdatingDataError,
              builder: (context, state) {
                print(size);
                if (state is UpdatingDataError) {
                  return const Center(
                    child: Text(
                        "Something wrong is going on , we will repair that soon!"),
                  );
                } else {
                  List<DropdownMenuItem<String>> dropdownItems = [];
                  if (state is UpdatedData) {
                    List<String> curruncies = [];
                    curruncies = state.readyCurrencies!.keys.toList();
                    curruncies.sort(
                      (e1, e2) {
                        String tmp1 = e1;
                        String tmp2 = e2;
                        if (tmp1.compareTo(tmp2) > 0) return 1;
                        return -1;
                      },
                    );
                    dropdownItems = curruncies.map<DropdownMenuItem<String>>(
                      (e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      },
                    ).toList();
                    factor = state.factor;
                    controllerOfFirstCurrency = state.controllerOfFirstCurrency;
                    controllerOfSecondCurrency =
                        state.controllerOfSecondCurrency;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: size.height,
                      width: size.width - 40,
                      child: Stack(
                        // fit: StackFit.expand,
                        children: [
                          Positioned(
                            top: 70.h,
                            child: Text(
                              "MONEY",
                              style: GoogleFonts.kanit(
                                fontSize:
                                    size.height >= size.width ? 55.sp : 20.sp,
                                color: titleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            top: size.height >= size.width
                                ? 595.h
                                : 150.h + size.height / 2 - 24.h,
                            left:
                                size.height >= size.width ? 0 : size.width / 2,
                            right: 0,
                            child: UpdatingBoard(state: state),
                          ),
                          Positioned(
                            top: size.height >= size.width ? 180.h : 150.h,
                            left: 0,
                            right:
                                size.height >= size.width ? 0 : size.width / 2,
                            child: ViewBoard(
                              animation: firstBoardAnimation,
                              boardColor: boardColor,
                              controller: controllerOfFirstCurrency,
                              items: dropdownItems,
                              state: state,
                              textColor: textColor,
                              boardID: "1",
                              onTap: () {
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    scrollController.jumpTo(120.h);
                                  },
                                );
                              },
                              onChanged: (value) {
                                updateDataCubit.getLocalUpadte(
                                  newFirstCurrency: value as String,
                                  firstCurrencyController:
                                      controllerOfFirstCurrency,
                                );
                              },
                              changeLabels: (bool whatEditingNow) {
                                if (whatEditingNow) {
                                  if (controllerOfSecondCurrency.text.isEmpty) {
                                    controllerOfFirstCurrency.text = "";
                                    return;
                                  }
                                  controllerOfFirstCurrency
                                      .text = (double.parse(
                                              controllerOfSecondCurrency.text) *
                                          (1 / factor))
                                      .toStringAsFixed(3);
                                } else {
                                  if (controllerOfFirstCurrency.text.isEmpty) {
                                    controllerOfSecondCurrency.text = "";
                                    return;
                                  }
                                  controllerOfSecondCurrency
                                      .text = (double.parse(
                                              controllerOfFirstCurrency.text) *
                                          factor)
                                      .toStringAsFixed(3)
                                      .trimRight();
                                }
                              },
                            ),
                          ),
                          Positioned(
                            top: size.height >= size.width ? 410.h : 150.h,
                            right: 0,
                            left:
                                size.height >= size.width ? 0 : size.width / 2,
                            child: ViewBoard(
                              animation: secondBoardAnimation,
                              boardColor: boardColor,
                              controller: controllerOfSecondCurrency,
                              items: dropdownItems,
                              state: state,
                              textColor: textColor,
                              boardID: "2",
                              onChanged: (value) {
                                updateDataCubit.getLocalUpadte(
                                  newSecondCurrency: value as String,
                                  secondCurrencyController:
                                      controllerOfSecondCurrency,
                                );
                              },
                              onTap: () {
                                scrollController.jumpTo(20.h);
                              },
                              changeLabels: (bool whatEditingNow) {
                                if (whatEditingNow) {
                                  if (controllerOfSecondCurrency.text.isEmpty) {
                                    controllerOfFirstCurrency.text = "";
                                    return;
                                  }
                                  controllerOfFirstCurrency
                                      .text = (double.parse(
                                              controllerOfSecondCurrency.text) *
                                          (1 / factor))
                                      .toStringAsFixed(3);
                                } else {
                                  if (controllerOfFirstCurrency.text.isEmpty) {
                                    controllerOfSecondCurrency.text = "";
                                    return;
                                  }
                                  controllerOfSecondCurrency
                                      .text = (double.parse(
                                              controllerOfFirstCurrency.text) *
                                          factor)
                                      .toStringAsFixed(3)
                                      .trimRight();
                                }
                              },
                            ),
                          ),
                          Positioned(
                            height: size.height >= size.width ? 64.h : 70.h,
                            width: size.height >= size.width ? 64.h : 70.h,
                            top: size.height >= size.width
                                ? 410.h - (64 / 8 * 5.2).h
                                : 160.h + (size.height / 2) / 2 - (70 / 2).h,
                            right: size.height >= size.width
                                ? 0
                                : size.width / 2 - (70 / 8 * 6.25).h,
                            child: SwapButton(
                              firstBoardAnimation: firstBoardAnimation,
                              firstController: _firstController,
                              secondBoardAnimation: secondBoardAnimation,
                              secondController: _secondController,
                              textColor: textColor,
                              swapBoardsData: () {
                                dynamic tmp;
                                tmp = controllerOfSecondCurrency.text;
                                controllerOfSecondCurrency.text =
                                    controllerOfFirstCurrency.text;
                                controllerOfFirstCurrency.text = tmp;
                                tmp = updateDataCubit.firstCurrency;
                                updateDataCubit.firstCurrency =
                                    updateDataCubit.secondCurrency;
                                updateDataCubit.secondCurrency = tmp;
                              },
                              determineTheAnimation: () {
                                if (size.height >= size.width) {
                                  firstBoardAnimation = Tween(
                                          begin: const Offset(0, 0),
                                          end: const Offset(0, 1.1))
                                      .animate(CurvedAnimation(
                                          parent: _firstController,
                                          curve: Curves.linear));
                                  secondBoardAnimation = Tween(
                                          begin: const Offset(0, 0),
                                          end: const Offset(0, -1.1))
                                      .animate(CurvedAnimation(
                                          parent: _secondController,
                                          curve: Curves.linear));
                                } else {
                                  firstBoardAnimation = Tween(
                                          begin: const Offset(0, 0),
                                          end: const Offset(1.1, 0))
                                      .animate(CurvedAnimation(
                                          parent: _firstController,
                                          curve: Curves.linear));

                                  secondBoardAnimation = Tween(
                                          begin: const Offset(0, 0),
                                          end: const Offset(-1.1, 0))
                                      .animate(CurvedAnimation(
                                          parent: _secondController,
                                          curve: Curves.linear));
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
