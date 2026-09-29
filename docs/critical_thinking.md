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

## Device evidence to record

The source implements the portrait/landscape layouts and interactive controls,
but device behavior must be confirmed on the assigned phone emulator or a
physical device. Record the actual device and observations here after running
the app:

- Portrait device and result: _not yet run in this workspace._
- Landscape device and result: _not yet run in this workspace._
- Slider redraw observation / DevTools evidence: _not yet captured._
- Configuration tested: mood, eye radius/gap, face style, and accessories.

To compare repaint strategies, temporarily change `shouldRepaint` to always
return `false`, move a slider on the device, and observe that the painter keeps
its previous drawing. Restore the field comparisons, move the slider again,
and observe that the drawing follows the control. Do not submit the temporary
`false` version. Include a screenshot or a short DevTools observation in the
final write-up once the device check is performed.
