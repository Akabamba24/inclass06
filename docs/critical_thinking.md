# Critical Thinking: Responsive Smile Arc and Repainting

## Smile geometry

The painter takes its drawing bounds from `Size`. It places the face at
`Offset(size.width / 2, size.height / 2)` and uses `size.shortestSide * 0.36`
for the face radius. The shortest side keeps the face circular and leaves room
for its border in both portrait and landscape layouts. The mouth's `Rect` is
centered on the face with a width proportional to the radius and a height
derived from mood. `drawArc` uses radians (`0.15 * pi` start and `0.70 * pi`
sweep for a smile), with a translated rectangle and a different start angle for
a frown.

The app gives the drawing a square area constrained by its available layout
space. In portrait, the canvas sits above a scrollable control panel; in
landscape, the canvas and controls sit side by side. No face position depends on
fixed screen pixel coordinates.

## Repaint decision

`shouldRepaint` compares every painter input: mood, face style, eye radius, eye
gap, blush, hat, glasses, and mustache. It returns `true` if any drawing input
changed. Returning `false` unconditionally would leave the old image visible
after one of these controls changes. Returning `true` unconditionally would
redraw even when all inputs are identical. Comparing the actual configuration
fields avoids both stale drawings and unnecessary redraws.

## Pixel 10 emulator evidence

The release APK was installed and launched on the Pixel 10 Android emulator on
September 29, 2026. `MainActivity` was confirmed as the resumed activity.

- [Portrait capture](evidence/pixel10-portrait.png): face and controls render in
  portrait; the control panel scrolls below the visible area.
- [Landscape capture](evidence/pixel10-landscape.png): the face and control
  panel lay out side by side without overflow stripes in the captured screen.
- [Interaction capture](evidence/pixel10-interactions.png): Sleepy expression,
  mood 0.37, and the hat accessory render together.
- Moving the mood slider from 0.82 to 0.37 changed its displayed value and the
  painter's face color/expression. The accessibility layout reported 37%.
- Hat and glasses toggled independently. Undo removed the glasses while
  preserving the hat, restoring the previous configuration.

These checks show that changed painter inputs repaint on the device. The
implementation compares every `FaceConfig` field in `shouldRepaint`; the
temporary always-false comparison build was not run.
