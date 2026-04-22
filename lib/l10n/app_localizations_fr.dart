// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabPlants => 'Plantes';

  @override
  String get tabLocations => 'Emplacements';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsDesign => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsReminders => 'Rappels';

  @override
  String get settingsPushNotifications => 'Notifications push';

  @override
  String get settingsPushSubtitle => 'Rappel quotidien d\'arrosage';

  @override
  String get settingsCalendar => 'Apple Calendar';

  @override
  String get settingsCalendarSubtitle => 'Ajouter les arrosages au calendrier';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSubtitle => 'Changer la langue de l\'application';

  @override
  String get homeTodayTitle => 'Aujourd\'hui';

  @override
  String get homeNeedsWatering => 'À arroser';

  @override
  String get homeNeedsFertilizing => 'À fertiliser';

  @override
  String get homeAllDone => 'Tout fait ! 🎉';

  @override
  String get homeNothingToDo => 'Rien à faire aujourd\'hui.';

  @override
  String get homeWeatherNow => 'Maintenant';

  @override
  String get homeWeatherNowNight => 'Maintenant (nuit)';

  @override
  String get homeWeatherTonight => 'Ce soir';

  @override
  String get homeWeatherTomorrow => 'Dans la journée';

  @override
  String get plantsTitle => 'Plantes';

  @override
  String get plantsEmpty => 'Aucune plante';

  @override
  String get plantsEmptyHint => 'Appuie sur + pour en ajouter une';

  @override
  String get plantsDeleteTitle => 'Supprimer la plante';

  @override
  String plantsDeleteMessage(String name) {
    return 'Veux-tu vraiment supprimer \"$name\" ?';
  }

  @override
  String get plantsNeedsWateringToday => 'À arroser aujourd\'hui';

  @override
  String plantsWateringInterval(int days) {
    return 'Tous les $days jours';
  }

  @override
  String get locationsTitle => 'Emplacements';

  @override
  String get locationsEmpty => 'Aucun emplacement';

  @override
  String get locationsEmptyHint => 'Appuie sur + pour en créer un';

  @override
  String get locationsDeleteTitle => 'Supprimer l\'emplacement';

  @override
  String locationsDeleteMessage(String name) {
    return 'Veux-tu vraiment supprimer \"$name\" ?';
  }

  @override
  String get locationDetailTitle => 'Emplacement';

  @override
  String get locationDetailPlantsTitle => 'Plantes ici';

  @override
  String get locationDetailNoPlantsHint => 'Aucune plante à cet emplacement.';

  @override
  String get locationDetailReassignButton => 'Déplacer';

  @override
  String get locationDetailReassignTitle => 'Choisir un nouvel emplacement';

  @override
  String get locationFieldName => 'Nom';

  @override
  String get locationFieldLight => 'Lumière';

  @override
  String get locationFieldHumidity => 'Humidité';

  @override
  String get locationFieldDraft => 'Courants d\'air';

  @override
  String get locationFieldHeated => 'Chauffé en hiver';

  @override
  String get locationLightFull => '☀️ Ensoleillé';

  @override
  String get locationLightPartial => '⛅ Mi-ombre';

  @override
  String get locationLightShade => '🌥 Ombragé';

  @override
  String get locationHumidityDry => '🏜 Sec';

  @override
  String get locationHumidityModerate => '🌤 Modéré';

  @override
  String get locationHumidityHumid => '💧 Humide';

  @override
  String get locationDrafty => 'Courants d\'air';

  @override
  String get locationUnheated => 'Non chauffé';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get plantDetailInfoTab => 'Info';

  @override
  String get plantDetailLocationTab => 'Emplacement';

  @override
  String get plantDetailPhotosTab => 'Photos';

  @override
  String get plantDetailWateringInterval => 'Fréquence d\'arrosage';

  @override
  String get plantDetailLastWatered => 'Dernier arrosage';

  @override
  String get plantDetailNextWatering => 'Prochain arrosage';

  @override
  String get plantDetailNotes => 'Notes';

  @override
  String get plantDetailFertilizingInterval => 'Fréquence de fertilisation';

  @override
  String get plantDetailLastFertilized => 'Dernière fertilisation';

  @override
  String get plantDetailNextFertilizing => 'Prochaine fertilisation';

  @override
  String get plantDetailNeverWatered => 'Jamais';

  @override
  String get plantDetailMarkWatered => 'Marquer comme arrosé 💧';

  @override
  String get plantDetailMarkFertilized => 'Marquer comme fertilisé 🌱';

  @override
  String get plantDetailNoPhoto => 'Aucune photo disponible';

  @override
  String get plantDetailChangePhoto => 'Changer la photo';

  @override
  String get plantDetailLocationNotFound => 'Emplacement introuvable';

  @override
  String plantDetailEveryNWeeks(int weeks) {
    return 'Toutes les $weeks semaines';
  }

  @override
  String plantDetailEveryNDays(int days) {
    return 'Tous les $days jours';
  }

  @override
  String get wateringCardNeverWatered => 'Jamais arrosé';

  @override
  String wateringCardInterval(int days) {
    return 'Intervalle : tous les $days jours';
  }

  @override
  String get fertilizingCardNeverFertilized => 'Jamais fertilisé';

  @override
  String fertilizingCardInterval(int weeks) {
    return 'Intervalle : toutes les $weeks semaines';
  }

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionNext => 'Suivant';

  @override
  String get actionDone => 'Terminé';

  @override
  String get createPlantStep1Title => 'Comment s\'appelle\nta plante ?';

  @override
  String get createPlantStep1Subtitle =>
      'Cherche dans notre base – on remplit le reste pour toi.';

  @override
  String get createPlantNameHint => 'ex. Monstera, Cactus, Romarin …';

  @override
  String get createPlantSearchButton => 'Rechercher dans la base';

  @override
  String get createPlantSearchHint => 'Rechercher une plante …';

  @override
  String get createPlantOrManualLabel => 'ou entrer manuellement';

  @override
  String get createPlantOrDivider => 'ou';

  @override
  String get createPlantManualEntry => 'Entrer manuellement';

  @override
  String get createPlantStep2Title =>
      'Quand as-tu arrosé pour la dernière fois ?';

  @override
  String get createPlantStep2Subtitle =>
      'Optionnel – nous te rappellerons au bon moment.';

  @override
  String get createPlantWateringIntervalLabel => 'Fréquence d\'arrosage';

  @override
  String get createPlantLastWateredLabel => 'Dernier arrosage';

  @override
  String get createPlantNotYetWatered => 'Pas encore sélectionné';

  @override
  String get createPlantPickDate => 'Choisir une date';

  @override
  String get createPlantClearDate => 'Supprimer';

  @override
  String get createPlantDaysUnit => 'jours';

  @override
  String get createPlantStep3Title => 'Fertilises-tu ta plante ?';

  @override
  String get createPlantStep3Subtitle =>
      'Optionnel – si tu fertilises, on peut te le rappeler.';

  @override
  String get createPlantFertilizingToggle => 'Fertiliser la plante';

  @override
  String get createPlantFertilizingIntervalLabel =>
      'Fréquence de fertilisation';

  @override
  String get createPlantLastFertilizedLabel => 'Dernière fertilisation';

  @override
  String get createPlantWeeksUnit => 'semaines';

  @override
  String get createPlantStep4Title => 'Où se trouve ta plante ?';

  @override
  String get createPlantStep4Subtitle =>
      'Choisis un emplacement ou crées-en un d\'abord.';

  @override
  String get createPlantNoLocations =>
      'Aucun emplacement.\nCrée d\'abord un emplacement.';

  @override
  String get createPlantStep5Title => 'Autre chose ?';

  @override
  String get createPlantStep5Subtitle =>
      'Ajoute optionnellement une photo et des notes.';

  @override
  String get createPlantPhotoLabel => 'Ajouter une photo';

  @override
  String get createPlantPhotoChange => 'Changer la photo';

  @override
  String get createPlantNotesHint => 'Notes (optionnel) …';

  @override
  String get createPlantSaveButton => 'Ajouter la plante';

  @override
  String get createPlantToastName => 'Donne un nom à ta plante.';

  @override
  String get createPlantToastLocation => 'Choisis un emplacement.';

  @override
  String get weatherSettingsTitle => 'Localisation météo';

  @override
  String get weatherSettingsDynamic => 'GPS (dynamique)';

  @override
  String get weatherSettingsStatic => 'Lieu fixe';

  @override
  String get weatherSettingsDynamicSubtitle =>
      'La météo est chargée selon ta position GPS actuelle.';

  @override
  String get weatherSettingsStaticSubtitle =>
      'La météo est chargée pour un lieu fixe.';

  @override
  String get weatherSettingsPickOnMap => 'Choisir sur la carte';

  @override
  String get weatherSettingsNoLocationSet => 'Aucun lieu sélectionné';

  @override
  String get mapPickerTitle => 'Choisir un lieu';

  @override
  String get mapPickerConfirm => 'Utiliser ce lieu';

  @override
  String get mapPickerSearching => 'Recherche du lieu …';

  @override
  String get noLocation => 'Sans emplacement';

  @override
  String get noLocationHint => 'Sans emplacement';

  @override
  String get unknownLocation => 'Inconnu';

  @override
  String errorPrefix(String message) {
    return 'Erreur : $message';
  }

  @override
  String get tabChat => 'Planty';

  @override
  String get chatTitle => 'Assistant Plantes';

  @override
  String get chatPlaceholder => 'Pose-moi une question sur tes plantes …';

  @override
  String get chatEmptyTitle => 'Assistant Plantes';

  @override
  String get chatEmptySubtitle =>
      'Demande-moi tout sur les soins, le diagnostic ou l\'identification des plantes. Tu peux aussi joindre des photos.';

  @override
  String get chatAddImage => 'Ajouter une image';

  @override
  String get chatErrorMessage => 'Oups, une erreur s\'est produite. Réessaie.';

  @override
  String get settingsSeasonalReminders => 'Rappels saisonniers';

  @override
  String get settingsSeasonalSubtitle =>
      'Conseils lors des changements de saison (hiver/été)';

  @override
  String get settingsAiChat => 'Chat IA';

  @override
  String get settingsAiChatSubtitle => 'Assistant plantes via Claude AI';

  @override
  String get plantDetailCareTab => 'Conseils';

  @override
  String get plantDetailCareLoading => 'Chargement des conseils …';

  @override
  String get plantDetailCareError => 'Données non disponibles';

  @override
  String get plantDetailCareDescription => 'Description';

  @override
  String get plantDetailCareSunlight => 'Lumière';

  @override
  String get plantDetailCareMaintenance => 'Entretien';

  @override
  String get plantDetailCarePruning => 'Période de taille';

  @override
  String get locationRecommendationsTitle => 'Plantes recommandées';

  @override
  String get locationRecommendationsSubtitle =>
      'Ces types de plantes prospèrent particulièrement bien à cet emplacement.';
}
