# Red reset-placeholder audit

The current source was compared directly with the saved original GitHub `source/reanim.lua`.

## What the original did

`CreateHumanoidCharacter` creates an R6 fake character whose body parts are red. The parts start with `Transparency = 1`. During limb reanimation, the update loop changes each fake limb to `Reanimate.PlaceholderTransparency` whenever `ReanimOkay` is false. When the newly spawned real character becomes valid, the fake limbs return to `Transparency = 1`.

The current source still contained the same red color, fake-character construction, and `ReanimOkay` transparency assignment. Those lines had not been deleted by the AnimLib, sitting, hitbox, module, or Krystal-overlay changes.

## Why it could disappear

The original behavior depends on the invalid-character window during reset. In addition, the saved **Placeholders** slider can be `1`, which makes the fallback completely transparent even while `ReanimOkay` is false.

## Restoration

AnimLib v1.5.3 retains the original fallback and adds a saved **Show Red Reset Placeholder** switch, enabled by default. While `ReanimOkay` is false, the limb reanimator caps the red fake limbs at `0.5` transparency. This is the period before the replacement `Player.Character`, humanoid, root part, and live humanoid state have all been detected. As soon as `ReanimOkay` becomes true, the red fake limbs return to `Transparency = 1`; there is no post-respawn timer.

This affects the limb reanimator's fake body only. It does not change the persistent root-part/hat hitbox toggle or the hat reanimator's individual hat placeholders.
