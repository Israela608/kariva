import 'package:flutter/material.dart';
import 'package:kariva/utils/colors.dart';
import 'package:kariva/utils/dimensions.dart';
import 'package:kariva/widgets/small_text.dart';

class ExpandableTextWidget extends StatefulWidget {
  const ExpandableTextWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf; //The collapsed text
  late String secondHalf; //Remaining text

  bool hiddenText = true; //true if collapsed, false if expanded

  double textHeight = Dimensions.screenHeight / 5.63; //150 dynamic size

  @override
  void initState() {
    super.initState();

    //debugPrint('TEXT LENGTH    ' + widget.text.length.toString());
    //debugPrint('WIDGET HEIGHT    ' + textHeight.toString());

    //if the length of the text is more than ~150
    if (widget.text.length > textHeight) {
      //First to ~150th characters of the text
      firstHalf = widget.text.substring(0, textHeight.toInt());
      //The remaining
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(
              text: firstHalf,
              size: Dimensions.d16,
              color: AppColors.paraColor,
              height: 1.8,
            )
          : Column(
              children: [
                SmallText(
                  //If text is collapsed, show only the collapsed text and ..., else show all text
                  text: hiddenText
                      ? (firstHalf + '...')
                      : (firstHalf + secondHalf),
                  size: Dimensions.d16,
                  color: AppColors.paraColor,
                  height: 1.8,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      SmallText(
                        text: hiddenText ? 'Show more' : 'Show less',
                        color: AppColors.mainColor,
                      ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: AppColors.mainColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
