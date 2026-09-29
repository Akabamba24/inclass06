## How do the smile measurements keep the drawing responsive?

The face center is `Offset(size.width / 2, size.height / 2)`, and its radius is
`size.shortestSide * 0.36`. The mouth `Rect` is centered relative to that point,
with width and height proportional to the radius and mood. Its smile arc uses
radians: a `0.15 * pi` start angle and a `0.70 * pi` sweep. A translated rect
and a different start angle create the frown. Using `size.shortestSide` keeps
the face circular in both portrait and landscape. The Pixel 10 emulator showed
the face fitting in portrait and the canvas sharing the landscape screen with
the controls.

## When should a painter repaint?

This painter should repaint when any drawing input changes: mood, face style,
eye radius or gap, blush, hat, glasses, or mustache. `shouldRepaint` compares
those fields and returns `true` when at least one differs. Returning `false`
unconditionally would leave the old drawing after a control change; returning
`true` unconditionally would redraw even when the configuration is unchanged.
Comparing the actual fields keeps the drawing current without unnecessary
repaints.
