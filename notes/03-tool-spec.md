# The Tool: Glass Picker

A guided intake that replaces the ** ATTENTION ** block on the current site (the
year/make/model/VIN script the customer currently has to perform over the phone).

Desktop first, per project direction.

## Flow (as specified by the user, 2026-09-18)

**Step 0 - Greeting.** Calm, plain. "We know this can be frustrating. Let's keep
it simple." No hero image competing with it. One input on screen.

**Step 1 - VIN.** Single input, 17 characters. A `?` affordance inside the field
opens a hint listing where to find a VIN.

**Step 2 - Specifics.** Opens *underneath* step 1, does not replace it. Asks only
what the VIN could not answer, and only if needed. If the VIN answered everything,
this step does not appear.

**Step 3 - Confirm.** "So, you need repairs to a [year make model]?" + confirm
button. Small, quiet.

**Step 4 - The model.** A 3D, zoomable, rotatable vehicle with individually
selectable glass panels. Customer clicks the glass that is broken.

Each step reveals the next below it. Nothing above disappears; the customer can
always scroll up and change an earlier answer.

## Step 1 detail: VIN

Validate locally before any network call:
- 17 characters, no I/O/Q (never used in VINs)
- Position 9 is a check digit with a published algorithm. A typo fails it instantly.
This gives real-time feedback with zero latency and zero wasted API calls.

Then: `https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVinValues/{vin}?format=json`

VERIFIED 2026-09-18: free, no API key, returns `access-control-allow-origin: *`,
so it is callable directly from the browser. 154 fields, ~45 populated.

Fields that matter to us:
- `ModelYear`, `Make`, `Model`, `Series`, `Trim` - the confirm line
- `BodyClass`, `Doors`, `BodyCabType`, `VehicleType` - picks the 3D archetype
- `LaneDepartureWarning`, `ForwardCollisionWarning`, `AdaptiveCruiseControl`
  - each returns `Standard` / `Optional` / blank
  - `Standard` means the vehicle has it: a windshield replacement WILL need ADAS
    recalibration. The tool should say so, and it ties straight into a service
    Quillin already sells.
  - `Optional` means it might. That becomes a question in step 2.

### The `?` hint content
Where to find your VIN:
- Your insurance card or vehicle registration  <- lead with this
- Driver's side door jamb, on the sticker when the door is open
- Driver's side dashboard corner, visible through the windshield

Order matters. The dashboard VIN is read *through the windshield*, which is the
thing that may be shattered. Insurance card first.

### Escape hatch (required)
Not everyone has a VIN in reach, and a customer standing in a parking lot next to
broken glass is exactly the person this tool is for. Offer "I don't have my VIN"
which falls back to year / make / model dropdowns, populated from the same vPIC
API (`GetModelsForMakeYear`). Quillin's own stated policy already allows this for
pre-2010 vehicles, so this is not a compromise, it is their existing rule.

## Step 2 detail: what "specifics" actually means

The VIN identifies the vehicle. It does NOT reliably identify which windshield
that vehicle was built with. The same model year can ship several, and these are
the things that change the part and the price:

- Rain sensor (a gel pad behind the mirror)
- Forward camera / ADAS module behind the mirror
- Heated windshield / wiper de-icer (fine wires at the base)
- Heads-up display (HUD)
- Acoustic or laminated side glass
- Condensation / humidity sensor
- Antenna embedded in the glass
- Sunroof or panoramic roof

Ask these **pictorially, not by name.** The customer does not know what a
"condensation sensor" is. Show a photo of the area behind the mirror and ask
"does yours look like A or B?" Skip any question the VIN already settled.

## Step 4 detail: the 3D model

### The constraint to be honest about
There is no free or affordable source of accurate 3D models for every vehicle.
There are tens of thousands of year/make/model/trim combinations. Licensed
per-vehicle 3D catalogs exist for the industry but are priced for manufacturers,
not for a family shop in Wylie.

### The approach that works
**Body archetypes.** Build one clean low-poly model per body style and pick the
right one from the VIN's `BodyClass` + `Doors` + `BodyCabType`. Seven covers
essentially the entire consumer + commercial market Quillin serves:

| Archetype | Selected when | Glass panels |
|---|---|---|
| Sedan | BodyClass Sedan/Saloon, 4 doors | windshield, back glass, 2 front door, 2 rear door, 2 quarter, sunroof? |
| Coupe | Coupe/Convertible, 2 doors | windshield, back glass, 2 front door, 2 large quarter |
| Hatch/Wagon | Hatchback, Wagon | as sedan + liftgate glass |
| SUV/Crossover | SUV/MPV, CUV | as sedan + 2 vent, larger quarter |
| Pickup | Pickup, Truck | windshield, rear cab glass (slider?), 2 front door, rear door if crew cab, 2 vent |
| Van/Minivan | Van, Minivan | windshield, back glass, 2 front door, sliding door glass, multiple quarter |
| Heavy truck | Truck-Tractor | windshield (often 2-piece), 2 door, 2 vent |

This is honest with the customer as long as we say so: label it "a [Sedan] like
yours", not "your car". Nobody is fooled by a generic silver sedan, and nobody
needs to be. The customer's job here is to point at which window is broken, and
an archetype does that job perfectly.

The archetype also *matters*: a coupe genuinely has no rear door glass and a large
quarter glass; a crew cab has rear doors and a regular cab does not. Getting the
panel set right per body style is the whole value.

### Asset sourcing (RESOLVED: generated)
Eight archetypes, generated procedurally in js/model.js from authored side
profiles. No downloaded models, no licensing, no Blender step. Each pane is a
named mesh by construction.

Archetypes: sedan, coupe, convertible, hatch, suv, pickup (regular / extended /
crew), van, heavy. Reference renders in notes/renders/.

Shapes are modern-generic, one per body style. They do NOT vary by model year,
so a 1994 pickup and a 2024 pickup get the same modern shape. Year-based variants
(boxier profiles for older vehicles) are possible from the same table if wanted;
it is another set of numbers, not new machinery. Chosen from vPIC BodyClass + Doors + BodyCabType by
Glass.resolve(), keyword matched rather than exact matched because vPIC writes
"[SUV]" in its variable registry and returns "(SUV)" from a decode.

Verified: 28 body-class cases resolve to the right archetype, and all eight
archetypes build every panel the resolver declares, none missing.

### Technical
- three.js, GLB with Draco compression, one model loaded on demand (~200-500 KB each)
- Raycast on pointer for panel pick, emissive highlight on hover, distinct on select
- Orbit controls, clamped: no going under the floor, sane zoom limits
- Multi-select. A break-in often takes out more than one window.
- Lazy-load three.js only when the customer reaches step 4, so steps 0-3 stay light
- **Mobile fallback:** an interactive 2D SVG schematic with the same named panels
  and the same selection model. Not a downgrade of the 3D, a sibling view. Also
  the fallback for `prefers-reduced-motion` and for WebGL failure.
- Every panel must be reachable by keyboard and named in text. The 3D canvas is
  an enhancement over a labeled list, never the only way through.

### "Or just tell us!" (BUILT)
A free-text box beneath the picker. The customer describes the damage in their own
words and skips the model entirely. Not a fallback for failure, a peer path: some
people will always prefer a sentence to an interface, and it costs Quillin nothing
since a human reads the request either way. It also silently covers WebGL failure,
old devices and reduced-motion users without ever announcing a degraded experience.

## Step 5: timing (BUILT)

    When do you need this fixed?

      ( ) Right away.
      ( ) In the next day or two.
      ( ) Sometime this week.
      ( ) Just getting a price for now.

Four bare options, no explanatory subhead. The fourth matters as much as the first:
price shoppers are real customers, but they are not emergencies, and letting them
say so keeps a genuine emergency from queueing behind them.

"Right away" is flagged in the review, alongside the ADAS warning.

## Step 6: review (BUILT)

Submit on step 4 opens a summary of everything captured, in plain language:

    Vehicle    2019 Tesla Model 3
    Details    Sedan/Saloon · 4-door
    VIN        5YJ3E1EA7KF317286
    Damage     windshield cracked all the way across, and the driver's side
               back window is shattered
    Heads up   This vehicle has a driver assist camera. A new windshield has
               to be recalibrated to it.
    Timing     Right away.
    Service    Mobile. We come to you.

Editing anything above retracts the review, so a stale summary cannot be sent.
This is the last stop before the request leaves the customer's hands, and it is
where a wrong answer three steps back gets caught, rather than by a technician
standing in a driveway holding the wrong windshield.

STILL MISSING from the summary: the customer's name, phone, and where the vehicle
actually is. For a mobile business the location is not optional. Open question
below.

## Output: what happens after they select the glass

Quillin cannot be quoted a price by this tool. Real glass pricing comes from NAGS
(licensed, not free) and depends on part availability and their own margins.

So the tool's output is a **complete, unambiguous job request**, which is exactly
what they lack today (the current site has zero forms and takes zero structured
information). It should produce:

    2019 Tesla Model 3, VIN 5YJ...286
    Sedan. Needs: windshield, front driver door glass.
    Has lane departure + forward collision: ADAS recalibration required.
    Customer: name, phone, ZIP / where the vehicle is.

**Photographs change the delivery problem.** An SMS prefill cannot carry
attachments, and a mailto: link cannot either. Sending images needs somewhere to
put them: a form service with file upload, or a direct-to-storage upload with the
links included in the request. This is now the main thing standing between the
tool and being usable for real, and it is the one part that cannot stay purely
static. The UI is built and the files are held in the page; nothing leaves the
device yet.

Delivery is an OPEN question. Candidates:
- **SMS prefill.** They advertise "Accepts Calls & Text Messages". An `sms:` link
  prefilled with the whole summary is superb on mobile and meets them where they
  already work. No backend.
- **Form service** (Formspree / Web3Forms / Netlify Forms) to their Gmail. Works
  on desktop, free tier is adequate at their volume, no server to run.
- Probably both: SMS on mobile, email form on desktop.

## Open questions
- [ ] 3D asset sourcing. Blocks step 4. See above.
- [ ] Does the tool ask for customer contact info, or hand off to a call?
- [ ] Should it show any price indication at all, even a range? (Needs their input;
      we cannot derive it.)
- [ ] Does Quillin want chip repair routed differently? A chip is a photo, not a
      panel selection. Possibly a separate short path.
- [ ] Insurance: ask "are you filing a claim?" early? It changes the whole
      conversation and they list it as a service.
