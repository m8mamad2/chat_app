



import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/data/model/user_model.dart';

import '../../../../core/widget/loading.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import '../../screens/setting_screen/edit_bio_screen.dart';



class SettingAccountItemsWidget extends StatelessWidget {
  const SettingAccountItemsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: sizeW(context),
        color: theme(context).backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.023,vertical: sizeH(context)*0.05),
              child: Text('Account'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header',color: theme(context).primaryColorDark),),
            ),
            BlocBuilder<GetUserData,GetUserDataState>(
                builder: (context, state) {
                  if(state is LoadingUserDataState)return smallLoading(context);
                  if(state is LoadedUserDataState){
                    UserModel data = state.model!;
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        oneAccountWidget(context,'Phone',data.phone!,(){}),
                        oneAccountWidget(context,'Bio', data.info ?? 'nothing',()=> context.navigation(context, const EditBioScreen())),
                      ],
                    );
                  }
                return const SizedBox.shrink();
              },),
          ],
        ),
      ),
    );
  }
}

Widget oneAccountWidget(BuildContext context,String title,String subtitle,VoidCallback onTap)=> Padding(
  padding: EdgeInsets.zero,
  child: ListTile(
    onTap: onTap,
    title: Text(title.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'body',fontWeight: FontWeight.bold,fontSize: sizeW(context)*0.02),),
    subtitle: Text(subtitle.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400,fontSize: sizeW(context)*0.015),),
  ),
);

