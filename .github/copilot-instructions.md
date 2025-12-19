# Mysys Flutter Codebase AI Guidelines

## Project Overview
**Mysys** is a multi-platform Flutter business application (mobile/tablet/desktop for Android, iOS, Web, Windows, Linux, macOS) featuring a sales/logistics management system with localization support (English/Arabic), theme switching, and responsive layouts.

## Architecture & Key Patterns

### Responsive Layout System (`lib/responsive/`)
The app uses **LayoutBuilder-based adaptive UI** with three breakpoints managed by `ResponsiveLayout`:
- **Mobile**: width < 500px → `mobile_scaffold.dart`
- **Tablet**: 500px ≤ width < 1100px → `tablet_scaffold.dart`
- **Desktop**: width ≥ 1100px → `desktop_scaffold.dart`

Desktop layout uses a **3-column design**: side menu (flex:2) + content area (flex:8) + info panel (flex:2). Page switching is index-based via `selectedPageGlobal` global variable.

### State Management
Uses **Provider pattern** with `ChangeNotifierProvider`:
- `ThemeProvider` (`lib/models/theme_provider.dart`) manages light/dark mode toggle
- Global state stored in `lib/data/myappsettings.dart`: screen dimensions, selected page index, theme provider reference
- **Global variables** are used for cross-scaffold communication (not ideal, but current pattern - avoid adding more)

### Localization (i18n)
- **ARB files**: `lib/l10n/app_*.arb` (English/Arabic)
- **Generated classes**: `app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_ar.dart`
- Access via: `AppLocalizations.of(context)!.propertyName`
- Configured in `main.dart` with `localizationsDelegates` and `supportedLocales`
- **Always use localization strings** instead of hardcoded text (except for debugging)

### Pages & Navigation
10 pages in `lib/pages/`: customers, invoices, mysafe, mysettings, neworder, qoute, returninvoice, synchronize, visit, warehouse
- Navigation is **index-based**: `selectedPageGlobal` determines which page Builder returns
- No named routes or route stacks; to add navigation, increment/set `selectedPageGlobal` and call `setState()`

### UI Components
Reusable widgets in `lib/models/`:
- `SideMenuWidget`: Navigation menu with colored tile icons
- `ButtonSection`, `ImageSection`, `TitleSection`, `TextField`, `TextSection`: Layout building blocks
- `MainMenu`: Defines colors, icons, and menu items configuration
- Page switching via callback: `onPageChanged?.call()` in menu widget

## Developer Workflow

### Build & Run
```bash
flutter clean                    # Clean build artifacts
flutter pub get                  # Get dependencies
flutter run -d <device>          # Run on device (web, windows, etc.)
flutter run --mode profile       # Profiling mode
```

### Code Generation
The project uses **generated localization** files:
```bash
flutter gen-l10n                 # Regenerate from ARB files (if needed)
```

### Testing
Basic test file exists: `test/widget_test.dart` (currently placeholder)
- Build system: Android (Gradle with build.gradle.kts), iOS (Xcode)

## Project-Specific Conventions

1. **Global State Anti-Pattern**: The codebase relies on global variables in `myappsettings.dart` for page selection and dimensions. When adding features that cross scaffolds, use these patterns (not ideal for new code, but consistent).

2. **Localization-First**: Always extract UI strings to ARB files first:
   - Add to `app_en.arb` and `app_ar.arb`
   - Run `flutter gen-l10n` if needed
   - Reference via `AppLocalizations.of(context)!.newKey`

3. **Color Theming**: 
   - Use `ThemeProvider` for dark/light mode switching
   - Menu colors defined in `myColors` array in `main_menu.dart`
   - Background colors access via `myDefaultBackgroundColor` (set to grey[300])

4. **Widget Naming**: Use suffixes like `_section`, `_widget`, `_scaffold` for clarity (e.g., `TitleSection`, `SideMenuWidget`)

5. **Responsive Defaults**:
   - Desktop: min 1100x600, init 1900x900
   - Build separate UI logic for each scaffold, don't share complex layouts across form factors
   - Use `LayoutBuilder` to access screen dimensions

## Critical Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry, Provider setup, window manager initialization, localization config |
| `lib/responsive/responsive_layout.dart` | Breakpoint logic for adaptive UI |
| `lib/data/myappsettings.dart` | Global state (selectedPageGlobal, screen dims, theme provider) |
| `lib/models/side_menu_widget.dart` | Navigation, page selection |
| `lib/l10n/app_localizations.dart` | Auto-generated, localization access |
| `pubspec.yaml` | Dependencies: provider, window_manager, intl, fl_chart, flutter_svg |

## Common Tasks

**Add a new page:**
1. Create `lib/pages/new_page.dart` with StatelessWidget
2. Add menu item to `myItems` in `main_menu.dart`
3. Add localization string to `app_*.arb`
4. Add case in Builder in each scaffold (desktop/tablet/mobile)
5. Update `SideMenuWidget` menu entry list

**Add a new UI string:**
1. Add key-value to `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb`
2. Run `flutter gen-l10n` (if auto-generation disabled)
3. Use `AppLocalizations.of(context)!.keyName` in widget

**Switch theme:**
- Trigger `ThemeProvider.toggleTheme(bool isDark)` from UI
- Provider automatically notifies listeners and rebuilds MaterialApp

## Dependencies Summary
- **flutter_localizations**: Localization support
- **provider**: State management
- **intl**: i18n utilities
- **window_manager**: Desktop window control
- **fl_chart**: Charting
- **flutter_svg**: SVG rendering
- **dynamic_color**: Material 3 color system
- **fluttertoast**: Toast notifications

## Lint Rules
Uses `package:flutter_lints/flutter.yaml`. Most rules enabled by default; add custom rules in `analysis_options.yaml` if needed.

