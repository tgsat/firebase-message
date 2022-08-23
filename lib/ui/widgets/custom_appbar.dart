import 'package:flutter/material.dart';
import 'package:for_you/ui/widgets/myColors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class CustomAppBar {
  static AppBar multiple({

    required BuildContext context,
    bool useLogo = false, 
    bool useAction = false, 
    bool showBackButton = true,
    Widget? icon,
    Widget? iconAction,
    Widget? leading,
    }) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 10,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      iconTheme: const IconThemeData(
        color: MyColors.article,
      ),
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 10),
              child: leading ??
                  TouchableOpacity(
                      onTap: () {
                        Navigator.maybePop(context);
                      },
                      child: const Icon(Icons.arrow_back_rounded)),
          )
      : null,
      title: useLogo
          ? icon
          : SvgPicture.asset(
              'SVGResources.logo',
              height: 20,
            ),
      actions: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white.withOpacity(.6),
                ),
                padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.all(10),
                child: useAction ?
                  iconAction : const Icon(Icons.more_vert,size: 20)
                ),
          )],
    );
  }
}