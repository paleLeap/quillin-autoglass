# Mobile

Desktop is done. This is the mobile pass.

Target: the customer is standing next to a broken window, on a phone, one
handed, probably in daylight, probably not calm. Everything below is judged
against that.

## Known risks going in

Written before testing, so the test can confirm or kill them.

1. **The 3D picker.** Orbit controls versus page scroll on a touch screen. A
   drag that was meant to scroll the page will rotate the car, and a drag meant
   to rotate the car will scroll the page. This is the single biggest risk.
2. **Canvas cost.** WebGL plus a live render loop on a mid range phone, on
   battery, while the customer is stressed.
3. **Tap targets.** The glass list rows, the folded step lines and the dock
   links were all sized for a pointer.
4. **The hover nav.** The logo strip opens on hover. There is no hover on a
   phone, so the whole primary navigation is currently unreachable there.
5. **The 100vh problem.** Mobile browser chrome shrinks and grows the viewport,
   which moves anything anchored to the bottom.
6. **Fixed bottom furniture.** The dock and the "About us." corner both sit at
   the bottom, where the thumb and the browser UI already are.
7. **Photo upload.** Should offer the camera directly, not just the gallery.
8. **The VIN field.** 17 uppercase characters on a phone keyboard.
9. **Text size.** The design leans on small, light type. It has to survive being
   read outdoors at arm's length.
10. **Picker list length.** Eleven panel rows in two columns becomes a very long
    single column.

## Measured at 375 x 812, 2026-09-19

No horizontal overflow, which is the one thing that was already right.

### Blockers

1. **The entire section navigation is unreachable.** The logo strip has width 0
   without hover, and there is no hover on a phone. Measured: 0px. Until the
   bottom bar appears at the end of a page there is no way to reach services,
   guarantee, about or contact at all.
2. **The picker swallows the page scroll.** The canvas carries
   `touch-action: none`, which OrbitControls sets for itself. A finger dragged
   up the screen over the car rotates the car instead of scrolling, and the
   stage is 357px tall, so the customer is stuck at it. This is a trap, not an
   annoyance.

### Tap targets, against the 44px minimum

| control | size |
|---|---|
| "About us." corner | 19px |
| "I don't have my VIN" | 23px |
| bottom bar links | 33px |
| "Contact us!" | 38px |

### Others

- The photo input has no `capture` attribute, so it offers the gallery rather
  than the camera. The customer is standing next to the damage.
- The picker list is one column of 11 rows at 45px, so the damage step alone is
  around 500px of list under a 357px canvas.
- Page height on the picker step: 1821px.

## Done, 2026-09-19

Verified at 375 x 812 with touch emulation, full flow completed end to end.

| | before | after |
|---|---|---|
| section nav reachable on touch | NO, 0px | opens on tapping the logo, 411px |
| canvas touch-action | none, page trapped | pan-y, page scrolls |
| "About us." corner | 19px | 47px |
| "I don't have my VIN" | 23px | 44px |
| bottom bar links | 33px | 47px |
| "Click here!" in the hint | 18px | 44px |
| picker rows | 45px, 1 column | 47px, 2 columns |
| picker list height | ~500px | ~358px |
| stage height | 357px | 320px, sized in dvh |

Also: social icons hidden under 40rem, summary collapses to one column, the
split lists stack, the bottom bar scrolls sideways rather than wrapping, and
every text input is at least 16px so iOS does not zoom the page on focus.

### Decisions worth keeping

- Touch sizing is behind `@media (pointer: coarse)`, not a width query. A small
  laptop with a touch screen has the same thumbs as a phone; a narrow desktop
  window does not.
- `dvh` rather than `vh` for the stage. Mobile browser chrome grows and shrinks
  and `vh` is frozen to the largest viewport, so a vh-sized stage sits under the
  toolbar on first paint and then jumps.
- The inline help link gets padding with an equal negative margin, so the hit
  area is thumb sized while the paragraph still sets normally.
- The social icons are the first thing dropped on a narrow screen. They are the
  least urgent item on the page for someone whose window is broken.
- `capture` was deliberately NOT added to the photo input. On iOS,
  `accept="image/*"` already offers Take Photo alongside Photo Library, and
  adding `capture` would REMOVE the library option from people who already have
  a picture.

### Still open for mobile

- Real device testing. Everything above is emulated.
- The 3D picker on a low end Android has not been measured for frame rate.

## 2026-09-19: the mobile pass FAILED on a real device

Client verdict after testing on a phone: fine as a website, awful as a phone
experience. Believe this over anything measured below it.

### Why it passed testing and still failed

Everything in the table above was measured in a 375x812 emulator with touch
emulation. Every number was correct and the whole thing still feels bad, because
none of those numbers describe what using a phone is actually like:

- an emulator has a mouse pointer pretending to be a finger, so it never
  produces a diagonal drag, a lazy swipe or a fat tap
- it has no soft keyboard, so nothing ever covers half the screen
- it has no thumb, so reach is never wrong
- it has no scroll momentum, so nothing ever overshoots
- it never fights the browser's own chrome

Tap target sizes and overflow checks are necessary and nowhere near sufficient.
A real device, or nothing.

### The structural problem, stated plainly

The flow is a DESKTOP PATTERN wearing mobile CSS. It is one long page that grows
downward as questions are answered, and folding earlier steps makes it shorter
without making it a phone experience. On a phone that means:

- the page height changes under the thumb on every answer, so the customer's
  place on screen moves while they are reading
- the picker step alone runs about 1800px, so the car and the list of panels
  cannot be on screen at once and picking is done half blind
- `reveal()` scrolls when the next step is off screen, which on a phone is
  almost always, so the page yanks after nearly every interaction
- fixed furniture sits at the bottom, which is where the thumb and the browser
  toolbar already are
- focusing the VIN field raises a keyboard over the field it is focusing

A phone wants ONE STEP PER SCREEN: a fixed header, one question, a persistent
next and back, no page growth, no hunting. That is a different presentation
layer, not a stylesheet.

### The 3D picker is the worst of it

`touch-action: pan-y` was the wrong compromise, chosen because it was the
cheapest. It splits gestures by axis, so the customer is in a constant argument
with the page: a drag meant to rotate that wanders vertically scrolls instead,
and a swipe meant to scroll that wanders horizontally spins the car. Nobody
swipes on a pure axis.

Options the next session should weigh, none yet tried:
1. Put the picker in a full screen sheet with its own close control. Inside the
   sheet it owns every gesture and there is nothing to scroll, so the conflict
   disappears entirely.
2. Drop orbit on phones. Give preset views instead, front / driver / passenger /
   rear, as four buttons. Most customers do not want to fly a camera, they want
   to point at the window that is broken.
3. Drop the 3D on phones entirely and use a flat labelled diagram. The panel
   data is already right; the 3D is one way of showing it, not the only one.

Option 2 is probably where to start: it keeps what the picker is for and removes
the interaction that is failing.

### For the next session

Do not begin by tuning CSS. Begin by deciding whether the phone gets the same
presentation as the desktop at all. The flow logic, the VIN decode, the panel
resolver, the archetypes and the request record are all sound and presentation
agnostic; every one of them can drive a different phone front end without being
touched.

Test on a real device after every meaningful change, not at the end.
