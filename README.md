# PlantCare

A Flutter iOS app for managing your plants, tracking watering and fertilizing schedules, and getting AI-powered plant care advice.

## Features

- **Home screen** – daily overview of plants that need watering or fertilizing, with weather integration
- **Plant management** – add, edit, and delete plants; photo gallery; care interval tracking
- **Location management** – organise plants by location (window sill, balcony, …); plant recommendations per location
- **AI Plant Assistant** – chat with Claude AI to get care tips, diagnose problems, and identify plants (supports images)
- **Smart notifications** – daily watering reminders and seasonal care alerts (winter / summer transition)
- **Perenual care tips** – automatically loads detailed care info for known plant species
- **Calendar integration** – watering events sync to Apple Calendar
- **Localisation** – German, English, French

## Getting started

### Prerequisites

- Flutter 3.x
- Xcode 15+ (for iOS builds)
- A [Perenual](https://perenual.com) API key (free tier)
- An [Anthropic](https://console.anthropic.com) API key (for the AI chat tab)

### Setup

1. Clone the repository and install dependencies:
   ```bash
   flutter pub get
   ```

2. Copy the secrets template and fill in your keys:
   ```bash
   cp secrets.example.json secrets.json
   ```
   Then edit `secrets.json`:
   ```json
   {
     "PERENUAL_API_KEY": "your_perenual_key",
     "ANTHROPIC_API_KEY": "your_anthropic_key"
   }
   ```

3. Run on a connected device or simulator:
   ```bash
   flutter run --dart-define-from-file=secrets.json
   ```

The VS Code launch configurations in `.vscode/launch.json` already pass `--dart-define-from-file=secrets.json`.

## Architecture

```
lib/
├── core/            # Shared services (notifications, weather, Perenual, …)
├── data/            # Hive models & repositories
├── features/
│   ├── home/        # Today overview + weather
│   ├── plants/      # Plant CRUD + detail + Perenual care tips
│   ├── locations/   # Location CRUD + plant recommendations
│   ├── chat/        # Claude AI chat tab
│   └── settings/    # Theme, language, notifications, seasonal reminders
├── l10n/            # Localisation (de, en, fr)
└── shared/          # Reusable widgets
```

State management: **Riverpod** (`AsyncNotifier` pattern)  
Local persistence: **Hive**  
UI: **Cupertino** (iOS-native look)

## Secrets

`secrets.json` is git-ignored and must never be committed.  
See `secrets.example.json` for the required keys.
