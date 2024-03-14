import 'package:currency_exchange/utils/app_colors.dart';
import 'package:currency_exchange/view_models/update_cubit/update_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdatingBoard extends StatelessWidget {
  final state;
  const UpdatingBoard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final updateDataCubit = BlocProvider.of<UpdateDataCubit>(context);

    return Container(
      height: size.height >= size.width ? 60.h + 20.h : 50.h + 5.h,
      width: size.height > size.width ? size.width - 40 : (size.width - 40) / 2,
      decoration: BoxDecoration(
        color: AppColors.lightgreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 6.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 0.h),
              child: state is UpdatingData
                  ? SizedBox(
                      height: 16.h,
                      width: 16.h,
                      child: const CircularProgressIndicator.adaptive(),
                    )
                  : Text(
                      "Last Updated on " +
                          (state is UpdatedData
                              ? state.message! // be sure of null
                              : "error"),
                      style: GoogleFonts.kanit(
                        fontSize: size.height >= size.width ? 14.sp : 7.w,
                        color: AppColors.white,
                      ),
                    ),
            ),
            InkWell(
              onTap: () async {
                updateDataCubit.getApiUpadte();
              },
              child: Icon(
                Icons.refresh,
                color: AppColors.white,
                size: size.height >= size.width ? 23.sp : 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
