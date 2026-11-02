# Chassis iOS example

A SwiftUI app that shows how to use Chassis UI in an iOS project. It is an example to read and
copy from, and it is not published. Its colors, type, spacing, motion, fonts, icons and images
all come from two versioned releases, and one build setting chooses the brand:

- [`chassis-ui/website-tokens`](https://github.com/chassis-ui/website-tokens/releases): the iOS
  archive of the `demo` app, with its Swift constants.
- [`chassis-ui/website-assets`](https://github.com/chassis-ui/website-assets/releases): the iOS
  archive of the `demo` app, with its asset catalogs, fonts and app icon.

## Run it

You need Xcode 26 or later, which can compile the `.icon` app icon (built and run with 27.2), and
a network connection for the first build. There is nothing else to install. If a download reports
GitHub's rate limit, set `GH_TOKEN` to a token for the script to send.

```shell
open ChassisExample.xcodeproj
```

The first build downloads the tokens and the assets of the brand into `Generated/`. Neither that
folder nor the downloads in `.cache/` are committed.

## Switch the brand

Change one line of [`Chassis.xcconfig`](Chassis.xcconfig) and build:

```
CHASSIS_BRAND = sinefil
```

Or override it for one build, as CI does:

```shell
xcodebuild -scheme ChassisExample -destination 'generic/platform=iOS Simulator' CHASSIS_BRAND=sinefil build
```

Each brand has its own bundle identifier, so both install side by side. An unknown brand fails
the build, and the error lists the files of the release, which name the brands that exist.

## Adopt a new version

Change the version in `Chassis.xcconfig` and build. That line is the whole change:

```
CHASSIS_TOKENS_VERSION = 0.3.0
CHASSIS_ASSETS_VERSION = 0.5.0
```

A token that was renamed or removed then fails to compile, and shows you what to update. A font
role that no longer resolves stops the app at launch. `scripts/lint-tokens.sh` reports an icon or
an image that left the catalogs. The `Update versions` workflow checks for new releases each
week and opens a pull request. The repository has to allow Actions to create pull requests, and
CI starts on such a pull request when someone closes and reopens it.

## Use your own tokens and assets

Where the tokens and the assets come from is set in `Chassis.xcconfig` too, and a change to any of
these settings replaces `Generated/` on the next build:

| Setting                     | What it names                                                    |
| --------------------------- | ---------------------------------------------------------------- |
| `CHASSIS_APP`               | The app in the tokens and the assets, `demo` here                |
| `CHASSIS_TOKENS_REPOSITORY` | The GitHub `team/repo` of the tokens, with a release `v<version>` |
| `CHASSIS_TOKENS_ARCHIVE`    | The name of the tokens archive of a brand on that release        |
| `CHASSIS_ASSETS_REPOSITORY` | The GitHub `team/repo` of the assets, with a release `v<version>` |
| `CHASSIS_ASSETS_ARCHIVE`    | The name of the assets archive of a brand on that release        |

The archive names are built from the app, the brand and the version. The archive of the tokens
holds the Swift files and `Icons.xcassets` at its top level. The Swift constants have to keep the
names this app reads, such as `ChassisTokensColor`, and the catalogs and the fonts have to keep
their names too.

## How it fits together

```
Chassis.xcconfig          The brand, the versions and where they come from
scripts/sync-brand.sh     Downloads, checks and unpacks a release. The first phase of the build
scripts/lint-tokens.sh    Fails on a value that is no token, or an asset that is not in a release
ChassisExample/Chassis/   The layer between the tokens and the screens
ChassisExample/Components/ Controls and views made of tokens
ChassisExample/Screens/   The mobile patterns
Generated/                What the sync writes, not committed
```

`sync-brand.sh` checks each download against the digest that GitHub records for it. It leaves
`Generated/` alone when nothing changed, so that Xcode compiles nothing again, and replaces the
whole folder with one rename when a setting changed. The project references the
generated files by their paths, which are the same in every brand.

### Tokens

The constants are used as they are, so that a token in a screen can be searched for in the
tokens and in Figma:

```swift
Text("Saved")
    .chassisType(.labelMedium)
    .foregroundStyle(.token(ChassisTokensColor.ColorContextDefaultFgMain))
    .padding(ChassisTokens.SpaceContextMedium)
```

The colors are dynamic, so light and dark need no code. The layer in `Chassis/` adds only what a
constant cannot do by itself:

| File                | What it adds                                                                 |
| ------------------- | ---------------------------------------------------------------------------- |
| `ChassisFonts`      | Registers the fonts, and resolves a style of the tokens to its file by role  |
| `ChassisType`       | A whole text style with its line height, scaled by Dynamic Type              |
| `ChassisStyle`      | Colors in SwiftUI, two-layer shadows, motion curves, the native bars         |
| `ChassisAssets`     | The icons and images this app uses, and an icon that scales with Dynamic Type |

### Fonts by role

The font files are named by role and weight, `display_mass.ttf`, and the brand decides which
family a role holds. The tokens give a style its family and weight, so `ChassisFonts` looks for
the role with that family and weight and takes its file. No family name is in the source, and
the name of the font is read from the file. Every style is resolved at launch, so a style without
a file stops the app at once.

### Assets

`Assets.xcassets` and `Icons.xcassets` come from the archive. `Image("logo/logo")` follows light
and dark, as the archive joins `logo_light` and `logo_dark` into one image set. An icon that paints
in `currentcolor` is a template, and takes the color of its view. The tokens have an
`Icons.xcassets` of their own for the icons of their components, which builds beside the other.

The app icon is the `.icon` bundle of the archive, `app-icon/app_icon.icon`. Xcode writes the older
icon images from it for earlier versions of iOS.

### Native and custom

The tab bar, the navigation bar, lists, sheets, swipe actions and toggles are native, styled by
tokens in `ChassisAppearance`. The segment bar, the search field, buttons and text fields are
custom, because iOS gives its own no way to take these tokens. They follow the mobile components
of the `cx.components.UI` Figma library.

The tab screens but Search have large titles, and a pushed screen or a sheet an inline one. A background on a
top `safeAreaInset`, such as that of the segment bar, takes `ignoresSafeAreaEdges: []`: by default it
reaches under the bar, where it covers a large title on iOS 27.

On iOS 27 the system draws the tab bar as floating glass. The selected tab takes its token, and the
tabs that are not selected keep the color of the system, whatever the appearance says. On iOS 18 they
take `fg-subtle`, as `_ Tabs - Glass` of the Figma library asks for both.

### Where the tokens have no group

The tokens have no group for a tab bar, a toolbar, an avatar or a skeleton, so these take the
closest context or unit tokens, as the bars of the Figma library do. Some values have no token:

| Value                         | What this app does                                                      |
| ----------------------------- | ----------------------------------------------------------------------- |
| The `round-44` radii of Figma | A `Capsule`, which is what they draw, as the tokens do not export them  |
| Shadow spread                 | Not applied, as SwiftUI has no spread                                   |
| Nav bar and tab bar height    | The height iOS gives them                                               |

## The mobile patterns

| Tab         | What it shows                                                                         |
| ----------- | ------------------------------------------------------------------------------------- |
| First launch | Paged onboarding, then a form with validation                                        |
| Home        | Segment filter, skeleton loading, pull to refresh, cards, push to a detail, a toast   |
| Search      | Search field, filter chips, results, an empty state                                   |
| Inbox       | List with swipe actions, badges, a tab badge, a conversation with its message field   |
| Account     | Settings list, appearance choice, toggle, a pricing sheet, a confirmation             |
| Foundations | A sample of the colors, spacing, radii, shadows and motion, every text style and icon this app uses, and the states of the components |

Each one follows dark mode and Dynamic Type, and has VoiceOver labels. The segment bar and the
initials of an avatar stop growing at a size that still fits them. A confirmation dialog is
drawn by iOS, in the system font. VoiceOver has not been run through these screens.

## Check it

```shell
scripts/sync-brand.sh
scripts/lint-tokens.sh
```

CI runs the lint and builds every brand, on the workflows of `.github/`. It does not open the app, so after a change to a screen,
run each brand in the simulator, in light and in dark.

## License

[MIT](LICENSE)
