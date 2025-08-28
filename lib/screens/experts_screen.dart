import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindtech/app/config/app_colors.dart';
import 'package:mindtech/app/config/app_dimensions.dart';
import 'package:mindtech/app/config/app_images.dart';
import 'package:mindtech/app/config/app_strings.dart';
import 'package:mindtech/app/config/app_text_styles.dart';
import 'package:mindtech/blocs/expert/expert_bloc.dart';
import 'package:mindtech/blocs/expert/expert_event.dart';
import 'package:mindtech/blocs/expert/expert_state.dart';
import 'package:mindtech/models/expert_model.dart';
import 'package:mindtech/screens/items/appbar_custom.dart';
import 'package:mindtech/screens/items/expert_item.dart';

class ExpertsScreen extends StatelessWidget {
  const ExpertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ExpertBloc>().add(GetExpertData());
    return Scaffold(
      appBar: AppBarCustom(),
      body: Column(
        children: [
          SizedBox(height: AppSize.s20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.screenSpacing,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      context.read<ExpertBloc>().add(
                        SearchExpertData(query: value),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: AppString.search,
                      suffixIcon: Icon(Icons.search, size: 30),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: AppSize.s10,
                // ),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     height: AppSize.s50,
                //     width: AppSize.s50,
                //     decoration: BoxDecoration(
                //       color: AppColor.primary,
                //       borderRadius: BorderRadius.circular(AppSize.s8),
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(AppSize.s10),
                //       child: Icon(Icons.filter_list_outlined,color: AppColor.white,size: 25,),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ExpertBloc, ExpertState>(
              builder: (context, state) {
                if (state is ExpertLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ExpertLoaded) {
                  return ListView.builder(
                    itemCount: state.experts.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.screenSpacing,
                      vertical: AppSize.s10,
                    ),
                    itemBuilder: (context, index) {
                      ExpertModel experts = state.experts[index];
                      return ExpertItem(experts: experts,);
                    },
                  );
                } else if (state is ExpertFailure) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
