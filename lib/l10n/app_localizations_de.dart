// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get tabHome => 'Home';

  @override
  String get tabPlants => 'Pflanzen';

  @override
  String get tabLocations => 'Standorte';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get settingsDesign => 'Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsReminders => 'Erinnerungen';

  @override
  String get settingsPushNotifications => 'Push-Benachrichtigungen';

  @override
  String get settingsPushSubtitle => 'Tägliche Gieß-Erinnerung';

  @override
  String get settingsCalendar => 'Apple Calendar';

  @override
  String get settingsCalendarSubtitle => 'Gieß-Termine in Kalender eintragen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSubtitle => 'App-Sprache ändern';

  @override
  String get homeTodayTitle => 'Heute';

  @override
  String get homeNeedsWatering => 'Zu gießen';

  @override
  String get homeNeedsFertilizing => 'Zu düngen';

  @override
  String get homeAllDone => 'Alles erledigt! 🎉';

  @override
  String get homeNothingToDo => 'Heute gibt es nichts zu tun.';

  @override
  String get homeWeatherNow => 'Jetzt';

  @override
  String get homeWeatherNowNight => 'Jetzt (Nacht)';

  @override
  String get homeWeatherTonight => 'Heute Nacht';

  @override
  String get homeWeatherTomorrow => 'Tagsüber';

  @override
  String get plantsTitle => 'Pflanzen';

  @override
  String get plantsEmpty => 'Noch keine Pflanzen';

  @override
  String get plantsEmptyHint => 'Tippe auf + um eine anzulegen';

  @override
  String get plantsDeleteTitle => 'Pflanze löschen';

  @override
  String plantsDeleteMessage(String name) {
    return 'Möchtest du \"$name\" wirklich löschen?';
  }

  @override
  String get plantsNeedsWateringToday => 'Muss heute gegossen werden';

  @override
  String plantsWateringInterval(int days) {
    return 'Alle $days Tage';
  }

  @override
  String get locationsTitle => 'Standorte';

  @override
  String get locationsEmpty => 'Noch keine Standorte';

  @override
  String get locationsEmptyHint => 'Tippe auf + um einen anzulegen';

  @override
  String get locationsDeleteTitle => 'Standort löschen';

  @override
  String locationsDeleteMessage(String name) {
    return 'Möchtest du \"$name\" wirklich löschen?';
  }

  @override
  String get locationDetailTitle => 'Standort';

  @override
  String get locationDetailPlantsTitle => 'Pflanzen hier';

  @override
  String get locationDetailNoPlantsHint => 'Keine Pflanzen an diesem Standort.';

  @override
  String get locationDetailReassignButton => 'Umziehen';

  @override
  String get locationDetailReassignTitle => 'Neuen Standort wählen';

  @override
  String get locationFieldName => 'Name';

  @override
  String get locationFieldLight => 'Licht';

  @override
  String get locationFieldHumidity => 'Feuchtigkeit';

  @override
  String get locationFieldDraft => 'Zugluft';

  @override
  String get locationFieldHeated => 'Geheizt im Winter';

  @override
  String get locationLightFull => '☀️ Sonnig';

  @override
  String get locationLightPartial => '⛅ Halbschattig';

  @override
  String get locationLightShade => '🌥 Schattig';

  @override
  String get locationHumidityDry => '🏜 Trocken';

  @override
  String get locationHumidityModerate => '🌤 Moderat';

  @override
  String get locationHumidityHumid => '💧 Feucht';

  @override
  String get locationDrafty => 'Zugluft';

  @override
  String get locationUnheated => 'Ungeheizt';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get plantDetailInfoTab => 'Info';

  @override
  String get plantDetailLocationTab => 'Standort';

  @override
  String get plantDetailPhotosTab => 'Fotos';

  @override
  String get plantDetailWateringInterval => 'Gießintervall';

  @override
  String get plantDetailLastWatered => 'Zuletzt gegossen';

  @override
  String get plantDetailNextWatering => 'Nächste Bewässerung';

  @override
  String get plantDetailNotes => 'Notizen';

  @override
  String get plantDetailFertilizingInterval => 'Düngeintervall';

  @override
  String get plantDetailLastFertilized => 'Zuletzt gedüngt';

  @override
  String get plantDetailNextFertilizing => 'Nächste Düngung';

  @override
  String get plantDetailNeverWatered => 'Noch nie';

  @override
  String get plantDetailMarkWatered => 'Als gegossen markieren 💧';

  @override
  String get plantDetailMarkFertilized => 'Als gedüngt markieren 🌱';

  @override
  String get plantDetailNoPhoto => 'Kein Foto vorhanden';

  @override
  String get plantDetailChangePhoto => 'Foto ändern';

  @override
  String get plantDetailLocationNotFound => 'Standort nicht gefunden';

  @override
  String plantDetailEveryNWeeks(int weeks) {
    return 'Alle $weeks Wochen';
  }

  @override
  String plantDetailEveryNDays(int days) {
    return 'Alle $days Tage';
  }

  @override
  String get wateringCardNeverWatered => 'Noch nie gegossen';

  @override
  String wateringCardInterval(int days) {
    return 'Intervall: alle $days Tage';
  }

  @override
  String get fertilizingCardNeverFertilized => 'Noch nie gedüngt';

  @override
  String fertilizingCardInterval(int weeks) {
    return 'Intervall: alle $weeks Wochen';
  }

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionNext => 'Weiter';

  @override
  String get actionDone => 'Fertig';

  @override
  String get createPlantStep1Title => 'Wie heißt deine\nneue Pflanze?';

  @override
  String get createPlantStep1Subtitle =>
      'Such sie in unserer Datenbank – wir füllen den Rest für dich aus.';

  @override
  String get createPlantNameHint => 'z. B. Monstera, Kaktus, Rosmarin …';

  @override
  String get createPlantSearchButton => 'In Pflanzendatenbank suchen';

  @override
  String get createPlantSearchHint => 'Pflanze suchen …';

  @override
  String get createPlantOrManualLabel => 'oder manuell eingeben';

  @override
  String get createPlantOrDivider => 'oder';

  @override
  String get createPlantManualEntry => 'Manuell eingeben';

  @override
  String get createPlantStep2Title => 'Wann hast du zuletzt gegossen?';

  @override
  String get createPlantStep2Subtitle =>
      'Optional – wir erinnern dich dann genau zum richtigen Zeitpunkt.';

  @override
  String get createPlantWateringIntervalLabel => 'Gieß-Intervall';

  @override
  String get createPlantLastWateredLabel => 'Zuletzt gegossen';

  @override
  String get createPlantNotYetWatered => 'Noch nicht gewählt';

  @override
  String get createPlantPickDate => 'Datum wählen';

  @override
  String get createPlantClearDate => 'Entfernen';

  @override
  String get createPlantDaysUnit => 'Tage';

  @override
  String get createPlantStep3Title => 'Düngst du deine Pflanze?';

  @override
  String get createPlantStep3Subtitle =>
      'Optional – falls du düngst, können wir dich daran erinnern.';

  @override
  String get createPlantFertilizingToggle => 'Pflanze düngen';

  @override
  String get createPlantFertilizingIntervalLabel => 'Dünge-Intervall';

  @override
  String get createPlantLastFertilizedLabel => 'Zuletzt gedüngt';

  @override
  String get createPlantWeeksUnit => 'Wochen';

  @override
  String get createPlantStep4Title => 'Wo steht deine Pflanze?';

  @override
  String get createPlantStep4Subtitle =>
      'Wähle einen Standort aus oder lege zuerst einen an.';

  @override
  String get createPlantNoLocations =>
      'Noch keine Standorte vorhanden.\nLege zuerst einen Standort an.';

  @override
  String get createPlantStep5Title => 'Noch etwas?';

  @override
  String get createPlantStep5Subtitle =>
      'Füge optional ein Foto und Notizen hinzu.';

  @override
  String get createPlantPhotoLabel => 'Foto hinzufügen';

  @override
  String get createPlantPhotoChange => 'Foto ändern';

  @override
  String get createPlantNotesHint => 'Notizen (optional) …';

  @override
  String get createPlantSaveButton => 'Pflanze anlegen';

  @override
  String get createPlantToastName => 'Bitte gib deiner Pflanze einen Namen.';

  @override
  String get createPlantToastLocation => 'Bitte wähle einen Standort aus.';

  @override
  String get weatherSettingsTitle => 'Wetterstandort';

  @override
  String get weatherSettingsDynamic => 'GPS (dynamisch)';

  @override
  String get weatherSettingsStatic => 'Fester Ort';

  @override
  String get weatherSettingsDynamicSubtitle =>
      'Wetter wird anhand deines aktuellen GPS-Standorts geladen.';

  @override
  String get weatherSettingsStaticSubtitle =>
      'Wetter wird für einen festen Ort geladen.';

  @override
  String get weatherSettingsPickOnMap => 'Auf Karte wählen';

  @override
  String get weatherSettingsNoLocationSet => 'Kein Ort gewählt';

  @override
  String get mapPickerTitle => 'Ort wählen';

  @override
  String get mapPickerConfirm => 'Diesen Ort verwenden';

  @override
  String get mapPickerSearching => 'Ort wird ermittelt …';

  @override
  String get noLocation => 'Kein Standort';

  @override
  String get noLocationHint => 'Ohne Standort';

  @override
  String get unknownLocation => 'Unbekannt';

  @override
  String errorPrefix(String message) {
    return 'Fehler: $message';
  }

  @override
  String get tabChat => 'Planty';

  @override
  String get chatTitle => 'Pflanzen-Assistent';

  @override
  String get chatPlaceholder => 'Frag mich etwas über deine Pflanzen …';

  @override
  String get chatEmptyTitle => 'Pflanzen-Assistent';

  @override
  String get chatEmptySubtitle =>
      'Frag mich alles über Pflege, Diagnose oder die Bestimmung deiner Pflanzen. Du kannst auch Fotos anhängen.';

  @override
  String get chatAddImage => 'Bild hinzufügen';

  @override
  String get chatErrorMessage =>
      'Ups, etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get settingsSeasonalReminders => 'Saisonale Erinnerungen';

  @override
  String get settingsSeasonalSubtitle =>
      'Tipps bei Saisonwechsel (Winter/Sommer)';

  @override
  String get settingsAiChat => 'KI-Chat';

  @override
  String get settingsAiChatSubtitle => 'Pflanzenassistent via Claude AI';

  @override
  String get plantDetailCareTab => 'Pflege-Tipps';

  @override
  String get plantDetailCareLoading => 'Tipps werden geladen …';

  @override
  String get plantDetailCareError => 'Keine Daten verfügbar';

  @override
  String get plantDetailCareDescription => 'Beschreibung';

  @override
  String get plantDetailCareSunlight => 'Licht';

  @override
  String get plantDetailCareMaintenance => 'Pflegeaufwand';

  @override
  String get plantDetailCarePruning => 'Schnittzeit';

  @override
  String get locationRecommendationsTitle => 'Empfohlene Pflanzen';

  @override
  String get locationRecommendationsSubtitle =>
      'Diese Pflanzentypen gedeihen an diesem Standort besonders gut.';
}
