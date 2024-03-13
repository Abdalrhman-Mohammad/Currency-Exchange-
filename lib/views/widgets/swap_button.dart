// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:currency_exchange/view_models/update_cubit/update_data_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwapButton extends StatelessWidget {
  Animation<Offset> firstBoardAnimation;
  final AnimationController firstController;
  Animation<Offset> secondBoardAnimation;
  final AnimationController secondController;
  final textColor;
  final VoidCallback swapBoardsData;
  final VoidCallback determineTheAnimation;

  SwapButton({
    required this.firstBoardAnimation,
    required this.firstController,
    required this.secondBoardAnimation,
    required this.secondController,
    required this.textColor,
    required this.swapBoardsData,
    required this.determineTheAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final updateDataCubit = BlocProvider.of<UpdateDataCubit>(context);
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        determineTheAnimation();
        firstController.forward().then(
          (value) {
            firstController.reset();
          },
        );
        secondController.forward().then(
          (value) {
            secondController.reset();
            swapBoardsData();
            updateDataCubit.getLocalUpadte();
          },
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.horizontal(
            left: const Radius.circular(16),
            right: Radius.circular(size.height >= size.width ? 0 : 16),
          ),
        ),
        child: Center(
          child: Icon(
            size.height >= size.width ? Icons.swap_vert : Icons.swap_horiz,
            size: size.height >= size.width ? 64.h : 70.h,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
