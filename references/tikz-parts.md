# TikZ parts library

Copy-paste parts for handbook figures. Each figure is an `nhfigure`
environment: a `tikzpicture` whose units are millimetres on paper, with the
origin at the top left and y growing downward, like reading the page. Figures
are 180 mm wide (the text column), so x runs 0 to 180 and y runs 0 to the
figure's height. The styles (`o`, `w`, `wa`, `ld`, `box`, `lbl`, …) come from
`assets/nasa-handbook.cls`. The examples in `assets/examples/` use all of these
parts in context; search them for the part name.

Coordinates below are examples. Move them, but keep the sizes. When a part
must rise above the figure's first row (a breaker handle, a chart title),
start the figure at a negative y, `\begin{nhfigure}[-3.6]{50}…`, instead of
shifting everything down.

Conventions:
- Every path is `\path[<style>]`; the styles already say whether to draw or
  fill. Combine them with TikZ options when needed: `\path[of,rounded
  corners=0.8mm] …`.
- Labels are `\node[lbl] at (x,y) {TEXT};`. The point is the baseline start,
  as in drafting. Add `c` to centre on it, `r` to end at it, and `up` to read
  bottom to top. `lbl` is 2.35 mm, `lbl-s` 2.05, `lbl-b` 2.5 (regular width),
  `tag` 1.8 (inside tags and terminals).
- Curves: `\path[o,from svg] svg{M24,21 C19.5,39 17,35 17,30 Z};` takes SVG
  path data in the same millimetre coordinates. Native TikZ (`arc`, `..
  controls ..`, `circle`) works as well. Because y points down, an `arc` from
  0° to 90° turns clockwise on paper.
- A `scope` with `shift={(x,y)}` moves a group; `rotate=-a` turns it a degrees
  clockwise.

## Contents

- Structure: figure shell, box, panel, drum, bracket, figure code, detail inset
- Wiring: wire, arrow, junction, bus fan-out, wire label
- Period symbols: circuit breaker, selector switch, pushbutton, talkback, hex terminal, coil
- Drafting: callout and leader, dimensions, centerline, hidden line, section cut, section view, glass, axes
- Time and data: timeline axis and ticks, lanes and bars, events, markers, legend, sequence detail, parts strip
- Fluid and instruments: check valve, valve with actuator, pump, heat exchanger, gauge, sensor, station tags and station data, granular fill
- Charts: axes, ticks, axis titles, a computed curve, reference lines, marked points, process path

## Structure

Figure shell. The arguments are the height in mm, the figure number, the
caption and the figure code; the code is set at the bottom right for you:

```latex
\begin{nhfigure}{66}{2.1-1}{Recording System Functional Diagram}{TLM-501A}
  % parts
\end{nhfigure}
```

Box with a title and up to three detail lines (title 2.35, details 2.05, about
2.7 mm apart; centre the block vertically):

```latex
\path[box] (85,7) rectangle (113,22);
\node[lbl,c] at (99,11) {TELEMETRY ROUTER};
\node[lbl-s,c] at (99,14.2) {SESSIONS, ROUTES};
\node[lbl-s,c] at (99,16.8) {STATION CLOCK};
\node[lbl-s,c] at (99,19.4) {ACCESS TOKENS (SIGNED)};
```

Width guide for Routed Gothic Narrow: about 1.2 mm per character at 2.35 and
1.05 mm at 2.05. Leave at least 1.5 mm between text and a box edge.

Dashed panel (a runtime, device or trust boundary) with its name inside, top left:

```latex
\path[panel] (1.5,2.5) rectangle (78.5,67);
\node[lbl-s] at (3.4,5.6) {FIELD STATION (1 OF ≤ 8)};
```

Drum (storage: a database, bucket or disk). Body path, then the top ellipse
drawn over it:

```latex
\path[box,from svg] svg{M120,31 L120,44.6 A8.5,1.8 0 0 0 137,44.6 L137,31};
\path[box] (128.5,31) ellipse[x radius=8.5,y radius=1.8];
\node[lbl-b,c] at (128.5,36.6) {ARCHIVE};
\node[lbl-s,c] at (128.5,39.4) {OBJECT STORE};
```

Bracket grouping a row of parts, with its label above:

```latex
\path[w] (24,14.4) -- (24,13.2) -- (75,13.2) -- (75,14.4);
\node[lbl-s,c] at (49.5,12.2) {ENCODER CHAIN (ONE PER STATION)};
```

Detail inset on the right of a secondary figure, after a thin divider:

```latex
\path[t] (123.4,-0.6) -- (123.4,47.6);
\node[lbl-b] at (126,2) {DETAIL A: CLOCK SYNC};
```

## Wiring

```latex
\path[wa] (113,35) -- (119.6,35);  % arrow; stop 0.4 short of the target edge
\path[wa] (75,55.4) -- (79.8,55.4) -- (79.8,35) -- (84.6,35);  % routed wire, right angles only
\path[w] (22,10.5) -- (42,10.5);  % plain wire
\path[dot] (42,10.5) circle[radius=0.55];  % junction: wires join here
\node[lbl-s] at (114,34.2) {PART};  % wire name: 0.8 above the wire, near its start
\node[lbl-s,up] at (82.1,52.6) {4 MB BLOCKS};  % on a vertical wire
```

Bus fan-out (one source feeding a column of boxes):

```latex
\path[w] (137,37.5) -- (142.5,37.5);
\path[w] (142.5,11.5) -- (142.5,50.5);
\path[dot] (142.5,37.5) circle[radius=0.5];
\path[wa] (142.5,11.5) -- (144.6,11.5);
\path[wa] (142.5,24.5) -- (144.6,24.5);  % … one arrow per box …
```

Bus bar (power or data bus drawn as a narrow bar, label rotated beside it):

```latex
\path[box] (42,4) rectangle (44,43.6);
\node[lbl-s,c,up] at (40.9,23.6) {AGS BUS};
```

## Period symbols

Circuit breaker (two terminals, an arc and a pull handle), with name, rating and function:

```latex
\path[w] (22,10.5) -- (28.6,10.5);
\path[of] (29.2,10.5) circle[radius=0.6];
\path[of] (33.8,10.5) circle[radius=0.6];
\path[w,from svg] svg{M29.4,9.6 Q31.5,7.4 33.6,9.6};
\path[w] (31.5,8.1) -- (31.5,6.6);
\path[w] (30.4,6.6) -- (32.6,6.6);
\path[w] (34.4,10.5) -- (42,10.5);
\node[lbl-s,c] at (31.5,5.4) {CB1};
\node[lbl-s,c] at (31.5,13.2) {15A};
\node[lbl-s,c] at (31.5,15.6) {AGS MAIN A};
```

Three-position selector (common terminal, lever to the selected contact):

```latex
\path[of] (57.6,18.6) circle[radius=0.6];
\path[w] (58,18.2) -- (64.5,12.8);
\path[of] (65.2,12.4) circle[radius=0.6];
\path[of] (65.6,18.6) circle[radius=0.6];
\path[of] (65.2,24.8) circle[radius=0.6];
\node[lbl-s] at (64.6,10.8) {A};
\node[lbl-s] at (66.8,19.4) {OFF};
\node[lbl-s] at (64.6,27.8) {B};
```

Momentary pushbutton (bar over two terminals, plunger above):

```latex
\path[of] (54.6,32) circle[radius=0.6];
\path[of] (59.4,32) circle[radius=0.6];
\path[w] (53.8,29.8) -- (60.2,29.8);
\path[w] (57,29.8) -- (57,27.8);
\path[w] (55.8,27.8) -- (58.2,27.8);
\node[lbl-s,c] at (57,35.2) {S2 TRIGGER};
```

Talkback indicator, barber pole (striped = in transition, gray = ready):

```latex
\path[bp] (70,43.6) circle[radius=2.2];
\node[lbl-s] at (73.4,43.4) {AGS RDY TB};
\node[lbl-s] at (73.4,45.8) {GRAY = READY, BP = CHARGING};
```

Hex terminal (only when the text refers to the number):

```latex
\begin{scope}[shift={(77,12.4)}]
  \path[of] (-1.4,0) -- (-0.7,-1.2) -- (0.7,-1.2) -- (1.4,0) -- (0.7,1.2) -- (-0.7,1.2) -- cycle;
  \node[tag,c] at (0,0.7) {1};
\end{scope}
```

Coil or inductor (four humps):

```latex
\path[w,from svg] svg{M141,12 a1.4,1.4 0 0 1 2.8,0 a1.4,1.4 0 0 1 2.8,0 a1.4,1.4 0 0 1 2.8,0 a1.4,1.4 0 0 1 2.8,0};
```

## Drafting

Callout with leader. The label sits in a row above or below the object; the
leader starts just outside the text and ends on the part:

```latex
\node[lbl] at (84,5.2) {SINGULARITY CORE};
\path[ld] (90,6.2) -- (88.8,27.4);  % label above: start 1 below the baseline
\node[lbl] at (58.4,59.4) {TRIGGER S2};
\path[ld] (57.8,58) -- (52.4,45.6);  % label below: start left of the text, above its cap line
```

Horizontal dimension: two extension lines, two half dimension lines with the
arrow at the extension end, and the value in the gap:

```latex
\path[t] (17,39.6) -- (17,66.4);
\path[t] (130.6,36) -- (130.6,66.4);
\path[dim] (17,65.2) -- (63.6,65.2);
\path[dim] (130.6,65.2) -- (83.6,65.2);
\node[lbl] at (65.2,66) {27.60 [701]};
```

Vertical dimension (value reads bottom to top):

```latex
\path[t] (41,15.4) -- (6.4,15.4);
\path[t] (31,62.6) -- (6.4,62.6);
\path[dim] (8,15.4) -- (8,34.4);
\path[dim] (8,62.6) -- (8,43.8);
\node[lbl,up] at (8.9,43.4) {9.25 [235]};
```

Centerline and hidden outline:

```latex
\path[cl] (12,30) -- (141,30);
\path[hid] (25,23.4) rectangle (40,32);
```

Section cut A–A (heavy dash-dot line, arrows show the viewing direction):

```latex
\path[cut] (103.9,12.6) -- (103.9,47.4);
\path[w] (103.9,12.6) -- (107.6,12.6);
\path[dot,from svg] svg{M107.4,11.6 L109.4,12.6 L107.4,13.6 Z};
\path[w] (103.9,47.4) -- (107.6,47.4);
\path[dot,from svg] svg{M107.4,46.4 L109.4,47.4 L107.4,48.4 Z};
\node[lbl-b] at (110.4,13.5) {A};
\node[lbl-b] at (110.4,48.3) {A};
```

Section view: hatched cut faces, crossing centerlines, title and scale below:

```latex
\begin{scope}[shift={(160,29)}]
  \path[hatch] (0,0) circle[radius=13.4];
  \path[of] (0,0) circle[radius=10.6];
  \path[o] (0,0) circle[radius=13.4];
  \path[cl] (-16.4,0) -- (16.4,0);
  \path[cl] (0,-16.4) -- (0,16.4);
\end{scope}
\node[lbl-b,c] at (160,49.6) {SECTION A–A};
\node[lbl-s,c] at (160,52.4) {LOOKING FWD, SCALE 1/2};
```

Glass (short parallel diagonal strokes in two corners of the pane):

```latex
\path[t] (80.6,21.4) -- (83,19.2);
\path[t] (81.6,22.4) -- (84.6,19.6);
```

Coordinate axes (Y out of the page drawn as a dotted circle):

```latex
\begin{scope}[shift={(150,63.6)}]
  \path[wa] (0,0) -- (8.4,0);
  \path[wa] (0,0) -- (0,-5.6);
  \path[of] (0,0) circle[radius=0.9];
  \path[dot] (0,0) circle[radius=0.28];
  \node[lbl-s] at (9.2,0.8) {+X};
  \node[lbl-s] at (-1.2,-6.4) {+Z};
  \node[lbl-s] at (-4.8,2.8) {+Y};
\end{scope}
```

## Time and data

Timeline axis. Pick a scale (here x = 40 + 1.4 × seconds), majors every 10
with labels above, minors every 2. Generate the ticks with `\foreach` rather than typing them:

```latex
\node[lbl-s] at (2,7.4) {MISSION CLOCK, SEC};
\path[w] (33,8.2) -- (118,8.2);
\foreach \t in {-2,0,...,54} {
  \pgfmathsetmacro\x{40+1.4*\t}
  \pgfmathtruncatemacro\major{mod(\t,10)==0}
  \ifnum\major=1
    \path[t] (\x,8.2) -- (\x,6.8);
    \node[lbl-s,c] at (\x,6) {\t};
  \else
    \path[t] (\x,8.2) -- (\x,7.6);
  \fi
}
```

Lanes: label column at x 2–30, bars 2.6 mm tall, lanes 4.4 mm apart. A break
in a bar is a new file or segment; `gap` is a pending or absent span:

```latex
\node[lbl-s] at (2,21) {STATION 2 · CAMERA};
\path[vid] (40,19.1) rectangle (69.4,21.7);
\path[vid] (70.2,19.1) rectangle (107.2,21.7);
\path[aud] (40,23.5) rectangle (73.6,26.1);
\path[gap] (73.6,23.5) rectangle (83.4,26.1);
```

Event (dashed vertical through all lanes, label on top) and marker triangle:

```latex
\path[ev] (107.2,1.6) -- (107.2,37.6);
\node[lbl-s,c] at (107.2,1.2) {STOP};
\path[dot,from svg] svg{M58.9,7.4 L60.3,7.4 L59.6,8.6 Z};
\node[lbl-s,c] at (59.6,6) {M};
```

Legend (bottom left, a swatch and a name per row):

```latex
\path[vid] (2,38.6) rectangle (7,41);
\node[lbl-s] at (8.2,40.6) {VIDEO STREAM};
\path[aud] (2,42.4) rectangle (7,44.8);
\node[lbl-s] at (8.2,44.4) {AUDIO STREAM};
```

Sequence detail (two lifelines, a request and a reply):

```latex
\node[lbl-s,c] at (133,6.4) {STATION};
\node[lbl-s,c] at (169,6.4) {ROUTER};
\path[w] (133,7.4) -- (133,23.4);
\path[w] (169,7.4) -- (169,23.4);
\path[wa] (133,10) -- (168.6,14.6);
\path[wa] (169,14.8) -- (133.4,20.2);
\node[lbl-s,c] at (151,11.2) {PING};
\node[lbl-s,c] at (151,19.8) {PONG};
\node[lbl-s,c] at (151,27) {OFFSET = SERVER − (T0 + T1) / 2};
```

Parts strip (a file cut into fixed parts; hatched = special, dotted = filling):

```latex
\path[vid] (126,36.6) rectangle (134,40.2);
\path[aud] (134,36.6) rectangle (142,40.2);
\path[gap] (158,36.6) rectangle (166,40.2);
\path[fill=white] (129.2,37.3) rectangle (130.8,39.5);  % clears the hatch behind a digit
\node[lbl-s,c] at (130,39.2) {1};
```

## Fluid and instruments

Flow lines are `w` / `wa` wires; arrows show flow direction. These parts sit
on a line and break it.

Check valve (flow left to right; the bar is the seat):

```latex
\path[w] (19,23) -- (23.4,23);
\path[of,from svg] svg{M23.4,21.6 L23.4,24.4 L25.8,23 Z};
\path[w] (26,21.6) -- (26,24.4);
\node[lbl-s,c] at (24.7,20.6) {V1};
```

Two-way valve with actuator (bow tie, stem, actuator box):

```latex
\path[of,from svg] svg{M18.8,35.6 L18.8,38.4 L21,37 Z};
\path[of,from svg] svg{M23.2,35.6 L23.2,38.4 L21,37 Z};
\path[w] (21,37) -- (21,33.6);
\path[box] (19.2,31.2) rectangle (22.8,33.6);
\node[lbl-s,c] at (21,30) {BPV-2};
```

Pump (circle with a filled triangle pointing downstream):

```latex
\path[of] (63,23) circle[radius=2.6];
\path[dot,from svg] svg{M61.8,21.6 L64.8,23 L61.8,24.4 Z};
\node[lbl-s,c] at (63,28.2) {P1 PUMP};
```

Heat exchanger (a box with the two passes drawn as opposed thin arrows):

```latex
\path[box] (34,19) rectangle (56,41);
\path[ld] (35,23) -- (55,23);
\path[ld] (55,37) -- (35,37);
\node[lbl-b,c] at (45,28.6) {HX1};
\node[lbl,c] at (45,31.4) {EXTRACT COOLER};
```

Gauge on a tee (junction dot, stem, dial with a needle):

```latex
\path[dot] (95.4,13) circle[radius=0.5];
\path[w] (95.4,13) -- (95.4,17.4);
\path[of] (95.4,19) circle[radius=1.6];
\path[w] (95.4,19) -- (96.4,17.9);
\node[lbl-s,c] at (95.1,23) {BREW PRESS};
```

Sensor (tagged circle on a stem; a dashed `ev` line carries its signal to
what it controls). Make the circle big enough for its tag: r 1.7 for two
characters in `tag`:

```latex
\path[w] (27.8,37) -- (27.8,33.9);
\path[of] (27.8,32.2) circle[radius=1.7];
\node[tag,c] at (27.8,32.85) {T2};
\path[ev] (26.1,32.2) -- (22.8,32.2);
```

Station tags (numbered circles on the lines) and a station data list keyed to
them. Use them when the text or a chart refers to points in the flow:

```latex
\begin{scope}[shift={(58.2,23)}]
  \path[of] (0,0) circle[radius=1.3];
  \node[tag,c] at (0,0.65) {2};
\end{scope}
\node[lbl-s] at (35,43.6) {STATION DATA:};
\node[lbl-s] at (35,46) {PRESSURE ABS, TEMP};
\begin{scope}[shift={(59.4,40.9)}]
  \path[of] (0,0) circle[radius=1.3];
  \node[tag,c] at (0,0.65) {1};
  \node[lbl-s] at (2,0.75) {2.4 BAR, 22 °C};
\end{scope}
```

Granular or packed material (grounds, powder, pellets, a filter bed): the
`grain` style fills with a dot stipple. Clear the dots behind a label
with a paper rectangle, as the parts strip does for its digits:

```latex
\path[grain] (102,15.4) rectangle (118,18.6);
```

## Charts

A chart is a DETAIL inset or a whole secondary figure: L-shaped axes, short
ticks (1.2 major, 0.8 minor), tick labels in `lbl-s`, axis titles with
units, the y title rotated. A limit within a few per cent of the axis end
sits on the axis and can't be read; mark it as a dashed vertical at the time
it is reached instead. Let TikZ compute the curve with `plot`, mapping
data to millimetres in the expression. Reference levels and limits are dashed
`ev` lines labelled on the line.

```latex
\path[w] (139,3) -- (139,33) -- (176,33);
\path[t] (139,33) -- (139,34.2);
\path[t] (149.57,33) -- (149.57,34.2);
\path[t] (139,23) -- (137.8,23);
\path[t] (139,13) -- (137.8,13);
\begin{scope}[every node/.append style={anchor=base}]
  \node[lbl-s] at (139,36.4) {40};
  \node[lbl-s] at (149.57,36.4) {60};
\end{scope}
\begin{scope}[every node/.append style={anchor=base east}]
  \node[lbl-s] at (137.4,23.7) {80};
  \node[lbl-s] at (137.4,13.7) {90};
\end{scope}
\node[lbl-s,c] at (157.5,39.4) {PRESSURE, KPA ABS};
\node[lbl-s,c,up] at (131.4,18) {TEMPERATURE, °C};
% x: 40..110 kPa over 139..176; y: 70..100 °C over 33..3. Water boiling point (Antoine).
\path[w] plot[domain=44:94, samples=26, variable=\p]
  ({139+(\p-40)*37/70}, {33-(1730.63/(8.07131-log10(\p*7.50062))-233.426-70)});
\path[ev] (139,23) -- (171.41,23);
\node[lbl-s,c] at (156,22.2) {T2 LIMIT 80 °C};
\path[dot] (147.72,18.54) circle[radius=0.5];  % a marked point: 56.5 kPa, 84.5 °C
\path[w] (146.82,9.1) -- (148.62,10.9);
\path[w] (146.82,10.9) -- (148.62,9.1);  % an X: a state to avoid (93 °C at 56.5 kPa)
\path[wa] (171.41,16.4) -- (171.41,25.4);  % process path at 101.3 kPa (the sump)
```

