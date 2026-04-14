class SettingsModel {
  bool soundEnabled;
  bool musicEnabled;
  String language;

  SettingsModel({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.language = 'Español',
  });
}