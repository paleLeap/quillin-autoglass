# Decisions

Running log. Newest at the bottom. Each entry: what was decided and why.

- 2026-09-18 - Ground-up static build, no framework, no build step. Reason: site is
  content plus one tool; a framework buys nothing and costs maintainability for a
  small business owner. Revisit only if the tool demands it.
- 2026-09-18 - Desktop layout first, mobile adaptation second, per client request.
- 2026-09-18 - Client site reviewed. It is a single WordPress page, no nav, no forms,
  no tel: links. Rebuild is a genuine restructure, not a reskin. Content itself is
  good and mostly transfers.
- 2026-09-18 - Tool defined: VIN-driven guided intake ending in a 3D glass picker.
  Spec in 03-tool-spec.md.
- 2026-09-18 - VIN decode will be client-side against NHTSA vPIC. Verified free,
  keyless and CORS-open. Keeps the site static, no backend for identification.
- 2026-09-18 - 3D vehicles will be body-style archetypes chosen from the VIN, not
  per-vehicle models. Per-vehicle 3D for every year/make/model does not exist at
  any reachable price. Archetypes do the actual job (point at the broken window)
  and must be labeled honestly as "a sedan like yours".
- 2026-09-18 - No insurance content anywhere on the site. Client direction. Dropped
  from the proposed nav in 02-content-inventory.
- 2026-09-18 - Chip repair uses the same workflow as broken glass. No separate path.
  A chipped window gets replaced like a broken one.
- 2026-09-18 - 3D glass picker (step 4) deferred. Steps 0-3 built first as a stub
  that ends at a labeled panel list.
- 2026-09-18 - First pass is deliberately bare. Client will supply images marking
  what to change and add, so nothing decorative gets built before that feedback.
- 2026-09-18 - System font stack for now rather than loading Barlow, to keep the
  first pass free of external requests. Revisit at the brand pass.
- 2026-09-18 - Steps 0-3 built and verified in-browser. Real VIN decode against
  vPIC confirmed working client-side end to end. Step 4 left as a placeholder.
- 2026-09-18 - Step 4 gets an "Or just tell us!" escape hatch: a free-text box so
  nobody is forced through the 3D picker. Client direction. The picker is an aid,
  never a gate. Also covers low-end devices, WebGL failures and anyone who would
  rather type one sentence than rotate a car.
- 2026-09-18 - Added step 5, a review screen. Submit on step 4 opens a plain-language
  summary of everything captured (vehicle, details, VIN, damage, ADAS flag, mobile
  service) with a final send button. Client direction. Editing anything above
  retracts the review so a stale summary can never be sent.
- 2026-09-18 - Final send is a stub. It acknowledges and says plainly that nothing
  was sent, because delivery (SMS prefill vs form service) is still undecided.
- 2026-09-18 - Added a timing step between damage and review: "When do you need this
  fixed?" with four options (right away / day or two / this week / just getting a
  price). Client direction, to sort urgent jobs from people who can wait.
  "Just getting a price for now" is deliberate: price shoppers self-identify instead
  of being chased like emergencies, and a real emergency is not buried behind them.
  "Right away" is flagged orange in the review alongside the ADAS warning.
- 2026-09-18 - Copy pass: stripped the subheads from the damage, timing and review
  steps, and shortened two timing options to bare phrases. Client direction. The
  labels carry the meaning; the explanations were padding.
- 2026-09-19 - 3D glass picker built. Models are GENERATED, not downloaded. The
  requirement is that each pane is its own named, pickable mesh in the right place
  for the body style; a downloaded car model hands you nice geometry and exactly
  the wrong thing, since its glass is usually one merged mesh and splitting it into
  thirteen correctly identified panels is manual work that must be redone every
  time a model is swapped. Generating makes the panel names true by construction,
  costs no licensing, weighs almost nothing, and keeps all eight archetypes in one
  visual language. Profiles are authored data in js/model.js, easy to tune.
- 2026-09-19 - three.js r186 vendored locally under vendor/three, lazy-loaded only
  when the customer reaches the picker. OrbitControls' bare 'three' import is
  patched to a relative path rather than using an import map, because import maps
  only reached Safari 16.4 and this has to work on older phones. See
  vendor/three/README.md; the patch must be reapplied on upgrade.
- 2026-09-19 - The checkbox list beside the canvas is not a fallback, it is the
  same shared selection state rendered twice. Keyboard and screen reader users get
  the full step, and a WebGL failure costs the 3D view but nothing else.
- 2026-09-19 - Picker visual pass. One accent only, red: light (#e8615e) on hover,
  dark (#8c1d1a) on select, so the two states differ in value and not just hue.
  Idle glass is neutral grey, carrying no accent at all. The green was removed
  from the picker and its list. Client direction.
- 2026-09-19 - Stage background is transparent. The canvas has an alpha buffer and
  the scene has no background, so whatever the page sits on shows through behind
  the vehicle. Nothing to undo when the real background lands.
- 2026-09-19 - Silhouettes are corner-rounded arcs rather than straight polygons,
  and each body has wheel arches cut into its underside. Two findings worth
  keeping: a large extrude bevel does NOT soften a shape, it inflates it, because
  bevelSize pushes the outline outward in plane as well (the first attempt came
  out like a bar of soap); and without arches the wheels hide behind a solid flank
  and read as dark dots under the sill.
- 2026-09-19 - Panels are inset from their authored bounds so neighbours never
  touch. The dark greenhouse shows through the gap and reads as the pillar, which
  is what gives each selection a clean edge.
- 2026-09-19 - Rendering quality pass, after looking at how this is done elsewhere.
  Four changes, in order of how much each mattered:
  1. toCreasedNormals. ExtrudeGeometry returns NON-INDEXED geometry, so
     computeVertexNormals gives every triangle a flat normal and each curve
     renders as a fan of plates. This was the single biggest cause of "blocky"
     and no number of extra segments fixes it. Creased normals weld and smooth
     across faces under 42 degrees, so curves go smooth and the shoulder line,
     sill and tailgate stay sharp.
  2. Image based lighting from RoomEnvironment through PMREMGenerator, with
     ACES filmic tone mapping. The body reflects a lit studio instead of being
     shaded by two lamps. RoomEnvironment is built from plain meshes in code, so
     it costs no HDR download and keeps the site self-contained.
  3. Dark metallic paint with clearcoat, replacing pale flat grey. This is doing
     structural work, not just decoration: a pale matte surface shows every facet
     and every wobble in a generated curve, while a dark clearcoated one shows
     REFLECTIONS, and a highlight travelling over a slightly imperfect surface
     reads as a highlight rolling along a panel rather than as bad geometry.
     Going darker hid more of the jank than any amount of extra polygons.
  4. Corner radius cut by half and bevel by a third. Once smooth normals were
     doing the de-faceting, the fat radius was no longer needed and was only
     dissolving the hood and deck lines.
- 2026-09-19 - Selection markers are UNLIT (MeshBasicMaterial, toneMapped false).
  Measured first: tinting the physical glass material to #8c1d1a rendered as
  #ce5f5c, and darkening the albedo all the way to #3a0b09 still rendered
  #704e4e, a muddy pink. A white specular lobe from the clearcoat and environment
  sits on top of the pane and does not scale with base colour, so darkening the
  albedo only desaturates it. Opting the marker out of lighting and tone mapping
  gives exactly the authored colour: now measured at #88221f against a #8c1d1a
  target. Hover opacity was then raised from 0.68 to 0.88 because it measured
  #a54a49 against the near-black cabin, too dark to read as the light half.
- 2026-09-19 - Panes made flush and given rounded corners. Two causes of the
  sticker look: they were standing 12 mm off the skin (now 4 mm, just enough to
  beat z-fighting), and they were sharp-cornered rectangles. Real side glass is a
  rounded shape in an aperture. Windshield and back glass are now built flat in
  their own along-pillar plane and rotated onto the pillar line, so they are
  rounded by the same routine as the door glass and read as the same kind of
  object rather than as a tilted plate.
- 2026-09-19 - Added a calibration platter under the vehicle. It earns its place
  beyond decoration: a vehicle floating on a blank page has no ground and no
  scale, and the orbit reads as the object spinning rather than the viewer
  walking around it. Fixed spokes and rings give the rotation something to move
  against. Drawn to a canvas rather than built from line geometry, because lines
  would need hundreds of segments to stay smooth, would alias badly at a shallow
  angle, and could not fade out at the rim; a texture does all three in one draw
  call, and the fade is what lets it sit on any page background.
- 2026-09-19 - Camera fit still measures the VEHICLE, not the scene. Framing to
  the platter would push the car into the distance.
- 2026-09-19 - Proportions re-authored against real 2026 vehicles rather than
  guessed: Camry 4920x1840x1445 on a 2825 wheelbase, CR-V 4694x1867 on 2700,
  F-150 SuperCrew 5891x2029x1950 on 3693, Sienna 5174x1994x1740 on 3061.
  The overall boxes had been close, but EVERY wheelbase was too long (0.63 to
  0.65 of length against a real 0.574 to 0.63) with the rear axle far too far
  back, and the van was much too tall (0.375 H/L against a real 0.336). Wheel
  diameters now come from the actual factory tyre sizes.
- 2026-09-19 - Added mirrors, head and tail lamps, and a grille. Mirrors matter
  most: every road vehicle has them, they break the silhouette at exactly the
  height the eye checks, and their absence is one of the loudest toy signals
  there is. Lamps stay NEUTRAL rather than red, because red is the selection
  accent and a permanently red patch on every tail would compete with the answer.
- 2026-09-19 - ExtrudeGeometry bevel semantics, established by raycasting the
  built mesh instead of reasoning about it. I had it backwards twice.
  The WALL is the profile pushed OUTWARD by bevelSize and spans z from -depth/2
  to +depth/2. The END CAPS sit further out at depth/2 + bevelThickness but their
  outline comes back in to the original profile.
  Consequences, all of them load-bearing: windshield and back glass lie on the
  wall, so they need an outward offset of bevelSize and a half width no greater
  than depth/2; side glass lies on a cap, so it goes to depth/2 + bevelThickness
  and clips to the original profile. Getting this wrong buried every pane inside
  the body, which read as the glass having vanished.
- 2026-09-19 - Panes are clipped to the greenhouse outline (Sutherland-Hodgman
  against the convex cabin polygon). An authored pane is a rectangle but the
  greenhouse is a trapezoid with a raked A-pillar, so rectangle corners used to
  hang over the edge into thin air. Clipping also makes the front door glass
  follow the A-pillar for free.
- 2026-09-19 - There is now a regression check worth keeping: project each pane's
  centre to the screen and raycast it, and every pane must be the first thing the
  ray hits. It catches burying and floating in one test. Currently 51 panes
  across 6 archetypes, zero buried.
- 2026-09-19 - Switched the picker to an unlit wireframe skeleton: black stage,
  white grid, white creases, near-black fills, windows the only thing carrying
  colour. Client direction, and it solves the problem the previous three passes
  had been fighting. Shading is what exposed every imperfection in a generated
  curve, so the answer was to stop shading. All lights, the environment map and
  tone mapping were removed; nothing in the scene responds to light any more and
  nothing is left that can catch a highlight wrong.
  Fills are kept, a shade off the background, purely so the vehicle occludes
  itself. Without them you see through to the far side's glass and cannot tell
  which door you are about to pick.
- 2026-09-19 - EdgesGeometry threshold angle is the tool that hides the jank. At
  1 degree it draws every triangle boundary and a rounded body becomes noise. At
  14 it draws only real creases, so smooth curves contribute nothing and nothing
  about their tessellation can look wrong.
- 2026-09-19 - Bevel segments cut from 6 to 1. Counterintuitive but necessary:
  with nothing shaded, a smooth rolled edge buys nothing, and six shallow steps
  put no single angle above the edge threshold, so the body's own profile never
  drew and the car had no silhouette at all. One chamfer gives two clean parallel
  creases that read as a panel line.
- 2026-09-19 - Vendored LineSegments2 / LineSegmentsGeometry / LineMaterial for
  real line widths. GL `linewidth` is silently clamped to 1 by essentially every
  desktop driver, and at a device pixel ratio of 2 that is half a CSS pixel,
  which reads as grey mush. LineMaterial sizes strokes in pixels, but it has to
  be told the canvas size, so `resolution` is set on every material on resize.
  Same bare-'three' import patch as the other vendored files.
- 2026-09-19 - Every line object has raycast disabled. Lines sitting on top of
  the glass would otherwise intercept picks meant for the pane underneath.
- 2026-09-19 - Added "Upload images" under the damage step. Photos count as a
  damage description in their own right: attaching one alone satisfies the step
  and advances to timing, because a photograph of a smashed door tells Quillin
  more than any sentence would. Capped three ways (8 images, 15 MB each, 48 MB
  total) since phone cameras produce 3 to 12 MB a shot.
- 2026-09-19 - Two details in the upload worth keeping: iPhones hand over HEIC
  straight off the camera roll and most browsers cannot draw it, so a preview
  that fails to load falls back to naming the file rather than showing a broken
  image, and the file is still perfectly sendable. And object URLs are revoked on
  removal and on start-over, or a customer who restarts twice leaks every photo
  they ever picked.
- 2026-09-19 - Fixed the picker jumping the page on every selection. Two faults,
  one visible and one not. Every pane toggle called resetBelow(5), which tore
  down the timing step and rebuilt it, so the page scrolled to it again AND the
  customer's timing answer was silently wiped. Choosing a second broken window
  does not un-answer "when do you need this fixed"; only the review below is
  genuinely stale, so damage changes now reset step 6 and leave step 5 alone.
  reveal() also only scrolls when the target is actually off screen, so nothing
  yanks the page away from the car while it is still being used.
  Measured: first selection scrolls once to bring the new step into view, the
  three after it scroll zero, and the timing answer survives all of them.
- 2026-09-19 - Added a channel picker between the summary and the send button:
  Text message, Email, Instagram, Facebook, Pigeon. Client says Quillin works
  across all five, so the customer picks the one they already use rather than
  being pushed onto the shop's preferred channel. Send stays disabled until one
  is chosen, and the button then names it ("Send on Instagram"), because "Send
  it" is vague when there are five possible somewheres.
  The list is one table at the top of app.js, so adding or dropping a channel is
  a one-line edit.
- 2026-09-19 - Phone and email show their destination inline, taken from the
  client's existing site. Instagram, Facebook and Pigeon are deliberately blank:
  we do not have the handles, and inventing them would look authoritative and be
  wrong.
- 2026-09-19 - Driver assist findings are now OWNER ONLY. Client direction: the
  VIN reports a model-level capability, not a fact about the car in the driveway,
  so it is right often enough to be useful to Quillin and wrong often enough to
  alarm a customer about a recalibration they may not need. Telling the owner is
  useful; telling the customer is a false flag with a price attached.
  Removed from three customer-facing places, not one: the "Heads up" summary row,
  the "ADAS recalibration" entry in the customer's Work row, and the driver
  assist line on the confirm step. All three made the same claim.
  KEPT: the camera question in step 2. It only appears when the VIN is genuinely
  ambiguous, it is phrased as a question rather than an assertion, and it is the
  only way to resolve the ambiguity at all.
- 2026-09-19 - Split the customer's summary from the record Quillin receives
  (buildSummary vs buildRequest). The outgoing record carries the full ADAS
  picture with its provenance: what the VIN claimed, what the customer answered,
  whether recalibration looks likely, and a note saying the data is model-level
  and should be verified against the vehicle. A shop can act on a maybe; a
  customer cannot.
  Verified: on a 2020 Camry with ADAS Standard the page contains no mention of
  recalibration, driver assist or ADAS anywhere, while the record carries
  work: [Windshield replacement, ADAS recalibration] and fromVin: "yes".
- 2026-09-19 - "Upload images" promoted out of the damage step into a section of
  its own, sitting between the picker and the timing question, with copy that
  pushes it hard: "Photos help us more than anything else", and a solid button
  rather than the quiet underlined link it used to be. Client direction.
  It is revealed at the SAME time as the picker rather than gated behind it, for
  two reasons: the ask needs to be in plain view from the start to be taken
  seriously, and someone who would rather photograph the break than rotate a car
  can then do exactly that. A photo alone still advances the flow; verified with
  no pane picked and nothing typed.
- 2026-09-19 - Photos step reworded to a question, "Photos help the most, have
  any?", with a second answer: [Upload images] [No images]. Client direction.
  A heading that asks a question needs a way to say no; without one the only way
  past is to ignore the step, and the customer is left unsure whether they have
  missed something.
  "No images" clicked before anything has been described nudges rather than
  advances: "No problem. Tell us which glass is damaged above and we can carry
  on." Once damage exists it just says "No problem." and lets them through.
  The button hides itself once images are attached and returns if they are all
  removed, and uploading after declining flips the answer back.
  The record Quillin receives carries photosDeclined, which separates "said no"
  from "never engaged with the question". Those look identical in a zero count
  and mean completely different things about the request.
- 2026-09-19 - CORRECTION. The channel picker was built backwards. It was "where
  should the customer send this", which was wrong: the request goes to Quillin
  regardless, and what was actually needed is how QUILLIN reaches the CUSTOMER
  back. Reworded to "How would you like us to reach out?" and each option now
  carries an input for the customer's own number, address or handle rather than
  Quillin's.
  This also closes the hole flagged since the review step was first built: the
  request had a perfect glass specification and no way to reach anybody, which is
  not an actionable job.
- 2026-09-19 - Pigeon dropped from the list on client instruction. Remaining:
  text message, email, Instagram, Facebook.
- 2026-09-19 - Checkboxes rather than radios, per client. Someone may well want a
  text and an email, and picking one does not rule out another. Send stays
  disabled until at least one ticked channel holds a value that passes its own
  validator, so the request can never leave with an empty or malformed contact.
  Values are normalised on the way into the record: a phone number keeps only its
  digits, an Instagram handle loses its leading @.
  Errors only appear once something has been typed or the field has been left, so
  ticking a box does not immediately scold the customer for an empty field.
- 2026-09-19 - UI reframed around the pattern from paleleap.com, at the client's
  direction. Three things taken, none of them copied literally:
  ONLY WHAT IS NEEDED. A step that has been answered folds to one thin line
  carrying its answer, so the page shows the question being asked plus a quiet
  record of what came before. Clicking a folded line reopens it. The review
  screen went from a 3727px page to 2244px on the same input.
  MOVEMENT. The live step arrives sideways, never downward; vertical travel on a
  reveal reads as the page moving under you.
  SMALL TEXT. Light weights throughout, including the h1, which is large but
  thin. Weight is what makes a heading shout and nobody arriving here with a
  broken window needs shouting at.
- 2026-09-19 - The folding rule is "answered AND something later is open", not
  "everything except the last visible step". The first version folded the picker
  the instant it appeared, because the photo question is revealed alongside it,
  so the 3D model was never seen at all. An unanswered step is still a question
  and stays open regardless of what sits below it.
- 2026-09-19 - Folded steps are labelled with short nouns of their own (VIN,
  Vehicle, Damage, Photos, Timing) rather than reusing the question. "So...
  where's the damage?" is the right thing to ask and the wrong thing to file
  under. The VIN row keeps the VIN and the vehicle row keeps the vehicle so the
  two never say the same thing twice.
- 2026-09-19 - The picker no longer breaks out of the column. Breaking out put it
  left of the numbered rail and cut the rail's line in half; nothing is worth
  breaking the spine of the page for. Stage on top, panel list underneath in two
  columns, which also adapts to a phone for free.
- 2026-09-19 - Restored the picker's red accent, which the stylesheet rewrite had
  silently dropped back to green. The list beside the model must match the model.
- 2026-09-19 - Palette taken from the live Quillin site rather than invented, and
  their two brand colours keep the jobs they already have there: #2e6911 green is
  the TEXT colour (headings, the wordmark, links, the labels by the phone number)
  and #e56813 orange is the ACTION colour (every button, and the footer band).
  Neutrals are their own Astra palette: #212930 headings, #404e5c body, #f2f3f5
  raised surfaces.
- 2026-09-19 - One deviation, measured rather than guessed. White text on their
  orange is 3.32:1, under the 4.5:1 WCAG AA needs for normal text; their heading
  ink on orange is 4.44:1 and also short. So wherever white type sits ON orange,
  buttons and the footer band, a darkened #b34f09 is used instead, which measures
  5.20:1. The brand hex is kept wherever orange is a field rather than a
  background for words. Their green on white is 6.68:1 and needed no change.
  This matters more than usual here: the button is the primary action for someone
  who is already frustrated, and a button they have to squint at is a reason to
  give up and leave.
- 2026-09-19 - The picker keeps its own red. It is an instrument with a single
  accent, and the site palette would compete with the selection.
- 2026-09-19 - Disclosures animate their height instead of snapping. The cause
  was structural, not cosmetic: everything opened by toggling the `hidden`
  attribute, which is display:none, and display cannot be transitioned. So
  "I don't have my VIN" dropped three populated dropdowns into the page in one
  frame. height:auto cannot be transitioned either, so the height is measured
  and animated to an explicit value, then handed back to auto on finish.
  Web Animations API rather than CSS, so the measurement and the animation live
  in one place and an interrupted open cancels cleanly instead of fighting a
  class. Applied to the VIN help panel, the year/make/model fallback, the
  "just tell us" box, the photo grid, and every step reveal.
  Measured curve on the fallback: 0, 40, 74, 88, 110, 125, 135, 142, 147, 151.
- 2026-09-19 - The dropdowns are populated BEFORE the open animation starts.
  scrollHeight is read as the animation begins, so filling them afterwards would
  animate to the height of an empty box and then jump to the real one.
- 2026-09-19 - The glass step is faded rather than slid. A height animation there
  drives the picker's ResizeObserver every frame, which would resize a WebGL
  canvas around twenty times for a single reveal.

## 2026-09-19, later: the site around the tool

- The site is no longer "the tool on a page". It is a landing that IS the quote,
  with five sections behind it: quote, services, guarantee, about, contact, plus
  a help page reachable only from the VIN hint. Each opens as its own view with
  the greeting hidden, so they read as pages rather than accordions.
- Page swaps are one move, not two: the current view fades to zero, the swap
  happens while nothing is visible, then the new view fades up. Doing the swap
  mid-fade is what stops it reading as a flicker and hides the height change.
  A second click during a fade is QUEUED, not dropped; the first version
  returned early on `busy` and left the URL on one section while the view stayed
  on another.
- Two navigation surfaces, deliberately different in purpose. The logo expands
  on hover into the section words, which is the everyday nav. The bottom bar
  only appears when the end of the page is in view, which is the one that
  catches you when you have read to the bottom. About sits to the right of the
  other four, behind a rule, because it is the people rather than the service.
- "About us." sits alone in the bottom right corner in the logo's orange at 30%.
  A door left ajar rather than a call to action.
- The About page runs a backdrop of their own photographs: two layers dissolving
  into each other, each drifting. Blur and darkening are BAKED INTO THE FILES
  (14 to 18 KB each) because a CSS filter on a full screen layer is paid for
  every frame forever. It only starts when About opens, so the photographs never
  load for someone who only wants a quote.
- Help leads with the objections that make people leave, not with a walkthrough:
  "do I have to use this", "why do you want my VIN", "does anything send before
  I say so". The walkthrough is five one-line steps underneath. Page height came
  down from about 2300px to 1289px.

## Known state, 2026-09-19

WORKING END TO END: VIN decode, no-VIN fallback, ADAS question when ambiguous,
confirm, 3D picker across 8 archetypes, free text alternative, photo upload with
HEIC fallback, timing triage, review, contact capture with validation, start
over with confirmation, all five sections plus help, fades, folding steps.

NOT WIRED: delivery. Nothing is sent. The request record is assembled and can be
read from window.__lastRequest() for inspection.

STILL OPEN:
- The founding year. "20xx" renders in orange and is marked
  data-placeholder="founded" so it cannot ship quietly.
- Instagram and Facebook links are href="#" and marked data-placeholder.
- Where the finished request lands for Quillin, and where photographs go.
- Cache busting on the script tags. A change to app.js is not picked up by a
  plain reload, which cost real debugging time at least twice.
- 2026-09-19 - Picking glass no longer advances the flow. Client direction, and
  correct: tapping a window on the car is an act of POINTING, not an act of
  finishing, and moving the page the moment someone points takes the car out
  from under them while they are still deciding whether there is a second break.
  A "That it?" button under the picker does the advancing instead. It appears
  once there is something to move on from and retires once they have moved on.
- 2026-09-19 - Second half of the same fix, and the one that mattered more: the
  damage and photo steps are now HELD OPEN until "That it?" is pressed. The fold
  rule ("answered, and something later is open") folded the damage step the
  instant a pane was picked, because the photo step is its peer and is revealed
  at the same time. The car vanished on first selection, which is the same
  complaint as auto-advancing arriving by a different route.
- 2026-09-19 - Trap worth remembering: `.flow:has(.step.is-folded) .under` was
  written to retire the "Contact us!" button once the VIN step folds. The new
  button reused `.under`, so that rule hid it at exactly the moment it was
  needed, since it only appears after earlier steps HAVE folded. Now scoped to
  #step-vin.

## 2026-09-19: first feedback from the owner, on a phone

Verbatim points and what was done:

- "QAG logo bigger" -> mobile logo 3.25rem to 4.25rem. It had been shrunk to
  make room for social icons that were later dropped.
- "it took me a minute to find more info. Clicking the logo to open up the other
  information is not obvious enough" and "the menu that pops up on the bottom
  doesn't pop up unless I click ? or click the logo" -> the bottom bar is now
  PERMANENT on phones instead of appearing only at the end of a page. Hiding it
  made the site look like it had no navigation at all. The logo toggle stays on
  desktop, where hovering a mark is a reasonable thing to discover.
- "it is difficult to click contact us, about us is in the way" -> a real
  collision: the fixed "About us." corner and the Contact button were both
  pinned bottom right. With the bar permanent, about already has a place in it,
  so the floating copy is hidden on phones.
- "keep the 3D car from disappearing after 1st piece of glass clicked" -> already
  fixed earlier the same day; he was testing the previous build.
- "something to specify whether they want a rock chip repair or a full
  replacement" -> added, see below.

### The chip question

Asked only when the windshield is among the chosen glass, and it must be
answered before "That it?" will advance. Sized the way a customer can actually
check rather than in millimetres: "smaller than a quarter" / "a crack, or bigger
than that" / "I am not sure".

It rewrites the work line rather than adding to it. A chip is REPAIRED, not
replaced, and telling someone with a chip that they need a windshield
replacement quotes them the wrong job at several times the price. Unsure becomes
"Windshield: repair or replace, we will check", which is the honest answer.

NOTE a tension in the instructions, resolved rather than ignored: the client said
earlier that "a window with a chip needs to be replaced just like a broken one,
should be the same workflow". That was about not building a separate chip PATH,
and this is not one. It is one extra question inside the same flow. The owner,
who does the work, asked for it directly, and the research backs him: repairs are
attempted far more often than replacements.
- 2026-09-19 - On phones the category strip is lifted OUT of the layout. It was
  growing the header sideways, which on 375px meant five words wrapping onto
  several lines and pushing the whole page down, so opening the menu made the
  site look like it had grown a limb. It now hangs under the header as one row
  that cannot wrap, scrolls sideways if it has to, and overlays the page.
  Measured: header 108px and content top 108px, unchanged, open or closed.
  The closed state is opacity 0 with translateY(-12px), so removing the class
  plays the same transition backwards and the row lifts away upwards on its own.
- 2026-09-19 - The logo was wired TWICE. It carries href="#quote" so it was
  picked up by the generic panel-link handler as well as by its own toggle: one
  tap ran both, so the menu opened and was closed again in the same gesture
  while the page navigated. The panel loop now skips it, and the logo handler
  navigates on pointer devices and toggles on touch.
- 2026-09-19 - TESTING NOTE. CSS transitions report playState "running" but
  never advance while the browser pane is not compositing, so opacity reads as
  its start value forever and a working transition looks broken. Verify end
  states with transitions bypassed rather than chasing a phantom.
