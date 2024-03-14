import 'package:currency_exchange/utils/app_colors.dart';
import 'package:currency_exchange/view_models/update_cubit/update_data_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewBoard extends StatefulWidget {
  final state;
  final animation;
  final controller;
  final textColor;
  final boardColor;
  final items;
  final boardID;
  final VoidCallback onTap;
  final Function(bool) changeLabels;
  final Function(Object?) onChanged;
  const ViewBoard({
    super.key,
    required this.state,
    required this.animation,
    required this.controller,
    required this.textColor,
    required this.boardColor,
    required this.items,
    required this.changeLabels,
    required this.boardID,
    required this.onChanged,
    required this.onTap,
  });

  @override
  State<ViewBoard> createState() => _ViewBoardState();
}

class _ViewBoardState extends State<ViewBoard> {
  @override
  Widget build(BuildContext context) {
    final updateDataCubit = BlocProvider.of<UpdateDataCubit>(context);

    final size = MediaQuery.of(context).size;
    return SlideTransition(
      position: widget.animation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: size.height >= size.width ? 210.h : size.height / 2,
        width: size.height >= size.width ? size.width : size.width / 2,
        decoration: BoxDecoration(
          color: widget.boardColor,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 30.0, left: 30.0),
          child: widget.state is UpdatingData
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton2(
                            customButton: Text(
                              "${widget.boardID == "1" ? widget.state.firstCurrency : widget.state.secondCurrency}",
                              style: GoogleFonts.kanit(
                                color: widget.textColor,
                                fontSize:
                                    size.height >= size.width ? 30.sp : 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            underline: const Text(""),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 300,
                              decoration: BoxDecoration(
                                color: widget.boardColor,
                              ),
                            ),
                            style: GoogleFonts.kanit(
                              color: widget.textColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            items: widget.items,
                            onChanged: widget.onChanged,
                            value: widget.boardID == "1"
                                ? widget.state.firstCurrency
                                : widget.state.secondCurrency,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.boardID == "1"
                                ? "1 ${widget.state.firstCurrency} ~ ${widget.state.factor} ${widget.state.secondCurrency}"
                                : "1 ${widget.state.secondCurrency} ~ ${1 / widget.state.factor} ${widget.state.firstCurrency}",
                            style: GoogleFonts.kanit(
                              fontSize:
                                  size.height >= size.width ? 11.sp : 7.sp,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: size.height / 12,
                            child: TextField(
                              onTap: widget.onTap,
                              decoration: const InputDecoration(),
                              controller: widget.controller,
                              onChanged: (value) {
                                setState(() {
                                  widget.changeLabels(widget.boardID != "1");
                                });
                              },
                              style: GoogleFonts.kanit(
                                color: widget.textColor,
                                fontSize:
                                    size.height >= size.width ? 20.sp : 10.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
