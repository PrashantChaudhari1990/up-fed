import 'package:mhassoc_ui/config/localization_config.dart';
import 'package:mhassoc_ui/themes/styles/theme_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSelectionModel extends StatefulWidget {
  const LanguageSelectionModel({super.key});

  @override
  State<LanguageSelectionModel> createState() => _LanguageSelectionModelState();
}

class _LanguageSelectionModelState extends State<LanguageSelectionModel> {
  Locale? locale;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        locale = context.locale;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Container(
      width: screenSize.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'select_your_pref_lang',
                style: theme.textTheme.titleMedium,
              ).tr(),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.clear,
                    color: ThemeColors.black,
                  ))
            ],
          ),
          ListView.separated(
            itemCount: LocalizationConfig.supportedLanguages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    locale =
                        LocalizationConfig.supportedLanguages[index].locale;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                      color: locale ==
                              LocalizationConfig
                                  .supportedLanguages[index].locale
                          ? ThemeColors.primaryColor.shade50
                          : ThemeColors.white,
                      border: Border.all(color: ThemeColors.primaryColor),
                      borderRadius: BorderRadius.circular(4)),
                  // color: ThemeColors.primaryColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: locale ==
                              LocalizationConfig
                                  .supportedLanguages[index].locale,
                          replacement: Icon(
                            Icons.radio_button_off,
                            color: ThemeColors.gray3,
                          ),
                          child: Icon(
                            Icons.radio_button_checked_rounded,
                            color: ThemeColors.primaryColor,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocalizationConfig
                                      .supportedLanguages[index].language,
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text(
                                  LocalizationConfig
                                      .supportedLanguages[index].langInEnglish,
                                  style: theme.textTheme.labelSmall
                                      ?.copyWith(color: ThemeColors.gray4),
                                ),
                              ],
                            ),
                            Text(
                              LocalizationConfig.supportedLanguages[index]
                                      .langShortCode ??
                                  "",
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(color: ThemeColors.gray3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (locale != null && locale != context.locale) {
                context.setLocale(locale!);
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
              }
            },
            child: const Text('continue').tr(),
          )
        ],
      ),
    );
  }
}
