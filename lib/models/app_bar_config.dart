class AppBarConfig {
  bool? appBarVisible;
  bool? titleAppBar;
  bool? userNameVisible;
  bool? allowBack;
  String? title;
  bool? cartVisible;
  bool? notificationVisible;
  bool? titleVisible;

  AppBarConfig(
      {this.appBarVisible,
        this.titleAppBar,
        this.userNameVisible,
        this.allowBack,
        this.title="",
        this.cartVisible,
        this.notificationVisible,
        this.titleVisible});

  AppBarConfig.fromJson(Map<String, dynamic> json) {
    appBarVisible = bool.tryParse(json['appBarVisible'].toString());
    titleAppBar = bool.tryParse(json['titleAppBar'].toString());
    userNameVisible = bool.tryParse(json['userNameVisible'].toString());
    allowBack = bool.tryParse(json['allowBack'].toString());
    title = json['title'];
    cartVisible = bool.tryParse(json['cartVisible'].toString());
    notificationVisible = bool.tryParse(json['notificationVisible'].toString());
    titleVisible = bool.tryParse(json['titleVisible'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appBarVisible'] = appBarVisible;
    data['titleAppBar'] = titleAppBar;
    data['userNameVisible'] = userNameVisible;
    data['allowBack'] = allowBack;
    data['title'] = title;
    data['cartVisible'] = cartVisible;
    data['notificationVisible'] = notificationVisible;
    data['titleVisible'] = titleVisible;
    return data;
  }
}
