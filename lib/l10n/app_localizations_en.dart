// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabPlants => 'Plants';

  @override
  String get tabLocations => 'Locations';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsDesign => 'Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsReminders => 'Reminders';

  @override
  String get settingsPushNotifications => 'Push Notifications';

  @override
  String get settingsPushSubtitle => 'Daily watering reminder';

  @override
  String get settingsCalendar => 'Apple Calendar';

  @override
  String get settingsCalendarSubtitle => 'Add watering events to calendar';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Change app language';

  @override
  String get homeTodayTitle => 'Today';

  @override
  String get homeNeedsWatering => 'Needs watering';

  @override
  String get homeNeedsFertilizing => 'Needs fertilizing';

  @override
  String get homeAllDone => 'All done! 🎉';

  @override
  String get homeNothingToDo => 'Nothing to do today.';

  @override
  String get homeWeatherNow => 'Now';

  @override
  String get homeWeatherNowNight => 'Now (Night)';

  @override
  String get homeWeatherTonight => 'Tonight';

  @override
  String get homeWeatherTomorrow => 'During the day';

  @override
  String get plantsTitle => 'Plants';

  @override
  String get plantsEmpty => 'No plants yet';

  @override
  String get plantsEmptyHint => 'Tap + to add one';

  @override
  String get plantsDeleteTitle => 'Delete plant';

  @override
  String plantsDeleteMessage(String name) {
    return 'Do you really want to delete \"$name\"?';
  }

  @override
  String get plantsNeedsWateringToday => 'Needs watering today';

  @override
  String plantsWateringInterval(int days) {
    return 'Every $days days';
  }

  @override
  String get locationsTitle => 'Locations';

  @override
  String get locationsEmpty => 'No locations yet';

  @override
  String get locationsEmptyHint => 'Tap + to add one';

  @override
  String get locationsDeleteTitle => 'Delete location';

  @override
  String locationsDeleteMessage(String name) {
    return 'Do you really want to delete \"$name\"?';
  }

  @override
  String get locationDetailTitle => 'Location';

  @override
  String get locationDetailPlantsTitle => 'Plants here';

  @override
  String get locationDetailNoPlantsHint => 'No plants at this location.';

  @override
  String get locationDetailReassignButton => 'Move';

  @override
  String get locationDetailReassignTitle => 'Select new location';

  @override
  String get locationFieldName => 'Name';

  @override
  String get locationFieldLight => 'Light';

  @override
  String get locationFieldHumidity => 'Humidity';

  @override
  String get locationFieldDraft => 'Drafty';

  @override
  String get locationFieldHeated => 'Heated in winter';

  @override
  String get locationLightFull => '☀️ Sunny';

  @override
  String get locationLightPartial => '⛅ Partial shade';

  @override
  String get locationLightShade => '🌥 Shady';

  @override
  String get locationHumidityDry => '🏜 Dry';

  @override
  String get locationHumidityModerate => '🌤 Moderate';

  @override
  String get locationHumidityHumid => '💧 Humid';

  @override
  String get locationDrafty => 'Drafty';

  @override
  String get locationUnheated => 'Unheated';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get plantDetailInfoTab => 'Info';

  @override
  String get plantDetailLocationTab => 'Location';

  @override
  String get plantDetailPhotosTab => 'Photos';

  @override
  String get plantDetailWateringInterval => 'Watering interval';

  @override
  String get plantDetailLastWatered => 'Last watered';

  @override
  String get plantDetailNextWatering => 'Next watering';

  @override
  String get plantDetailNotes => 'Notes';

  @override
  String get plantDetailFertilizingInterval => 'Fertilizing interval';

  @override
  String get plantDetailLastFertilized => 'Last fertilized';

  @override
  String get plantDetailNextFertilizing => 'Next fertilizing';

  @override
  String get plantDetailNeverWatered => 'Never';

  @override
  String get plantDetailMarkWatered => 'Mark as watered 💧';

  @override
  String get plantDetailMarkFertilized => 'Mark as fertilized 🌱';

  @override
  String get plantDetailNoPhoto => 'No photo available';

  @override
  String get plantDetailChangePhoto => 'Change photo';

  @override
  String get plantDetailLocationNotFound => 'Location not found';

  @override
  String plantDetailEveryNWeeks(int weeks) {
    return 'Every $weeks weeks';
  }

  @override
  String plantDetailEveryNDays(int days) {
    return 'Every $days days';
  }

  @override
  String get wateringCardNeverWatered => 'Never watered';

  @override
  String wateringCardInterval(int days) {
    return 'Interval: every $days days';
  }

  @override
  String get fertilizingCardNeverFertilized => 'Never fertilized';

  @override
  String fertilizingCardInterval(int weeks) {
    return 'Interval: every $weeks weeks';
  }

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSave => 'Save';

  @override
  String get actionNext => 'Next';

  @override
  String get actionDone => 'Done';

  @override
  String get createPlantStep1Title => 'What\'s your\nplant called?';

  @override
  String get createPlantStep1Subtitle =>
      'Search our database – we\'ll fill in the rest for you.';

  @override
  String get createPlantNameHint => 'e.g. Monstera, Cactus, Rosemary …';

  @override
  String get createPlantSearchButton => 'Search plant database';

  @override
  String get createPlantSearchHint => 'Search for a plant …';

  @override
  String get createPlantOrManualLabel => 'or enter manually';

  @override
  String get createPlantOrDivider => 'or';

  @override
  String get createPlantManualEntry => 'Enter manually';

  @override
  String get createPlantStep2Title => 'When did you last water it?';

  @override
  String get createPlantStep2Subtitle =>
      'Optional – we\'ll remind you at exactly the right time.';

  @override
  String get createPlantWateringIntervalLabel => 'Watering interval';

  @override
  String get createPlantLastWateredLabel => 'Last watered';

  @override
  String get createPlantNotYetWatered => 'Not selected yet';

  @override
  String get createPlantPickDate => 'Pick a date';

  @override
  String get createPlantClearDate => 'Remove';

  @override
  String get createPlantDaysUnit => 'days';

  @override
  String get createPlantStep3Title => 'Do you fertilize your plant?';

  @override
  String get createPlantStep3Subtitle =>
      'Optional – if you fertilize, we can remind you.';

  @override
  String get createPlantFertilizingToggle => 'Fertilize plant';

  @override
  String get createPlantFertilizingIntervalLabel => 'Fertilizing interval';

  @override
  String get createPlantLastFertilizedLabel => 'Last fertilized';

  @override
  String get createPlantWeeksUnit => 'weeks';

  @override
  String get createPlantStep4Title => 'Where does your plant live?';

  @override
  String get createPlantStep4Subtitle =>
      'Choose a location or create one first.';

  @override
  String get createPlantNoLocations =>
      'No locations yet.\nCreate a location first.';

  @override
  String get createPlantStep5Title => 'Anything else?';

  @override
  String get createPlantStep5Subtitle => 'Optionally add a photo and notes.';

  @override
  String get createPlantPhotoLabel => 'Add photo';

  @override
  String get createPlantPhotoChange => 'Change photo';

  @override
  String get createPlantNotesHint => 'Notes (optional) …';

  @override
  String get createPlantSaveButton => 'Add plant';

  @override
  String get createPlantToastName => 'Please give your plant a name.';

  @override
  String get createPlantToastLocation => 'Please select a location.';

  @override
  String get weatherSettingsTitle => 'Weather location';

  @override
  String get weatherSettingsDynamic => 'GPS (dynamic)';

  @override
  String get weatherSettingsStatic => 'Fixed location';

  @override
  String get weatherSettingsDynamicSubtitle =>
      'Weather is loaded based on your current GPS position.';

  @override
  String get weatherSettingsStaticSubtitle =>
      'Weather is loaded for a fixed location.';

  @override
  String get weatherSettingsPickOnMap => 'Pick on map';

  @override
  String get weatherSettingsNoLocationSet => 'No location set';

  @override
  String get mapPickerTitle => 'Pick location';

  @override
  String get mapPickerConfirm => 'Use this location';

  @override
  String get mapPickerSearching => 'Finding location …';

  @override
  String get noLocation => 'No location';

  @override
  String get noLocationHint => 'Without location';

  @override
  String get unknownLocation => 'Unknown';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get tabChat => 'Planty';

  @override
  String get chatTitle => 'Plant Assistant';

  @override
  String get chatPlaceholder => 'Ask me about your plants …';

  @override
  String get chatEmptyTitle => 'Plant Assistant';

  @override
  String get chatEmptySubtitle =>
      'Ask me anything about plant care, diagnosis, or identification. You can also attach photos.';

  @override
  String get chatAddImage => 'Add image';

  @override
  String get chatErrorMessage =>
      'Oops, something went wrong. Please try again.';

  @override
  String get settingsSeasonalReminders => 'Seasonal Reminders';

  @override
  String get settingsSeasonalSubtitle =>
      'Tips when the season changes (winter/summer)';

  @override
  String get settingsAiChat => 'AI Chat';

  @override
  String get settingsAiChatSubtitle => 'Plant assistant powered by Claude AI';

  @override
  String get plantDetailCareTab => 'Care Tips';

  @override
  String get plantDetailCareLoading => 'Loading care tips …';

  @override
  String get plantDetailCareError => 'No data available';

  @override
  String get plantDetailCareDescription => 'Description';

  @override
  String get plantDetailCareSunlight => 'Sunlight';

  @override
  String get plantDetailCareMaintenance => 'Maintenance';

  @override
  String get plantDetailCarePruning => 'Pruning season';

  @override
  String get locationRecommendationsTitle => 'Recommended Plants';

  @override
  String get locationRecommendationsSubtitle =>
      'These plant types thrive particularly well at this location.';
}
