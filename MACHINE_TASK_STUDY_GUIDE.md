# Smart Access & Location Security — Machine Task Study Guide

App name in code: `smart_access_security`  
Package version: `1.0.0+1`  
Flutter SDK: Dart `^3.10.7` (Flutter 3.38 or newer)

This file is a study sheet for the machine task: what the app is, how it is built, every important package / screen / widget / controller, and interview questions with answers taken from this codebase.

---

## 1. What this task is

**Smart Access & Location Security** is an offline Flutter app for Android and iOS.

It combines two ideas:

1. **App lock** — a 6-digit PIN, optional fingerprint / face unlock, wrong-PIN lockouts, and auto-lock when the app goes to the background or the user is idle.
2. **Location security** — live map, tracking sessions, circular geofences, and a dashboard that shows the security status of the device.

There is **no backend and no REST API**. Everything lives on the device.

The only network use is:

- downloading **OpenStreetMap tiles** for the map
- the platform **reverse geocoder** (street address)

If the phone is offline, PIN, tracking history, geofences, and settings still work. New map tiles and addresses may not.

### What a user can do

| Area | What it does |
|---|---|
| App lock | First launch sets a 6-digit PIN. Later unlocks use biometrics if enabled, with PIN as fallback. Wrong PINs are throttled. The app locks after background time or inactivity. |
| Location | Explains why location is needed before the system dialog. Shows latitude, longitude, accuracy (good / fair / poor), address, and a map with refresh and recenter. |
| Tracking | Start / stop a session. Draws a live polyline. Shows distance, speed, duration. Continues in the background. Warns if the location looks mocked. |
| History | Saved sessions, a detail screen with the route, export to CSV or JSON, clear history. |
| Geofencing | Create by tapping or long-pressing the map. Name and radius from 50 m to 2000 m. Edit, delete. Entry and exit notifications. |
| Dashboard | Cards for biometrics, permission, GPS, current location, tracking, geofences, and last authentication. |
| Settings | Theme, auto-lock duration, biometric toggle, change PIN, screenshot protection, clear data. |

### Routes

```
/setup-pin                 first launch (no PIN yet)
/lock                      whenever the app is locked
/location-permission       explanation before the system dialog
/dashboard                 home tab
/map                       live map tab
/tracking                  live tracking tab
  /tracking/history
  /tracking/history/:id
/geofences                 list tab
  /geofences/new
  /geofences/:id/edit
/settings
  /settings/change-pin
```

The five main tabs (Dashboard, Map, Tracking, Geofences, Settings) sit inside a `StatefulShellRoute.indexedStack`, so each tab keeps its own navigation stack.

---

## 2. Architecture (how to explain it)

**Feature-based Clean Architecture.**

Each feature has three layers. Dependencies only point inwards:

```
presentation  →  domain  ←  data
```

- **Presentation** may call domain. It must not call plugins directly.
- **Data** implements domain interfaces (Hive, Geolocator, secure storage).
- **Domain** is plain Dart: entities, repository interfaces, and pure rules. No Flutter widgets, no plugins. This is why the important rules can be unit tested without a device.

```
lib/
  main.dart, bootstrap.dart, app.dart
  core/
    constants/   errors/   utils/     shared values, Failure types, formatters, clock
    storage/                            Hive JSON store, secure store
    router/                             GoRouter, lock redirect, app shell
    notifications/  security/           local notifications, screenshot protection
    theme/  widgets/                    Material 3 theme, reusable widgets
  features/
    auth/  location/  tracking/  geofence/  settings/  dashboard/
      domain/         entities, repository interfaces, pure services
      data/           repository implementations
      presentation/   Riverpod controllers, screens, widgets
```

### Startup flow

1. `main()` calls `WidgetsFlutterBinding.ensureInitialized()`, then `bootstrap()`.
2. `bootstrap()` opens Hive boxes, creates the secure store, and checks whether a PIN already exists.
3. On a fresh install it clears leftover keychain data (iOS keeps the keychain after uninstall).
4. `runApp` wraps the app in `ProviderScope` and overrides three providers: Hive boxes, secure store, and `pinConfiguredAtStartup`.
5. `SmartAccessApp` watches theme, auto-lock, geofence monitor, and screenshot protection, then builds `MaterialApp.router`.

Riverpod retry is turned off (`retry: (retryCount, error) => null`). Failures are shown with a "Try again" button instead of silent background retries.

### The five design decisions interviewers care about

**1. One position stream.**  
`PositionStreamService` is the only code that listens to the location plugin. Tracking, geofence monitoring, and the map call `acquire` / `release` and listen to one shared stream. The platform subscription opens for the first consumer and closes after the last. Start and stop requests are queued (`_pending`) so two subscriptions can never be open at once.

**2. Lock is a router guard.**  
`AppLock` holds `needsSetup`, `locked`, or `unlocked`. GoRouter's redirect calls the pure function `resolveLockRedirect`. While locked, every route goes to `/lock` and the original path is kept in a `from` query parameter. After unlock, the user returns to that route.

**3. The PIN is never stored.**  
A PBKDF2-HMAC-SHA256 hash with a random 16-byte salt is stored in the Android Keystore / iOS Keychain through `flutter_secure_storage`. Comparison is constant-time. Biometric data never reaches the app: `local_auth` only reports success or failure.

**4. Geofence state is remembered.**  
Each geofence stores `presence`: `unknown`, `inside`, or `outside`. A notification is sent only when that state flips. A 10 m exit margin stops GPS noise at the boundary from firing enter and exit over and over. Positions worse than 100 m accuracy are ignored.

**5. Storage is JSON in Hive.**  
Hive boxes hold JSON strings from the models' `toJson`. There are no Hive type adapters. The same JSON is used for export.

---

## 3. Packages

### Runtime dependencies

| Package | Why it is here |
|---|---|
| `flutter_riverpod` | State management. Screens `ref.watch` providers. |
| `riverpod_annotation` | Annotations (`@riverpod`, `@Riverpod(keepAlive: true)`) that generate the providers. |
| `go_router` | Declarative routes plus a redirect guard for the lock screen. |
| `local_auth` | System fingerprint / face prompt. The app never sees the biometric data. |
| `flutter_secure_storage` | Keystore / Keychain for the PIN hash and auth status. |
| `cryptography` | PBKDF2-HMAC-SHA256. Pure Dart, no native code. |
| `geolocator` | Current position, position stream, mock detection, foreground service for background tracking. |
| `geocoding` | Reverse geocoding with the platform geocoder. No API key. |
| `permission_handler` | Notification permission. Pinned to 12.x because v13 needs a newer Android Gradle plugin than Flutter 3.38 ships with. |
| `flutter_map` | Map widget. OpenStreetMap tiles, no API key. |
| `latlong2` | `LatLng` type used by the map and layers. |
| `hive_ce` / `hive_ce_flutter` | Local key-value store for settings, geofences, and tracking sessions. Community edition of Hive. |
| `flutter_local_notifications` | Tracking started / stopped, and geofence enter / exit. |
| `path_provider` | App documents directory for export files. |
| `share_plus` | System share sheet for CSV / JSON. |
| `csv` | Builds the CSV export. |
| `no_screenshot` | Blocks screenshots and screen recording when the setting is on. |
| `freezed_annotation` | Immutable models with `copyWith` and equality. |
| `json_annotation` | `fromJson` / `toJson` on those models. |
| `intl` | Date and number formatting. |
| `uuid` | Ids for tracking sessions and geofences. |

### Dev dependencies

| Package | Why |
|---|---|
| `build_runner` | Runs code generation. |
| `riverpod_generator` | Generates `*.g.dart` provider files. |
| `freezed` | Generates `*.freezed.dart`. |
| `json_serializable` | Generates JSON methods. |
| `fake_async` | Fake time for auto-lock and throttle timer tests. |
| `very_good_analysis` | Strict lint rules. |
| `flutter_test` | Widget and unit tests. |

Generated files (`*.g.dart`, `*.freezed.dart`) are committed, so `flutter run` works without a generation step. After you change a provider or a model:

```bash
dart run build_runner build --force-jit
```

`--force-jit` is required because some plugins use native build hooks that build_runner's default ahead-of-time mode does not support.

### Font

`PlusJakartaSans` (Regular, Medium, SemiBold, Bold, ExtraBold) from `assets/fonts/`.

---

## 4. Core pieces

### Constants — `lib/core/constants/app_constants.dart`

| Name | Value | Meaning |
|---|---|---|
| Hive boxes | `settings`, `geofences`, `tracking_sessions` | Three boxes, all `Box<String>` of JSON |
| `StorageKeys` | `app_settings`, `install_marker`, `pin_credential`, `auth_status` | Keys inside Hive and secure storage |
| `GeofenceLimits` | min 50 m, max 2000 m, default 200 m | Radius the editor allows |
| `Breakpoints` | tablet 600, max content width 840 | Responsive layout |
| `kPinLength` | 6 | PIN is always 6 digits |

### Errors — `lib/core/errors/failures.dart`

A `sealed class Failure` with a user-readable `message`:

- `StorageFailure`
- `LocationServiceDisabledFailure` — GPS is off
- `LocationPermissionFailure` — denied, with a `permanent` flag when the system will not show the dialog again
- `LocationUnavailableFailure` — timeout or no signal
- `ExportFailure`

`describeError` turns any error into a sentence. Known failures use their message. Everything else becomes "Something went wrong. Please try again."

### Storage

- `HiveBoxes` opens the three boxes at startup.
- `JsonBoxStore` reads and writes JSON strings. No Hive adapters.
- `SecureStore` / `FlutterSecureStore` wraps `FlutterSecureStorage`.
- `bootstrap` writes an `install_marker`. If that marker is missing (fresh install) it deletes `pin_credential` and `auth_status` from the keychain, because on iOS the keychain survives uninstall.

### Router

- `routes.dart` — path constants.
- `lock_redirect.dart` — `resolveLockRedirect`, a pure function. Easy to unit test.
- `app_router.dart` — builds `GoRouter`, listens to `appLockProvider`, and refreshes the redirect.
- `app_shell.dart` — `AppShell` + `ShellDestination`. Hosts the floating bottom nav and the indexed stack.

Lock redirect rules:

| Lock state | Behaviour |
|---|---|
| `needsSetup` | Everything goes to `/setup-pin`. |
| `locked` | Everything goes to `/lock`. The current path is saved as `?from=` unless it is setup or the dashboard. |
| `unlocked` | `/lock` returns to `from`, or to the dashboard. `/setup-pin` goes to the dashboard. |

### Notifications — `lib/core/notifications/notification_service.dart`

`NotificationChannel`: tracking and geofence.  
`LocalNotificationService` shows them and requests permission.

### Screen protection — `lib/core/security/screen_protection.dart`

`NoScreenshotProtector` applies the settings flag app-wide. Off by default. When on, it covers every screen, including the lock screen.

### Utils

| File | Role |
|---|---|
| `clock.dart` | `clockProvider` returns `DateTime.now`. Tests override it. |
| `distance.dart` | Haversine distance between two lat/lng points, in metres. |
| `formatters.dart` | Distance, duration, coordinates, speed for the UI. |
| `file_sharer.dart` | Writes a file and opens the share sheet. |

### Theme

`AppTheme.light()` and `AppTheme.dark()` are Material 3. `DepthTheme` is a `ThemeExtension` for the soft card shadows used across the UI. Theme mode comes from `SettingsController` (`system`, `light`, `dark`).

---

## 5. Features

### 5.1 Auth

**Goal:** nobody sees the app until they prove it is them, and guessing the PIN gets slower.

#### Domain

| Type | Role |
|---|---|
| `PinCredential` | `hash`, `salt`, `iterations`. Never the raw PIN. |
| `AuthStatus` | `failedAttempts`, `lockedUntil`, `lastSuccessfulAuthAt`. |
| `BiometricStatus` | Hardware available and enrolled, or not. |
| `PinVerification` | `PinAccepted` or a rejection (wrong PIN, lockout). |
| `BiometricResult` | Success, failure, or cancelled. |
| `PinHasher` | Interface: `hash` and `verify`. |
| `PinThrottlePolicy` | Lockout rules. See below. |
| `AuthService` | Set PIN, verify PIN, record success. Uses the hasher, repositories, and the throttle policy. |
| `PinRules` | PIN must be 6 digits. |
| `AutoLockPolicy` | When background time or idle time should lock the app. |
| `AutoLockManager` | Runs the timers that call the policy. |
| Repositories | `PinRepository`, `AuthStatusRepository`, `BiometricRepository` — interfaces only. |

**Throttle numbers (defaults):**

- First 4 wrong PINs: no wait (`freeAttempts` is 5, so lockout starts on the 5th failure).
- From the 5th failure: 30 seconds, then doubles (60 s, 120 s, …) up to 15 minutes.
- A correct PIN resets `failedAttempts` and `lockedUntil`.

**Auto-lock durations in settings:** immediately, 30 seconds, 1 minute, 5 minutes, never.  
"Immediately" only applies when leaving the app. Inside the app the idle timer uses at least 1 minute, so a pause between taps does not lock the user out.

**Hashing (`Pbkdf2PinHasher`):**

- Algorithm: PBKDF2-HMAC-SHA256
- Salt: 16 random bytes from `Random.secure()`
- Key: 256 bits
- Iterations: 50,000
- Stored as base64
- Derived inside `Isolate.run` so the UI does not freeze
- Compared with XOR accumulation so the function does not return early (constant time)

#### Data

| Class | Plugin |
|---|---|
| `PinRepositoryImpl` | Secure storage. Saves and loads `PinCredential`. |
| `AuthStatusRepositoryImpl` | Secure storage. Saves failed-attempt counters. |
| `LocalAuthBiometricRepository` | `local_auth`. |

#### Controllers

| Provider | What it holds |
|---|---|
| `pinConfiguredAtStartupProvider` | `bool`. Overridden in `bootstrap`. Throws if someone forgets the override. |
| `appLockProvider` (`AppLock`) | `needsSetup` if no PIN, otherwise `locked`. `lock()` and `unlock()`. |
| `authServiceProvider` | The `AuthService` instance. |
| `authStatusProvider` | `Future<AuthStatus>`. Invalidated after every PIN check. |
| `biometricStatusProvider` | `Future<BiometricStatus>`. |
| `authControllerProvider` | `AuthController`: `unlockWithPin`, `verifyPin`, `unlockWithBiometrics`, `savePin`, `completeSetup`. |
| `autoLockProvider` | Watched from `SmartAccessApp` so the timer lives for the whole app. Every pointer-down calls `onUserActivity()`. |

`AuthController` is a plain class, not a `Notifier`. Screens call it for actions. Widgets stay free of hashing and storage.

#### Screens and widgets

| Widget | File | Role |
|---|---|---|
| `PinSetupScreen` | `pin_setup_screen.dart` | First launch. Enter PIN, confirm PIN. |
| `LockScreen` | `lock_screen.dart` | Unlock with PIN or biometrics. |
| `ChangePinScreen` | `change_pin_screen.dart` | Steps: current PIN, new PIN, confirm. |
| `PinEntryView` | `pin_entry_view.dart` | Shared PIN entry UI. |
| `PinPad` / `PinPadActionKey` | `pin_pad.dart` | 0–9 keypad. |
| `PinDots` | `pin_dots.dart` | Six dots that fill as digits are typed. |
| `LockoutCountdown` | `lockout_countdown.dart` | Shows remaining lockout time. |
| `StepProgress` | `step_progress.dart` | Step indicator on setup and change-PIN. |

---

### 5.2 Location

**Goal:** one trustworthy position, shared by the map, tracking, and geofences.

#### Domain entities

`LocationFix`: latitude, longitude, accuracy in metres, speed in m/s, timestamp, `isMocked`.

`AccuracyLevel.fromMeters`:

- good: ≤ 10 m
- fair: ≤ 30 m
- poor: anything larger

`LocationPermissionStatus`: how the OS answered the permission request.  
`LocationStatus`: permission + whether GPS is on. `isReady` means both are usable.

#### Domain service

`PositionStreamService` (explained in section 2). Public API:

- `fixes` — broadcast stream
- `lastFix`
- `acquire(consumer, {background})`
- `release(consumer)`
- `restart()` — used when GPS comes back
- `dispose()`

#### Data

| Class | Plugin |
|---|---|
| `GeolocatorLocationRepository` | `geolocator`. Current fix, watch position, permission, GPS on/off, open settings, mock flag. |
| `GeocodingRepositoryImpl` | `geocoding`. `addressFor(lat, lng)` or null. |

#### Controllers — `location_providers.dart` and `location_status_controller.dart`

| Provider | Role |
|---|---|
| `positionStreamServiceProvider` | Keep-alive. Builds the service. If location was not ready and becomes ready, calls `restart()`. |
| `locationStatusControllerProvider` | Keep-alive `AsyncNotifier<LocationStatus>`. Listens to GPS on/off and refreshes when the app resumes (the user may have changed permission in Settings). `requestPermission`, `openLocationSettings`, `openAppSettings`. |
| `currentLocationProvider` | `AsyncNotifier<LocationFix>`. Checks status, then `getCurrentFix()`, and also listens to the shared stream so a live tracking session updates the map. `refresh()` invalidates itself but keeps the old value visible while loading. |
| `addressProvider` | Family provider. Takes rounded lat/lng. |
| `roundForAddress` | Rounds to 4 decimal places (~11 m) so tiny GPS jitter does not trigger a new geocode. |

#### Screens and widgets

| Widget | Role |
|---|---|
| `LocationPermissionScreen` | Explains why location is needed, then requests it. `_Reason` rows. |
| `LocationGate` | If permission or GPS is missing, shows that screen's empty/error state instead of the map. |
| `MapScreen` | Current position, details card, geofence circles, optional past routes. |
| `PastRoutesVisible` | Small notifier, default `false`. The timeline button toggles it. |
| `_LocationMap` | Private widget that builds `AppMap` for one fix. Refresh and recenter. |
| `LocationDetailsCard` | Lat, lng, accuracy chip, address. |
| `AccuracyChip` | Good / fair / poor. |
| `MockLocationBanner` | Shown when `isMocked` is true (Android). |

---

### 5.3 Tracking

**Goal:** record a route without opening a second GPS subscription.

#### Domain

`TrackPoint`: lat, lng, accuracy, speed, timestamp.  
`TrackingSession`: id, startedAt, endedAt, points, distanceMeters, maxSpeed, hadMockedLocation.

`TrackingCalculator` rules:

- Ignore a point if accuracy is worse than **50 m**.
- Ignore a point if it moved less than **2 m** (GPS jitter).
- First good point always starts the route.
- Distance is the sum of segment lengths.
- Speed is the device speed when it is positive; otherwise computed from the previous point (metres / seconds).
- `hadMockedLocation` is set even when the point is too inaccurate to draw.

#### Controllers

| Provider | Role |
|---|---|
| `trackingCalculatorProvider` | Keep-alive calculator using the shared distance function. |
| `trackingControllerProvider` | Keep-alive. Survives tab changes, lock screen, and background. |
| `trackingHistoryProvider` | `AsyncNotifier<List<TrackingSession>>`. |
| `historyExportControllerProvider` | Builds CSV or JSON and shares the file. |

`TrackingController` flow:

1. `start()` creates a session with a UUID, saves it, acquires the position stream with `background: true`, shows a notification.
2. Each fix goes through `TrackingCalculator.addFix`.
3. The session is autosaved every **10** new points, so a kill loses little.
4. `stop()` releases the stream, sets `endedAt`, saves, invalidates history, shows distance and duration.
5. On startup, `_finishInterruptedSessions` closes sessions that were still open when the app died.

`TrackingState` (freezed): `session`, `currentSpeed`, `lastFix`, `isStarting`. `isTracking` is `session != null`.

#### Screens and widgets

| Widget | Role |
|---|---|
| `TrackingScreen` / `_TrackingView` | Live map polyline and start / stop. |
| `_ControlPanel` | Start and stop buttons, stats. |
| `SessionStats` | Distance, speed, duration. |
| `ElapsedText` | Live timer while a session runs. |
| `TrackingHistoryScreen` | List of saved sessions. |
| `SessionListTile` | One row in that list. |
| `SessionDetailScreen` | Route map plus summary for one id. |
| `HistoryActions` | Export CSV, export JSON, clear history. |

`SessionExporter` turns sessions into CSV or JSON. `FileSharer` writes the file and opens the share sheet.

---

### 5.4 Geofence

**Goal:** tell the user when they enter or leave a named circle, without duplicate notifications.

#### Domain

`Geofence`: id, name, latitude, longitude, radiusMeters, createdAt, presence.  
`GeofencePresence`: `unknown`, `inside`, `outside`.  
`GeofenceEvaluator` (see section 2):

- Skip the fix if accuracy > **100 m**.
- Distance to centre uses the same Haversine function as tracking.
- If the user was already inside, they must travel `radius + 10 m` before they count as outside.
- First time the user is found inside counts as **enter**. First time they are found outside does **not** notify (that is not news).
- Exit notifies only when the previous state was `inside`.

#### Controllers

| Provider | Role |
|---|---|
| `geofenceEvaluatorProvider` | Keep-alive evaluator. |
| `geofenceListControllerProvider` | Keep-alive list. Load, create, update, delete, `applyPresence`. |
| `geofenceMonitorProvider` | Keep-alive. Watched once from `SmartAccessApp`. |

`geofenceMonitor` acquires the shared position stream only when there is at least one geofence **and** location is ready. On each fix it evaluates, saves presence if it changed, and sends a notification for each transition. It never calls Geolocator itself.

#### Screens and widgets

| Widget | Role |
|---|---|
| `GeofenceListScreen` | Overview, small map, list. |
| `GeofenceListTile` | One geofence row. |
| `GeofenceEditorScreen` / `_GeofenceForm` | Create or edit. Tap or long-press the map to place the centre. Radius slider 50–2000 m. |
| `_MapHint` | Hint text on the editor map. |
| `GeofenceLayer` | Draws circles (`GeofenceCircle`: center, radius, optional label). |
| `GeofenceActions` | Edit / delete actions. |
| `geofence_labels.dart` | User-facing strings. |

---

### 5.5 Dashboard

Read-only summary. It does not own business rules. It watches the same providers the other features use.

| Widget | Shows |
|---|---|
| `DashboardScreen` | Scrollable groups of cards. Responsive width. |
| `SecurityOverviewCard` | High-level security pills. |
| `BiometricCard` | Whether biometrics can be used. |
| `LastAuthCard` | Time of the last successful unlock. |
| `LocationPermissionCard` | Permission state. |
| `GpsCard` | GPS on or off. |
| `CurrentLocationCard` | Latest coordinates. |
| `TrackingCard` | Idle or recording. |
| `GeofenceCard` | How many geofences exist. |
| `Auth cards` | In `auth_cards.dart`. |
| `Location cards` | In `location_cards.dart`. |

---

### 5.6 Settings

`AppSettings` (freezed, JSON):

| Field | Default |
|---|---|
| `themeMode` | system |
| `autoLockDuration` | 1 minute |
| `biometricsEnabled` | false |
| `screenshotProtection` | false |

`SettingsController` loads settings from Hive and writes every change immediately (`setThemeMode`, `setAutoLockDuration`, `setBiometricsEnabled`, `setScreenshotProtection`).

| Widget | Role |
|---|---|
| `SettingsScreen` | Composes the three sections. |
| `AppearanceSection` | Theme. |
| `SecuritySection` | Auto-lock, change PIN, screenshot protection. |
| `_BiometricTile` | Toggle, only if the device can do biometrics. |
| `DataSection` | Clear tracking history and geofences. |

---

## 6. Shared widgets

These live in `lib/core/widgets` and are reused by every feature.

| Widget | Role |
|---|---|
| `AsyncValueView` | One widget for Riverpod `AsyncValue`: loading, error with retry, empty, and data. Every screen uses this so states look the same. |
| `LoadingView` | Spinner. |
| `MessageView` | Icon + title + body. |
| `EmptyView` | Nothing here yet. |
| `ErrorView` | Failure message and a try-again action. |
| `AppMap` | `flutter_map` with OSM tiles. |
| `PositionLayer` | Current-location marker. |
| `RouteLayer` | Polyline for a tracking route. |
| `PinLayer` | A dropped pin (geofence centre). |
| `FloatingNavBar` / `FloatingNavItem` / `_NavItem` | Bottom navigation. |
| `StatusCard` | Card with a tone: neutral, good, warning, bad. |
| `StatusCardTheme` | Inherited widget so nested cards share the tone. |
| `StatusPill` | Small coloured label. |
| `SoftSurface` | Card with the depth shadow from `DepthTheme`. |
| `SoftPressable` | Press animation on a soft surface. |
| `SoftIconWell` | Icon sitting in a soft circle. |
| `SoftPanel` / `SectionCard` / `SectionHeader` | Section layout. |
| `InsetPanel` | Nested inset surface. |
| `RoundIconButton` | Circular icon button (refresh, recenter). |
| `CapsLabel` | Small uppercase label. |
| `SoftSegmented` | Segmented control (theme, auto-lock). |
| `StatTile` / `StatRow` | Number + label, used for distance and speed. |
| `ElapsedText` | Ticking duration. |
| `ConfirmDialog` | "Are you sure?" before delete / clear. |
| `Responsive` | Constrains width on tablet (`Breakpoints`). |

`AppShell` is the scaffold that hosts `FloatingNavBar` and the active branch.

---

## 7. State management cheat sheet

The app uses **Riverpod with code generation**, not `Provider`, `Bloc`, `GetX`, or `setState` for app state.

Two annotations:

- `@riverpod` — the provider can be disposed when nobody watches it.
- `@Riverpod(keepAlive: true)` — lives for the whole app run.

Keep-alive is used for things that must not reset when you change tabs:

- app lock, auth service, auto-lock
- position stream, location status
- tracking controller and calculator
- geofence list, evaluator, and monitor
- settings, Hive, secure store, router, notifications, screen protection

Screens are `ConsumerWidget` or `ConsumerStatefulWidget`.

- `ref.watch` — rebuild when this value changes.
- `ref.read` — call an action once (a button). Do not watch inside a callback.
- `ref.listen` — side effect when a value changes (router lock state, GPS coming back).
- `ref.invalidate` — drop cached data so the next read loads again (`authStatus`, tracking history).
- `select` — watch one field so the widget does not rebuild for unrelated changes. The root app watches only `settings.themeMode`.

`AsyncValue` states you should be able to name: `AsyncLoading`, `AsyncData`, `AsyncError`. `AsyncValue.guard` wraps a future so a throw becomes `AsyncError` instead of a crash. `currentLocation.refresh` uses `invalidateSelf` and then awaits `future`.

---

## 8. Data model and persistence

| Data | Where | Format |
|---|---|---|
| PIN hash + salt + iterations | Secure storage (`pin_credential`) | JSON of `PinCredential` |
| Failed attempts, lockout, last auth | Secure storage (`auth_status`) | JSON of `AuthStatus` |
| Theme, auto-lock, biometric toggle, screenshot flag | Hive `settings` box | JSON of `AppSettings` |
| Geofences | Hive `geofences` box | JSON of `Geofence`, including presence |
| Tracking sessions | Hive `tracking_sessions` box | JSON of `TrackingSession` |
| Install marker | Hive `settings` box | The string `"installed"` |

Nothing is sent to a server. Export writes a local file and hands it to the share sheet. The user chooses where it goes.

---

## 9. Tests (what you can say you covered)

`flutter test` runs about **132 tests**:

- repositories with a real Hive box in a temp directory (settings, PIN, sessions, geofences)
- geofence enter / exit and the monitor
- distance and speed
- auto-lock policy and timers with `fake_async`
- PIN throttle, PIN rules, lock redirect
- the single position subscription under rapid acquire / release
- CSV and JSON export
- widgets: lock screen (PIN, biometric success, cancel, lockout) and the dashboard on a phone and a tablet

Domain tests do not need Flutter. That is the point of keeping rules in plain Dart.

---

## 10. Known limitations (say these before the interviewer does)

- Map tiles need internet. Already viewed tiles are cached by `flutter_map`. New areas do not load offline.
- Addresses usually need internet. Offline, the UI shows that the address is not available.
- Geofences are checked only while the app has positions: app open, or background **during a tracking session**. There are no OS-level geofences. A killed app will not wake up to notify.
- iOS background tracking uses "While Using" and the blue status bar. iOS can pause updates when the phone is still, and stops them if the user force-quits.
- Some Android phones still kill the foreground service under battery optimisation.
- Mock-location detection is Android only. iOS does not expose it.
- Screenshot protection is app-wide, including the lock screen. Off by default.
- A forgotten PIN cannot be recovered. There is no account. Reinstalling wipes local data (and the bootstrap step clears a leftover iOS keychain PIN).
- The project was built on Windows. iOS config is in the repo but was not run on a Mac.
- Auto-lock "Immediately" applies when leaving the app. Idle time inside the app uses a one-minute minimum.

---

## 11. Interview questions and answers

Short answers first. Expand only if they ask "why".

### About the task

**Q: What did you build?**  
An offline Flutter app that locks itself with a PIN and biometrics, and adds location features: a live map, route tracking, geofences, and a security dashboard. No backend. Data stays on the device in Hive and the platform keystore.

**Q: Why no backend?**  
The spec is device security and location, not accounts. A backend would mean network, auth tokens, and a server to protect. Local storage matches the threat model: the secret is the PIN on this phone.

**Q: What is Clean Architecture in this project?**  
Three layers per feature. Domain holds entities and rules and knows nothing about Flutter. Data implements repositories with plugins. Presentation is Riverpod plus widgets. The arrow is presentation → domain ← data, so you can swap Geolocator or Hive without touching a screen, and you can test the rules without a device.

**Q: Walk me through app start.**  
`main` ensures bindings, `bootstrap` opens Hive and secure storage, checks for an existing PIN, and returns provider overrides. `ProviderScope` receives those overrides. `AppLock` starts as `needsSetup` or `locked`. GoRouter redirects. `SmartAccessApp` also starts auto-lock, the geofence monitor, and screenshot protection.

### Auth

**Q: Where is the PIN stored?**  
It is not stored. We store a PBKDF2-HMAC-SHA256 hash, a 16-byte salt, and the iteration count (50,000) in `flutter_secure_storage`, which uses the Android Keystore and the iOS Keychain.

**Q: Why PBKDF2 and not SHA-256 of the PIN?**  
A 6-digit PIN has only one million values. A fast hash can be brute-forced. PBKDF2 repeats HMAC-SHA256 50,000 times, so each guess is slow. The random salt means two users with the same PIN do not get the same hash, and a precomputed table does not work.

**Q: Why an isolate?**  
50,000 iterations would hitch the UI if they ran on the main isolate. `Isolate.run` does the derivation in the background.

**Q: What is constant-time comparison?**  
If you return as soon as one byte differs, an attacker can measure how long the check took and learn how many leading bytes matched. We XOR every byte into one accumulator and check it once at the end.

**Q: How does the lockout work?**  
`PinThrottlePolicy`. Attempts 1–4 are free. The 5th wrong PIN locks for 30 seconds. Each further failure doubles the wait, capped at 15 minutes. A correct PIN clears the counter. The UI shows `LockoutCountdown` and the keypad does nothing until the time is up.

**Q: How do biometrics work? Do you store the fingerprint?**  
No. `local_auth` shows the system prompt and returns success or failure. The fingerprint or face stays in the OS. Biometrics are off until the user turns them on in settings, and the PIN still works as fallback. A successful biometric unlock calls `recordSuccess`, which also clears the PIN failure counter.

**Q: How does the lock screen stay in front of every route?**  
`AppLock` is the source of truth. GoRouter's `redirect` calls `resolveLockRedirect`. A `ValueNotifier` is updated whenever the lock state changes, and that notifier is the router's `refreshListenable`, so the redirect runs again on lock and unlock. The previous path is stored in `?from=` and restored after unlock.

**Q: Why is the redirect a separate function?**  
It is pure: lock state in, path in, path or null out. The unit test does not need a widget or a router.

**Q: What is auto-lock?**  
`AutoLockPolicy` plus `AutoLockManager`. If the app stays in the background longer than the setting (immediately, 30 s, 1 min, 5 min, or never), it locks. Inside the app, a pointer listener on the root calls `onUserActivity` and resets an idle timer. "Immediately" is treated as at least one minute of idle time, because locking between taps would be unusable.

**Q: What happens if the user reinstalls on iOS?**  
The keychain can survive uninstall, so the old PIN would still be there with no Hive data. `bootstrap` looks for `install_marker` in the settings box. If it is missing, it deletes the PIN credential and auth status, then writes the marker.

**Q: Can the user recover a forgotten PIN?**  
No. There is no account and no reset email. Reinstalling the app is the reset, and it deletes local data.

### Location and the map

**Q: Why is there only one position stream?**  
Each `getPositionStream` is a platform subscription. Two of them waste battery and can fight over the foreground service. `PositionStreamService` reference-counts consumers. The first `acquire` opens the stream. The last `release` closes it. Tracking asks for `background: true`. The map and geofence monitor ask for foreground. If any consumer needs background, the platform stream is opened in background mode.

**Q: How do you stop two subscriptions opening at once?**  
`_sync` chains onto `_pending`. Each start/stop waits for the previous one to finish, including the `cancel()` of the old subscription, before opening a new one.

**Q: What is `acquire`'s `consumer` argument?**  
An identity token (`this` for the tracking controller, a private `Object()` for the geofence monitor). The map of tokens to "needs background" is how the service knows who is still listening. Calling `acquire` again for the same object only updates the background flag.

**Q: How does the map get updates while tracking?**  
`CurrentLocation` calls `getCurrentFix()` once, then listens to `positionStreamService.fixes`. When tracking has acquired the stream, those events update `state` to `AsyncData(fix)`. The map does not open its own stream.

**Q: What happens when the user turns GPS off and on?**  
`LocationStatusController` listens to `watchServiceEnabled`. The position service watches `isReady`. When it goes from false to true, it calls `restart()` so waiting consumers get positions again.

**Q: Why refresh location status on app resume?**  
Permission changes made in the system Settings app do not emit an in-app stream. `AppLifecycleListener.onResume` calls `refresh()`.

**Q: What do good, fair, and poor mean?**  
From the accuracy radius: ≤ 10 m good, ≤ 30 m fair, otherwise poor. This is display only. Tracking and geofences use stricter cutoffs (50 m and 100 m).

**Q: Why round coordinates before geocoding?**  
`roundForAddress` keeps four decimal places, about 11 metres. GPS jitters by less than that all the time. Without rounding, every tiny movement would call the geocoder again.

**Q: What map library, and why not Google Maps?**  
`flutter_map` with OpenStreetMap tiles. No API key, no billing account, works with the offline-first brief. The cost is that tiles need a network the first time you view an area.

**Q: What is mock location?**  
On Android, Geolocator can tell that a position came from a mock-location app. We flag the fix, show `MockLocationBanner`, and store `hadMockedLocation` on the session even if that point was too inaccurate to draw. iOS does not expose this.

### Tracking

**Q: How is distance calculated?**  
Haversine in `distance.dart`: great-circle distance from two latitudes and longitudes, in metres. `TrackingCalculator.totalDistance` sums the segments. The running session adds only the new segment, so it does not recompute the whole route every time.

**Q: Why drop points closer than 2 m or worse than 50 m?**  
Standing still, GPS wanders. Adding those points makes the route a scribble and inflates the distance. A point worse than 50 m could jump the line across a street. The mock flag is still recorded.

**Q: How does background tracking work?**  
`acquire(this, background: true)` tells the repository to use Geolocator's foreground service (Android notification) so the process is less likely to be killed. The controller itself is `keepAlive`, so leaving the Tracking tab does not stop the session. A notification says tracking started, and another says it stopped, with distance and duration.

**Q: What if the app is killed mid-session?**  
The session is saved at start and every 10 points. On the next launch, interrupted sessions are finished so history does not show a session that never ended.

**Q: How does export work?**  
`SessionExporter` builds CSV (`csv` package) or JSON (the same `toJson` Hive already stores). `FileSharer` writes it with `path_provider` and opens `share_plus`.

### Geofence

**Q: How do you detect enter and exit?**  
`GeofenceEvaluator` compares distance-to-centre with the radius. Each geofence remembers `presence`. A notification is sent only when presence flips. Staying inside does not notify again.

**Q: Why a 10 m exit margin?**  
GPS noise at the boundary would flip inside/outside every few seconds. Once inside, the user must go 10 m past the radius before they count as outside. Entering uses the real radius.

**Q: Why ignore the first "outside"?**  
A new geofence starts as `unknown`. Finding the user outside is the normal case and is not an exit. Finding them inside on the first good fix counts as an entry.

**Q: Why ignore fixes worse than 100 m?**  
A 100 m error can put the user on the wrong side of a 50 m fence. Those fixes are skipped and presence is left unchanged.

**Q: When does monitoring actually run?**  
`SmartAccessApp` watches `geofenceMonitorProvider` for the whole app lifetime. The monitor acquires the shared stream only if the list is non-empty and location is ready. It does not use Android geofencing APIs, so a killed app will not wake up for a crossing. During a tracking session the stream is already running in the background, so crossings are still detected then.

**Q: How does the user create a fence?**  
`GeofenceEditorScreen`. Tap or long-press the map to set the centre, set a name, set a radius between 50 and 2000 m (default 200). Saved through `GeofenceListController` into the Hive box.

### State, UI, and code quality

**Q: Why Riverpod instead of setState or Bloc?**  
Several features share one location stream, one lock state, and one settings object. Riverpod gives compile-time-checked providers, `keepAlive` for process-long services, and `AsyncValue` for loading and error. Code generation (`riverpod_generator`) removes hand-written provider boilerplate and catches wrong types at build time.

**Q: What is `keepAlive`?**  
By default a provider is disposed when the last listener goes away. Tracking would stop when you open Settings. `keepAlive` keeps lock, tracking, the position service, and the geofence monitor alive until the app process dies.

**Q: What is `AsyncValueView`?**  
A single widget that renders loading, error, empty, and data. Screens pass their `AsyncValue` in. Error UI and retry look the same everywhere.

**Q: Why `freezed`?**  
Entities are immutable and have value equality and `copyWith`. Updating a session or a geofence is `copyWith(...)`, not mutating a field. JSON generation comes from `json_serializable` on the same class.

**Q: How is the UI structured?**  
Material 3, Plus Jakarta Sans, a `DepthTheme` extension for soft shadows. Shared widgets (`SoftSurface`, `StatusCard`, `FloatingNavBar`) keep the five tabs visually consistent. `Breakpoints.tablet` is 600 px; content is capped at 840 px. Dashboard widget tests cover a phone and a tablet.

**Q: How do you handle errors?**  
Expected errors are `Failure` subclasses with a message. Repositories throw those. Providers surface them as `AsyncError`. `describeError` picks the message. The root `ProviderScope` does not auto-retry.

### Testing and tradeoffs

**Q: What did you test, and what did you not?**  
Unit tests cover the rules: throttle, auto-lock with fake time, geofence transitions, distance, the lock redirect, rapid acquire/release, and export. Repository tests use a real Hive box in a temp folder. Widget tests cover the lock screen and the dashboard. Full GPS and Face ID need a device, so those paths are covered at the repository interface with fakes, not on hardware in CI.

**Q: What would you change with more time?**  
OS-level geofences so a killed app can still notify. A tested iOS build on a real device. Clearer handling of Android battery optimisation. Optional offline tile cache for a chosen area.

**Q: What is a bug you would look for in review?**  
A second Geolocator subscription, a PIN written in plaintext, a geofence that notifies on every GPS tick, or a tracking controller that is not keep-alive and dies when the user changes tabs.

---

## 12. One-minute spoken summary

> I built an offline Flutter app called Smart Access and Location Security. It locks with a 6-digit PIN stored only as a PBKDF2 hash in the keystore, with optional biometrics and a lockout that doubles after five wrong tries. The lock is a GoRouter redirect, so every screen is covered. Location goes through one shared position stream that tracking, the map, and geofences acquire and release, so we never open two GPS subscriptions. Tracking records a route, drops jitter under 2 metres, and keeps running in the background. Geofences are circles from 50 to 2000 metres, and they notify only when the user actually crosses the edge, with a 10 metre exit margin so GPS noise does not spam. State is Riverpod with code generation, storage is JSON in Hive, and the domain rules are plain Dart with about 132 tests. There is no backend.

---

## 13. File map (where to point during a demo)

| If they ask about… | Open |
|---|---|
| App start | `lib/main.dart`, `lib/bootstrap.dart`, `lib/app.dart` |
| Routes and lock guard | `lib/core/router/app_router.dart`, `lib/core/router/lock_redirect.dart` |
| PIN hash | `lib/features/auth/data/pbkdf2_pin_hasher.dart` |
| Lockout rules | `lib/features/auth/domain/services/pin_throttle_policy.dart` |
| Lock state | `lib/features/auth/presentation/controllers/app_lock_controller.dart` |
| Auth actions | `lib/features/auth/presentation/controllers/auth_controller.dart` |
| One GPS stream | `lib/features/location/domain/services/position_stream_service.dart` |
| Current location | `lib/features/location/presentation/controllers/location_providers.dart` |
| Permission and GPS | `lib/features/location/presentation/controllers/location_status_controller.dart` |
| Map UI | `lib/features/location/presentation/screens/map_screen.dart` |
| Distance and speed | `lib/features/tracking/domain/services/tracking_calculator.dart` |
| Start / stop tracking | `lib/features/tracking/presentation/controllers/tracking_controller.dart` |
| Enter / exit | `lib/features/geofence/domain/services/geofence_evaluator.dart` |
| Live monitoring | `lib/features/geofence/presentation/controllers/geofence_monitor.dart` |
| Settings | `lib/features/settings/presentation/controllers/settings_controller.dart` |
| Shared loading / error UI | `lib/core/widgets/async_value_view.dart` |
| Packages | `pubspec.yaml` |
| Longer write-up | `README.md` |
