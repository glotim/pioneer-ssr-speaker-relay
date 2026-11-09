# Build and install guide

This is how the first five relays (four plus a spare) were built for a VSX-816.
The steps are written from the build notes, including what went wrong, so you
can skip those mistakes.

<!-- Photos: add one per step where marked -->

## What you need

- Assembled cards from JLCPCB: **two per relay**.
- 18 AWG solid copper wire for the contact pins and 20 AWG solid wire for the
  coil pins.
- The printed case: one cover and one base per relay (see *Printing the case*).
- Fine-tip soldering iron, solder, flux, smooth-jaw needle-nose pliers, an
  X-Acto knife, a small file just thinner than the PCB (1.6 mm), fine
  sandpaper, and a tiny drill bit just over the wire size (about 1.1 mm for
  18 AWG).
- A crimper with a compound (force-multiplying) action, or anything that can
  flatten the end of a wire.
- Electrical tape.

## Printing the case

The case is a two-part print: a **base** that the pins pass through, and a
**cover** that snaps onto it.

- **Material: PETG.** Do not use PLA. It softens at the temperatures you will
  see inside a receiver.
- Files: `case/relay_case_cover.stl` (prints roof-down) and
  `case/relay_case_base.stl`. The OpenSCAD source is included if you need to
  adjust the fit for your printer (`fit`, `bump_out`, `hole_d`).
- Tested on an Original Prusa MINI with a 0.4 mm nozzle.

### Getting PETG off the sheet

PETG bonds very hard to smooth sheets and can tear the coating off a satin
powder-coated sheet.

- **Apply a glue stick first** as a release layer. A disappearing-purple stick
  works: apply a thin layer and let it dry until it turns clear. Re-apply after
  each print.
- To remove the parts, put water around them so it dissolves the glue, then
  flex the sheet both ways. Get a fingernail under a corner, then work it off
  with a **plastic** scraper.
- Even with glue, the parts stick hard. A **textured PEI sheet** is the better
  choice for PETG if you have one: parts pop off once it cools.
- Do not flex the sheet hard with the parts still attached. An early cover with
  vents near the top broke at the vent line.

### Cleaning up the prints

1. **Strings.** PETG leaves spider-web strings inside the cover. Picking them
   out with an X-Acto knife works but is slow. A quick pass with a hair dryer
   or heat gun shrinks them back. Drying the filament before printing (about
   65 °C for 4–6 hours) reduces them.
2. **Elephant's foot.** Sand the flared first-layer edge off all bases and
   covers so the cover slides on cleanly.
3. **Base holes.** The six pin holes print slightly undersize and may be closed
   by the first layer. Drill all six through with a tiny drill, then check
   that an 18 AWG wire passes through each.
4. **Card slots in the cover.** The slots that hold the tops of the cards come
   out rounded and partly filled, and the cards will not seat. Cut them
   **through the roof**: carve each slot clean with an X-Acto knife, then
   finish it with a file just thinner than the PCB. You can now see the cards
   go into their slots, and the cover goes all the way down. (The top gets
   taped over at the end.)

## Preparing the pins

1. Cut all the 18 AWG and 20 AWG pieces **longer than needed**. You trim them
   after installing.
2. **Swage one end** of each piece flat with the crimper: squeeze just the
   very end. This flat end stops the wire pulling through the card's hook hole.
   (A crimper with an adjustable stop would be better. The compound type
   squeezes quite thin.)
3. **Bend the flat end 90°** to the wire. Hold it in the *smooth* part of the
   needle-nose jaws, so the thin swaged section does not crack. It slips
   neatly as the bend nears 90°.

## Fitting the pins to the first card

Each card has a row of three pin pads along one edge. The middle pad and one
end pad are the contacts (18 AWG); the coil pad is 20 AWG.

1. Put an 18 AWG pin into the **middle** hole first, and line the flat foot up
   along its trace. **Do the middle one first.** Once an outer pin is in place,
   you cannot get the pliers onto the middle one.
2. Bend the wire by hand in the direction it needs to go.
3. With the needle-nose pliers, press the foot down so it sits as flat as
   possible on the pad.
4. Repeat for the other 18 AWG pin, then the 20 AWG coil pin.
5. **Slide a base onto the wire ends,** but leave it at the ends for now. It
   holds the three wires parallel at the right spacing. Make sure the wires
   are straight and lie flat on their pads.
6. Solder each **flat foot** to its pad. Before lifting the iron, drag the
   solder along the pad so there is no tall bump.
7. Now slide the base **all the way up** to the card, then solder the wires on
   the other side of the card, at the hook hole. First make sure all three
   wires are flat on their pads and the card is lined up lengthwise with the
   base. **Keep the solder away from the hole,** or it wicks through and makes
   the bump on the foot side bigger.

> **What went wrong on the first unit:** the excess solder on the foot side was
> not flattened, and soldering the hook side wicked more through. Adjacent
> pads ended up bridged by solder blobs. They were sanded apart (about 1/32",
> 0.8 mm). Flatten each joint as you go and this does not happen. If you must
> sand, brush the dust out with IPA afterwards, because metal dust is
> conductive.

**Watch the base while soldering near it.** The wires get hot enough to fuse
to the printed base, so make sure the card is all the way down before the
joint cools. It also leaves a small hill of plastic around each wire where it
exits the base underneath. Trim those off with a razor blade so the relay sits
flat on the receiver board.

## The second card

1. Solder the pins to the second card the same way, using a **spare base** (or
   a failed print) at the wire ends as the alignment jig for the foot side.
2. Remove the spare base and slide the second card's pins into the same base
   as the first card.
3. Make sure both cards are all the way down and lined up lengthwise with the
   base, then solder the second card's hook side.

## The link wire between the cards

Only the coil drive crosses between the two cards, through one wire.

1. **Fit the cover once before soldering the link,** to confirm the cards line
   up with the slots. Then take it off again.
2. Swage one end of a 20 AWG piece and push it through the spare coil pad of
   one card and on through the other card.
3. Solder the swaged end.
4. To set the spacing, push the two cards **upside down into the top of a
   modified cover** (the one with slots cut through). Then cut the excess wire
   above the second card and solder it.
5. Slide the cover on. The relay is done.

Once the first one works, go into assembly-line mode for the rest: modify all
the covers, then do each step for all the relays.

## Finishing

- **Blow out** each cover and card assembly before installing (a shop vac on
  blow works well) to clear plastic strings, flux crumbs and sanding dust.
- Put a piece of **electrical tape over the top** of each cover to cover the
  cut-through slots and keep dust out. One MOSFET pin sits close to the top of
  the card, near the roof.

## Bench check before installing

Apply about 24 V DC between the coil pins, **pin 6 positive, pin 1 negative**,
with a current-limited supply (about 10 mA is expected). With an ohmmeter:

- With power on, the contact pairs (2–3 and 5–4) read near 0 Ω.
- With power off, the contacts read open.
- Pin 1 or 6 to any contact reads open in both states.

## Installing

1. **Unplug the receiver** and wait for the filter capacitors to discharge.
   Plug and unplug any cables only with the receiver unplugged too.
2. Desolder and remove the original relays. Note pin 1 / pin 6 on each.
3. Fit each new relay in the same orientation (pin 6 = coil +), and solder the
   pins from underneath. Trim the excess.
4. Power up at low volume. Check every speaker output, speaker A / B
   switching, and listening-mode changes.

On the VSX-816 the **center channel relay (RY753) uses only one pole**, so a
relay whose cards were sanded apart (as above) is a good candidate for that
position.

## Results (VSX-816)

All four relays replaced. The dropouts are gone, and there is no more clicking
when changing listening modes (stereo to surround) or switching speakers A / B.
The single click at power-on remains. It comes from the AC power relay,
which is a different relay and is not part of this project.
