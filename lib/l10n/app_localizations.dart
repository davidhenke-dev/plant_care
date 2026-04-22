import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @tabHome.
  ///
  /// In de, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabPlants.
  ///
  /// In de, this message translates to:
  /// **'Pflanzen'**
  String get tabPlants;

  /// No description provided for @tabLocations.
  ///
  /// In de, this message translates to:
  /// **'Standorte'**
  String get tabLocations;

  /// No description provided for @settingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In de, this message translates to:
  /// **'Erscheinungsbild'**
  String get settingsAppearance;

  /// No description provided for @settingsDesign.
  ///
  /// In de, this message translates to:
  /// **'Design'**
  String get settingsDesign;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In de, this message translates to:
  /// **'Hell'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In de, this message translates to:
  /// **'Dunkel'**
  String get settingsThemeDark;

  /// No description provided for @settingsReminders.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen'**
  String get settingsReminders;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In de, this message translates to:
  /// **'Push-Benachrichtigungen'**
  String get settingsPushNotifications;

  /// No description provided for @settingsPushSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Tägliche Gieß-Erinnerung'**
  String get settingsPushSubtitle;

  /// No description provided for @settingsCalendar.
  ///
  /// In de, this message translates to:
  /// **'Apple Calendar'**
  String get settingsCalendar;

  /// No description provided for @settingsCalendarSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Gieß-Termine in Kalender eintragen'**
  String get settingsCalendarSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In de, this message translates to:
  /// **'App-Sprache ändern'**
  String get settingsLanguageSubtitle;

  /// No description provided for @homeTodayTitle.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get homeTodayTitle;

  /// No description provided for @homeNeedsWatering.
  ///
  /// In de, this message translates to:
  /// **'Zu gießen'**
  String get homeNeedsWatering;

  /// No description provided for @homeNeedsFertilizing.
  ///
  /// In de, this message translates to:
  /// **'Zu düngen'**
  String get homeNeedsFertilizing;

  /// No description provided for @homeAllDone.
  ///
  /// In de, this message translates to:
  /// **'Alles erledigt! 🎉'**
  String get homeAllDone;

  /// No description provided for @homeNothingToDo.
  ///
  /// In de, this message translates to:
  /// **'Heute gibt es nichts zu tun.'**
  String get homeNothingToDo;

  /// No description provided for @homeWeatherNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt'**
  String get homeWeatherNow;

  /// No description provided for @homeWeatherNowNight.
  ///
  /// In de, this message translates to:
  /// **'Jetzt (Nacht)'**
  String get homeWeatherNowNight;

  /// No description provided for @homeWeatherTonight.
  ///
  /// In de, this message translates to:
  /// **'Heute Nacht'**
  String get homeWeatherTonight;

  /// No description provided for @homeWeatherTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Tagsüber'**
  String get homeWeatherTomorrow;

  /// No description provided for @plantsTitle.
  ///
  /// In de, this message translates to:
  /// **'Pflanzen'**
  String get plantsTitle;

  /// No description provided for @plantsEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Pflanzen'**
  String get plantsEmpty;

  /// No description provided for @plantsEmptyHint.
  ///
  /// In de, this message translates to:
  /// **'Tippe auf + um eine anzulegen'**
  String get plantsEmptyHint;

  /// No description provided for @plantsDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Pflanze löschen'**
  String get plantsDeleteTitle;

  /// No description provided for @plantsDeleteMessage.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du \"{name}\" wirklich löschen?'**
  String plantsDeleteMessage(String name);

  /// No description provided for @plantsNeedsWateringToday.
  ///
  /// In de, this message translates to:
  /// **'Muss heute gegossen werden'**
  String get plantsNeedsWateringToday;

  /// No description provided for @plantsWateringInterval.
  ///
  /// In de, this message translates to:
  /// **'Alle {days} Tage'**
  String plantsWateringInterval(int days);

  /// No description provided for @locationsTitle.
  ///
  /// In de, this message translates to:
  /// **'Standorte'**
  String get locationsTitle;

  /// No description provided for @locationsEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Standorte'**
  String get locationsEmpty;

  /// No description provided for @locationsEmptyHint.
  ///
  /// In de, this message translates to:
  /// **'Tippe auf + um einen anzulegen'**
  String get locationsEmptyHint;

  /// No description provided for @locationsDeleteTitle.
  ///
  /// In de, this message translates to:
  /// **'Standort löschen'**
  String get locationsDeleteTitle;

  /// No description provided for @locationsDeleteMessage.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du \"{name}\" wirklich löschen?'**
  String locationsDeleteMessage(String name);

  /// No description provided for @locationDetailTitle.
  ///
  /// In de, this message translates to:
  /// **'Standort'**
  String get locationDetailTitle;

  /// No description provided for @locationDetailPlantsTitle.
  ///
  /// In de, this message translates to:
  /// **'Pflanzen hier'**
  String get locationDetailPlantsTitle;

  /// No description provided for @locationDetailNoPlantsHint.
  ///
  /// In de, this message translates to:
  /// **'Keine Pflanzen an diesem Standort.'**
  String get locationDetailNoPlantsHint;

  /// No description provided for @locationDetailReassignButton.
  ///
  /// In de, this message translates to:
  /// **'Umziehen'**
  String get locationDetailReassignButton;

  /// No description provided for @locationDetailReassignTitle.
  ///
  /// In de, this message translates to:
  /// **'Neuen Standort wählen'**
  String get locationDetailReassignTitle;

  /// No description provided for @locationFieldName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get locationFieldName;

  /// No description provided for @locationFieldLight.
  ///
  /// In de, this message translates to:
  /// **'Licht'**
  String get locationFieldLight;

  /// No description provided for @locationFieldHumidity.
  ///
  /// In de, this message translates to:
  /// **'Feuchtigkeit'**
  String get locationFieldHumidity;

  /// No description provided for @locationFieldDraft.
  ///
  /// In de, this message translates to:
  /// **'Zugluft'**
  String get locationFieldDraft;

  /// No description provided for @locationFieldHeated.
  ///
  /// In de, this message translates to:
  /// **'Geheizt im Winter'**
  String get locationFieldHeated;

  /// No description provided for @locationLightFull.
  ///
  /// In de, this message translates to:
  /// **'☀️ Sonnig'**
  String get locationLightFull;

  /// No description provided for @locationLightPartial.
  ///
  /// In de, this message translates to:
  /// **'⛅ Halbschattig'**
  String get locationLightPartial;

  /// No description provided for @locationLightShade.
  ///
  /// In de, this message translates to:
  /// **'🌥 Schattig'**
  String get locationLightShade;

  /// No description provided for @locationHumidityDry.
  ///
  /// In de, this message translates to:
  /// **'🏜 Trocken'**
  String get locationHumidityDry;

  /// No description provided for @locationHumidityModerate.
  ///
  /// In de, this message translates to:
  /// **'🌤 Moderat'**
  String get locationHumidityModerate;

  /// No description provided for @locationHumidityHumid.
  ///
  /// In de, this message translates to:
  /// **'💧 Feucht'**
  String get locationHumidityHumid;

  /// No description provided for @locationDrafty.
  ///
  /// In de, this message translates to:
  /// **'Zugluft'**
  String get locationDrafty;

  /// No description provided for @locationUnheated.
  ///
  /// In de, this message translates to:
  /// **'Ungeheizt'**
  String get locationUnheated;

  /// No description provided for @yes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get no;

  /// No description provided for @plantDetailInfoTab.
  ///
  /// In de, this message translates to:
  /// **'Info'**
  String get plantDetailInfoTab;

  /// No description provided for @plantDetailLocationTab.
  ///
  /// In de, this message translates to:
  /// **'Standort'**
  String get plantDetailLocationTab;

  /// No description provided for @plantDetailPhotosTab.
  ///
  /// In de, this message translates to:
  /// **'Fotos'**
  String get plantDetailPhotosTab;

  /// No description provided for @plantDetailWateringInterval.
  ///
  /// In de, this message translates to:
  /// **'Gießintervall'**
  String get plantDetailWateringInterval;

  /// No description provided for @plantDetailLastWatered.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt gegossen'**
  String get plantDetailLastWatered;

  /// No description provided for @plantDetailNextWatering.
  ///
  /// In de, this message translates to:
  /// **'Nächste Bewässerung'**
  String get plantDetailNextWatering;

  /// No description provided for @plantDetailNotes.
  ///
  /// In de, this message translates to:
  /// **'Notizen'**
  String get plantDetailNotes;

  /// No description provided for @plantDetailFertilizingInterval.
  ///
  /// In de, this message translates to:
  /// **'Düngeintervall'**
  String get plantDetailFertilizingInterval;

  /// No description provided for @plantDetailLastFertilized.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt gedüngt'**
  String get plantDetailLastFertilized;

  /// No description provided for @plantDetailNextFertilizing.
  ///
  /// In de, this message translates to:
  /// **'Nächste Düngung'**
  String get plantDetailNextFertilizing;

  /// No description provided for @plantDetailNeverWatered.
  ///
  /// In de, this message translates to:
  /// **'Noch nie'**
  String get plantDetailNeverWatered;

  /// No description provided for @plantDetailMarkWatered.
  ///
  /// In de, this message translates to:
  /// **'Als gegossen markieren 💧'**
  String get plantDetailMarkWatered;

  /// No description provided for @plantDetailMarkFertilized.
  ///
  /// In de, this message translates to:
  /// **'Als gedüngt markieren 🌱'**
  String get plantDetailMarkFertilized;

  /// No description provided for @plantDetailNoPhoto.
  ///
  /// In de, this message translates to:
  /// **'Kein Foto vorhanden'**
  String get plantDetailNoPhoto;

  /// No description provided for @plantDetailChangePhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto ändern'**
  String get plantDetailChangePhoto;

  /// No description provided for @plantDetailLocationNotFound.
  ///
  /// In de, this message translates to:
  /// **'Standort nicht gefunden'**
  String get plantDetailLocationNotFound;

  /// No description provided for @plantDetailEveryNWeeks.
  ///
  /// In de, this message translates to:
  /// **'Alle {weeks} Wochen'**
  String plantDetailEveryNWeeks(int weeks);

  /// No description provided for @plantDetailEveryNDays.
  ///
  /// In de, this message translates to:
  /// **'Alle {days} Tage'**
  String plantDetailEveryNDays(int days);

  /// No description provided for @wateringCardNeverWatered.
  ///
  /// In de, this message translates to:
  /// **'Noch nie gegossen'**
  String get wateringCardNeverWatered;

  /// No description provided for @wateringCardInterval.
  ///
  /// In de, this message translates to:
  /// **'Intervall: alle {days} Tage'**
  String wateringCardInterval(int days);

  /// No description provided for @fertilizingCardNeverFertilized.
  ///
  /// In de, this message translates to:
  /// **'Noch nie gedüngt'**
  String get fertilizingCardNeverFertilized;

  /// No description provided for @fertilizingCardInterval.
  ///
  /// In de, this message translates to:
  /// **'Intervall: alle {weeks} Wochen'**
  String fertilizingCardInterval(int weeks);

  /// No description provided for @actionCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get actionDelete;

  /// No description provided for @actionSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get actionSave;

  /// No description provided for @actionNext.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get actionNext;

  /// No description provided for @actionDone.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get actionDone;

  /// No description provided for @createPlantStep1Title.
  ///
  /// In de, this message translates to:
  /// **'Wie heißt deine\nneue Pflanze?'**
  String get createPlantStep1Title;

  /// No description provided for @createPlantStep1Subtitle.
  ///
  /// In de, this message translates to:
  /// **'Such sie in unserer Datenbank – wir füllen den Rest für dich aus.'**
  String get createPlantStep1Subtitle;

  /// No description provided for @createPlantNameHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. Monstera, Kaktus, Rosmarin …'**
  String get createPlantNameHint;

  /// No description provided for @createPlantSearchButton.
  ///
  /// In de, this message translates to:
  /// **'In Pflanzendatenbank suchen'**
  String get createPlantSearchButton;

  /// No description provided for @createPlantSearchHint.
  ///
  /// In de, this message translates to:
  /// **'Pflanze suchen …'**
  String get createPlantSearchHint;

  /// No description provided for @createPlantOrManualLabel.
  ///
  /// In de, this message translates to:
  /// **'oder manuell eingeben'**
  String get createPlantOrManualLabel;

  /// No description provided for @createPlantOrDivider.
  ///
  /// In de, this message translates to:
  /// **'oder'**
  String get createPlantOrDivider;

  /// No description provided for @createPlantManualEntry.
  ///
  /// In de, this message translates to:
  /// **'Manuell eingeben'**
  String get createPlantManualEntry;

  /// No description provided for @createPlantStep2Title.
  ///
  /// In de, this message translates to:
  /// **'Wann hast du zuletzt gegossen?'**
  String get createPlantStep2Title;

  /// No description provided for @createPlantStep2Subtitle.
  ///
  /// In de, this message translates to:
  /// **'Optional – wir erinnern dich dann genau zum richtigen Zeitpunkt.'**
  String get createPlantStep2Subtitle;

  /// No description provided for @createPlantWateringIntervalLabel.
  ///
  /// In de, this message translates to:
  /// **'Gieß-Intervall'**
  String get createPlantWateringIntervalLabel;

  /// No description provided for @createPlantLastWateredLabel.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt gegossen'**
  String get createPlantLastWateredLabel;

  /// No description provided for @createPlantNotYetWatered.
  ///
  /// In de, this message translates to:
  /// **'Noch nicht gewählt'**
  String get createPlantNotYetWatered;

  /// No description provided for @createPlantPickDate.
  ///
  /// In de, this message translates to:
  /// **'Datum wählen'**
  String get createPlantPickDate;

  /// No description provided for @createPlantClearDate.
  ///
  /// In de, this message translates to:
  /// **'Entfernen'**
  String get createPlantClearDate;

  /// No description provided for @createPlantDaysUnit.
  ///
  /// In de, this message translates to:
  /// **'Tage'**
  String get createPlantDaysUnit;

  /// No description provided for @createPlantStep3Title.
  ///
  /// In de, this message translates to:
  /// **'Düngst du deine Pflanze?'**
  String get createPlantStep3Title;

  /// No description provided for @createPlantStep3Subtitle.
  ///
  /// In de, this message translates to:
  /// **'Optional – falls du düngst, können wir dich daran erinnern.'**
  String get createPlantStep3Subtitle;

  /// No description provided for @createPlantFertilizingToggle.
  ///
  /// In de, this message translates to:
  /// **'Pflanze düngen'**
  String get createPlantFertilizingToggle;

  /// No description provided for @createPlantFertilizingIntervalLabel.
  ///
  /// In de, this message translates to:
  /// **'Dünge-Intervall'**
  String get createPlantFertilizingIntervalLabel;

  /// No description provided for @createPlantLastFertilizedLabel.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt gedüngt'**
  String get createPlantLastFertilizedLabel;

  /// No description provided for @createPlantWeeksUnit.
  ///
  /// In de, this message translates to:
  /// **'Wochen'**
  String get createPlantWeeksUnit;

  /// No description provided for @createPlantStep4Title.
  ///
  /// In de, this message translates to:
  /// **'Wo steht deine Pflanze?'**
  String get createPlantStep4Title;

  /// No description provided for @createPlantStep4Subtitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle einen Standort aus oder lege zuerst einen an.'**
  String get createPlantStep4Subtitle;

  /// No description provided for @createPlantNoLocations.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Standorte vorhanden.\nLege zuerst einen Standort an.'**
  String get createPlantNoLocations;

  /// No description provided for @createPlantStep5Title.
  ///
  /// In de, this message translates to:
  /// **'Noch etwas?'**
  String get createPlantStep5Title;

  /// No description provided for @createPlantStep5Subtitle.
  ///
  /// In de, this message translates to:
  /// **'Füge optional ein Foto und Notizen hinzu.'**
  String get createPlantStep5Subtitle;

  /// No description provided for @createPlantPhotoLabel.
  ///
  /// In de, this message translates to:
  /// **'Foto hinzufügen'**
  String get createPlantPhotoLabel;

  /// No description provided for @createPlantPhotoChange.
  ///
  /// In de, this message translates to:
  /// **'Foto ändern'**
  String get createPlantPhotoChange;

  /// No description provided for @createPlantNotesHint.
  ///
  /// In de, this message translates to:
  /// **'Notizen (optional) …'**
  String get createPlantNotesHint;

  /// No description provided for @createPlantSaveButton.
  ///
  /// In de, this message translates to:
  /// **'Pflanze anlegen'**
  String get createPlantSaveButton;

  /// No description provided for @createPlantToastName.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib deiner Pflanze einen Namen.'**
  String get createPlantToastName;

  /// No description provided for @createPlantToastLocation.
  ///
  /// In de, this message translates to:
  /// **'Bitte wähle einen Standort aus.'**
  String get createPlantToastLocation;

  /// No description provided for @weatherSettingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Wetterstandort'**
  String get weatherSettingsTitle;

  /// No description provided for @weatherSettingsDynamic.
  ///
  /// In de, this message translates to:
  /// **'GPS (dynamisch)'**
  String get weatherSettingsDynamic;

  /// No description provided for @weatherSettingsStatic.
  ///
  /// In de, this message translates to:
  /// **'Fester Ort'**
  String get weatherSettingsStatic;

  /// No description provided for @weatherSettingsDynamicSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Wetter wird anhand deines aktuellen GPS-Standorts geladen.'**
  String get weatherSettingsDynamicSubtitle;

  /// No description provided for @weatherSettingsStaticSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Wetter wird für einen festen Ort geladen.'**
  String get weatherSettingsStaticSubtitle;

  /// No description provided for @weatherSettingsPickOnMap.
  ///
  /// In de, this message translates to:
  /// **'Auf Karte wählen'**
  String get weatherSettingsPickOnMap;

  /// No description provided for @weatherSettingsNoLocationSet.
  ///
  /// In de, this message translates to:
  /// **'Kein Ort gewählt'**
  String get weatherSettingsNoLocationSet;

  /// No description provided for @mapPickerTitle.
  ///
  /// In de, this message translates to:
  /// **'Ort wählen'**
  String get mapPickerTitle;

  /// No description provided for @mapPickerConfirm.
  ///
  /// In de, this message translates to:
  /// **'Diesen Ort verwenden'**
  String get mapPickerConfirm;

  /// No description provided for @mapPickerSearching.
  ///
  /// In de, this message translates to:
  /// **'Ort wird ermittelt …'**
  String get mapPickerSearching;

  /// No description provided for @noLocation.
  ///
  /// In de, this message translates to:
  /// **'Kein Standort'**
  String get noLocation;

  /// No description provided for @noLocationHint.
  ///
  /// In de, this message translates to:
  /// **'Ohne Standort'**
  String get noLocationHint;

  /// No description provided for @unknownLocation.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get unknownLocation;

  /// No description provided for @errorPrefix.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {message}'**
  String errorPrefix(String message);

  /// No description provided for @tabChat.
  ///
  /// In de, this message translates to:
  /// **'Planty'**
  String get tabChat;

  /// No description provided for @chatTitle.
  ///
  /// In de, this message translates to:
  /// **'Pflanzen-Assistent'**
  String get chatTitle;

  /// No description provided for @chatPlaceholder.
  ///
  /// In de, this message translates to:
  /// **'Frag mich etwas über deine Pflanzen …'**
  String get chatPlaceholder;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Pflanzen-Assistent'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In de, this message translates to:
  /// **'Frag mich alles über Pflege, Diagnose oder die Bestimmung deiner Pflanzen. Du kannst auch Fotos anhängen.'**
  String get chatEmptySubtitle;

  /// No description provided for @chatAddImage.
  ///
  /// In de, this message translates to:
  /// **'Bild hinzufügen'**
  String get chatAddImage;

  /// No description provided for @chatErrorMessage.
  ///
  /// In de, this message translates to:
  /// **'Ups, etwas ist schiefgelaufen. Bitte versuche es erneut.'**
  String get chatErrorMessage;

  /// No description provided for @settingsSeasonalReminders.
  ///
  /// In de, this message translates to:
  /// **'Saisonale Erinnerungen'**
  String get settingsSeasonalReminders;

  /// No description provided for @settingsSeasonalSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Tipps bei Saisonwechsel (Winter/Sommer)'**
  String get settingsSeasonalSubtitle;

  /// No description provided for @settingsAiChat.
  ///
  /// In de, this message translates to:
  /// **'KI-Chat'**
  String get settingsAiChat;

  /// No description provided for @settingsAiChatSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Pflanzenassistent via Claude AI'**
  String get settingsAiChatSubtitle;

  /// No description provided for @plantDetailCareTab.
  ///
  /// In de, this message translates to:
  /// **'Pflege-Tipps'**
  String get plantDetailCareTab;

  /// No description provided for @plantDetailCareLoading.
  ///
  /// In de, this message translates to:
  /// **'Tipps werden geladen …'**
  String get plantDetailCareLoading;

  /// No description provided for @plantDetailCareError.
  ///
  /// In de, this message translates to:
  /// **'Keine Daten verfügbar'**
  String get plantDetailCareError;

  /// No description provided for @plantDetailCareDescription.
  ///
  /// In de, this message translates to:
  /// **'Beschreibung'**
  String get plantDetailCareDescription;

  /// No description provided for @plantDetailCareSunlight.
  ///
  /// In de, this message translates to:
  /// **'Licht'**
  String get plantDetailCareSunlight;

  /// No description provided for @plantDetailCareMaintenance.
  ///
  /// In de, this message translates to:
  /// **'Pflegeaufwand'**
  String get plantDetailCareMaintenance;

  /// No description provided for @plantDetailCarePruning.
  ///
  /// In de, this message translates to:
  /// **'Schnittzeit'**
  String get plantDetailCarePruning;

  /// No description provided for @locationRecommendationsTitle.
  ///
  /// In de, this message translates to:
  /// **'Empfohlene Pflanzen'**
  String get locationRecommendationsTitle;

  /// No description provided for @locationRecommendationsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Diese Pflanzentypen gedeihen an diesem Standort besonders gut.'**
  String get locationRecommendationsSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
