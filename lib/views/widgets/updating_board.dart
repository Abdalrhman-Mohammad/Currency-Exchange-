import 'package:currency_exchange/utils/app_colors.dart';
import 'package:currency_exchange/view_models/update_cubit/update_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdatingBoard extends StatelessWidget {
  final state;
  const UpdatingBoard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final updateDataCubit = BlocProvider.of<UpdateDataCubit>(context);

    return Container(
      height: 60,
      width: size.height > size.width ? size.width - 40 : (size.width - 40) / 2,
      decoration: BoxDecoration(
        color: AppColors.lightgreen,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: state is UpdatingData
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Text(
                      "Last Updated on " +
                          (state is UpdatedData
                              ? state.message! // be sure of null
                              : "error"),
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
            ),
            InkWell(
              onTap: () async {
                updateDataCubit.getApiUpadte();
              },
              child: const Icon(
                Icons.refresh,
                color: AppColors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
