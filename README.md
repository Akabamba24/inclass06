# Smiley Painter Lab

In-Class Activity 06: drawing with Flutter `CustomPainter`.

## Features

- Responsive smiley painter with classic, sleepy, and surprised expressions.
- Bullseye mode for the three-concentric-circle drawing exercise.
- Mood slider with frown, neutral, and smile geometry plus cool/yellow/warm face colors.
- Eye size and spacing controls, optional blush, and independently toggleable hat, glasses, and mustache.
- Tap the drawing to cycle expressions; long-press to randomize; Undo restores the previous drawing configuration.
- Canvas examples use circles, rectangles, rounded rectangles, lines, arcs, ovals, and paths.

## Run and verify

```sh
flutter pub get
flutter run -d chrome
flutter test
flutter analyze
```

The release APK is generated with:

```sh
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`.

## Activity write-up

See [`docs/critical_thinking.md`](docs/critical_thinking.md). Portrait/landscape
phone-emulator observations and screenshots still need to be recorded on the
assigned phone device. The app was checked in Chrome during this implementation.

## Submission checklist

- [x] Release APK built.
- [ ] Test the APK on the assigned phone emulator or a physical phone.
- [ ] Record portrait and landscape device evidence in the critical-thinking write-up.
- [ ] Push the source to the student's GitHub repository and submit its URL.
- [ ] Submit the APK, repository URL, and assigned write-up to Dropbox.
