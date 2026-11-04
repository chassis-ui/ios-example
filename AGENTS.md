# AGENTS.md

Instructions for AI coding agents working in this repository.

## Project

The Chassis iOS example: one SwiftUI app whose tokens and assets come from versioned releases, and
whose brand is one build setting. It is an example, not a package: nothing is published, and there
are no changesets or releases. `README.md` explains how it works.

Related repositories (separate git projects, under `chassis-ui` on GitHub): `website-tokens`,
`website-assets`, `website-icons`, `assets`, `tokens`, `icons`.

## Commands

- Sync: `scripts/sync-brand.sh [brand]` fills `Generated/`. A build does it as its first phase.
- Lint: `scripts/lint-tokens.sh`, after a sync.
- Build: `xcodebuild -scheme ChassisExample -destination 'generic/platform=iOS Simulator' CHASSIS_BRAND=<brand> build`

Before a task is done, run the lint and build every brand of the build job in
`.github/workflows/ci.yml`. After a change to a screen, run each brand in the simulator, in light
and in dark, and look at it.

## Rules

- **No value in a view that is no token.** No color, font size, spacing, radius, duration or opacity
  as a literal. Take the closest context or unit token where a component has no group of its own.
  Do not get past the lint with a token of another kind.
- **Every asset comes from the release.** No SF Symbol, no image or font added to this repository.
  An icon or an image is a case of `ChassisAssets.swift`.
- **The source is the same for every brand.** Nothing in `ChassisExample/` names a brand or a font
  family, or branches on a brand. What differs comes from the tokens and the assets, under the same
  names.
- **Fonts are named by role.** A style reaches its file through `ChassisFonts`. A new text style is
  a token group added to `ChassisType+Styles.swift`.
- **The brand, the versions and their sources are in `Chassis.xcconfig`.** No repository or archive
  name in a script or a workflow: they read the setting. Do not add a list of
  brands to the source, a target per brand or a second configuration.
- **Keep the checks of `sync-brand.sh`.** A download is checked against the digest of its
  release, an unknown brand fails before `Generated/` changes, and the script needs no Node.js.
- **Do not move a version** unless the task asks for it.
- **Use the native control where it can take the tokens.** A custom control is for what iOS gives no
  way to style, and follows the Figma library `cx.components.UI`.
- **Changes to the tokens or the assets belong in their repositories**, and reach this one with a
  release. Report a missing token or asset there, and do not work around it here.
- **Keep the example small.** No dependency, no project generator. A reader should be able to follow
  a screen from top to bottom. Keep `README.md` true.
- **Name a sibling by its GitHub repository**, never by a local folder or a relative path.

## Cautions

- Never commit or push without being asked.
- Do not edit generated or fetched files: `Generated/`, `.cache/`.
