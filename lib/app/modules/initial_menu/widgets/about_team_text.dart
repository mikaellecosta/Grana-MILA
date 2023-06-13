import 'package:flutter/material.dart';
import 'package:lasic_grana_flutter/app/core/languages/brazilian_portuguese.dart';
import 'package:lasic_grana_flutter/app/core/utils/typography.dart';

class AboutTeamText extends StatelessWidget {
  const AboutTeamText({
    Key? key,
    required this.mediaQuery,
  }) : super(key: key);

  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQuery.size.height * 0.23,
        bottom: mediaQuery.size.height * 0.10,
        left: mediaQuery.size.width * 0.14,
        right: mediaQuery.size.width * 0.14,
      ),
      // TODO(YuriOliv): falta adicionar ao style a fonte dos textos
      // TODO(YuriOliv): muito provavelmente vai ser necessario um
      //  arquivo no remote config do firebase
      //  para criar esta pagina automaticamente
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Texto 1
          Text(
            BrazilianPortuguese().aboutGranaExplanation,
            style: AppTypography.font16(),
            textAlign: TextAlign.center,
          ),
          // Espaço entre textos
          SizedBox(height: mediaQuery.size.height * 0.02),
          // Texto 2
          Text(
            BrazilianPortuguese().titles[0],
            style: AppTypography.font16Bold(),
          ),
          // Espaço entre textos
          SizedBox(height: mediaQuery.size.height * 0.01),
          // Texto 3
          Text(
            BrazilianPortuguese().titles[1],
            style: AppTypography.font16Bold(),
          ),
          // Texto 4
          Text(
            BrazilianPortuguese().scholarProgrammers[0],
            style: AppTypography.font16(),
          ),
          // Texto 5
          Text(
            BrazilianPortuguese().scholarProgrammers[1],
            style: AppTypography.font16(),
          ),
          // Espaço entre textos
          SizedBox(height: mediaQuery.size.height * 0.01),
          // Texto 6
          Text(
            BrazilianPortuguese().titles[2],
            style: AppTypography.font16Bold(),
          ),
          // Texto 7
          Text(
            BrazilianPortuguese().volunteerDesigns[0],
            style: AppTypography.font16(),
          ),
          // Texto 8
          Text(
            BrazilianPortuguese().volunteerDesigns[1],
            style: AppTypography.font16(),
          ),
          // Espaço entre textos
          SizedBox(height: mediaQuery.size.height * 0.01),
          // Texto 9
          Text(
            BrazilianPortuguese().titles[3],
            style: AppTypography.font16Bold(),
          ),
          // Texto 10
          Text(
            BrazilianPortuguese().volunteerScreenwriters[0],
            style: AppTypography.font16(),
          ),
          // Texto 11
          Text(
            BrazilianPortuguese().volunteerScreenwriters[1],
            style: AppTypography.font16(),
          ),
          // Texto 12
          Text(
            BrazilianPortuguese().volunteerScreenwriters[2],
            style: AppTypography.font16(),
          ),
          // Espaço entre textos
          SizedBox(height: mediaQuery.size.height * 0.01),
          // Texto 13
          Text(
            BrazilianPortuguese().titles[4],
            style: AppTypography.font16Bold(),
          ),
          // Texto 14
          Text(
            BrazilianPortuguese().teachercoordinator,
            style: AppTypography.font16(),
          ),
          // Espaço entre textos
          SizedBox(height: mediaQuery.size.height * 0.01),
          // Texto 15
          Text(
            BrazilianPortuguese().titles[5],
            style: AppTypography.font16Bold(),
          ),
          // Texto 16
          Text(
            BrazilianPortuguese().reviewtests,
            style: AppTypography.font16(),
          ),
        ],
      ),
    );
  }
}
