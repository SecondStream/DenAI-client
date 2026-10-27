import 'package:den_ai/application/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoreUnavailableBanner extends StatelessWidget {
  const LoreUnavailableBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      color: Color(0xFFCC5555),
      alignment: Alignment.center,
      child: Text(
        AppLocalization.of(context).loreUnavailable,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}
