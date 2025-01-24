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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appBarVisible'] = this.appBarVisible;
    data['titleAppBar'] = this.titleAppBar;
    data['userNameVisible'] = this.userNameVisible;
    data['allowBack'] = this.allowBack;
    data['title'] = this.title;
    data['cartVisible'] = this.cartVisible;
    data['notificationVisible'] = this.notificationVisible;
    data['titleVisible'] = this.titleVisible;
    return data;
  }
}
