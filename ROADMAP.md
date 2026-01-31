## MVP
**Goal:** Achieve a playable round for 1–4 players with basic cooking, orders, anomalies, and camera mechanics.

### Features

- Ability to create a lobby for 1 to 4 players (local lobby + matchmaking / manual join).

- Map: one scene — a drive-thru restaurant (order counter, kitchen, storage, surveillance room).

- Food cooking mechanics (physical ingredient objects):
  - Player can pick up, hold, and drop objects.
  - Example flow: Potatoes → Fryer → Pickup counter.

- Restocking mechanics:
  - Physical “ingredient crate” object → brought to tray → increases stock.

- NPC logic and order-taking mechanics:
  - NPC comes to order counter, places an order (text/icon), then goes to pickup counter.
  - Player assembles the order and hands it over at the pickup counter.

- Anomaly mechanics:
  - A set of basic anomalies (behavioral / visual / audio).

- Counter closing mechanics:
  - Button / lever to close the counter.
  - When closed: NPCs wait or leave.
  - 3 mistakes → anomaly spawn and total player death.

- Round system:
  - Round duration ~10–15 minutes.
  - End-of-round screen (successful shift), teleport to main lobby.

- Surveillance cameras:
  - 3 cameras, night vision toggle.
  - Players can switch cameras and track NPCs.

- UI:
  - Orders, round timer, stock indicators, counter close button, mistake counter.

---

## v0.1 — Round Logic (Micro-Iteration — Acceptance Milestone)

**Goal:** Implement a working round loop (no multiplayer sync yet; local is fine).

### Deliverables

- Round start → NPC list generation (spawn paths) → round timer.
- NPCs approach order counter and give static orders (icon / text).
- Player can cook 1 order type (potatoes → fryer → pickup).
- NPC leaves the map after receiving the order.
- End-of-round success / failure screen.

### Acceptance Criteria

- One full round runs from start to finish without errors.
- Order can be completed and counted.
- Timer works correctly in a solo session.

### Technical Notes

- Use a ModuleScript for round logic (`RoundManager`).
- NPCs as simple PathfindingAgents.
- Orders as tables (`item`, `timeToPrepare`).

---

## v0.2 — Ingredient Physics and Restocking

**Goal:** Introduce physical objects and stock logic.

### Deliverables

- Ingredients as physical objects (Pickup, Carry, Drop).
- Fryer and pickup counter accept objects and change states (raw → cooked → ready).
- Stock system: trays accept crates/bags to increase counters.
- UI showing current stock levels.

### Acceptance Criteria

- Player can pick up, carry, and use objects.
- Restocking increases available ingredients.
- Preparation is impossible without stock (visible in UI).

### Technical Notes

- Use Constraints & BodyGyro / Attachments for proper holding.
- Server-side validation: RemoteEvents for pick/drop and authorization checks.

---

## v0.3 — NPCs, Orders, Queues, and Base Anomalies

**Goal:** Make NPCs feel alive and introduce first anomalies.

### Deliverables

- Order system with queues: NPCs generate varied order combinations.
- NPC behavior logic: approach → order → go to pickup → leave.
- 5 base NPC-bound anomalies (visual / behavioral).
- Mistake logic: false alarms and misses, mistake counter.

### Acceptance Criteria

- NPCs can repeat or alter behavior due to anomalies.
- Mistake system reacts correctly (3 mistakes → critical anomaly trigger).

### Technical Notes

- `NPCStateMachine` with states:
  - `Approach`, `Order`, `ToPickup`, `Leave`, `Anomalous`.
- Anomalies as data in ModuleScripts (`id`, `triggerCondition`, `visibleEffect`, `severity`).

---

## v0.4 — Counter Closing and Camera Systems

**Goal:** Implement counter closing, cameras, and team interaction.

### Deliverables

- Counter close button: blocks order intake and delivery.
- NPC reactions to closed counters (wait / leave / aggressive based on anomaly).
- Cameras:
  - 3 feeds.
  - Switching between feeds.
  - Night vision mode (visual effect).
- Players (local) can view cameras; networking-ready infrastructure.

### Acceptance Criteria

- Closing the counter blocks deliveries.
- Cameras show correct map areas and reveal inconsistencies (e.g., duplicate NPCs).

### Technical Notes

- Cameras: `ViewportFrame` or `RemoteCamera` + `RenderStepped`.
- Night vision: post-processing (grayscale + boosted brightness).

---

## v0.5 — Multiplayer, Synchronization, and Lobby

**Goal:** Add networked gameplay for 1–4 players.

### Deliverables

- Lobby: room creation / joining, player list.
- Server synchronization of objects (ingredients, orders, stock).
- Round state replicated to all players (server-side `RoundManager`).
- Basic security: server-side validation of client actions.

### Acceptance Criteria

- Up to 4 players share the same NPCs and objects.
- Pickup / drop actions are synchronized; no order desyncs.

### Technical Notes

- RemoteEvents / RemoteFunctions only for input & acknowledgments.
- ServerScripts hold authoritative logic.
- Use DataModel replication (Bindable or Value objects).

---

## v0.6 — Expanded Anomalies and Mechanic Polish

**Goal:** Add content and improve UX.

### Deliverables

- +15 anomalies (total ~20).
- NPC variety (types / behavior scripts).
- Smooth interaction animations and key event sounds.
- Tutorial hints for new players.

### Acceptance Criteria

- Anomalies detectable via UI, cameras, or NPC behavior.
- Players understand core gameplay thanks to hints.

---

## v0.7 — Balancing, Testing, and Bug Fixing

**Goal:** Intentionally break the game and fix it.

### Deliverables

- Full bug sweep and fixes.
- Edge-case gameplay scenarios covered.
- UX improvements based on internal testing.

### Acceptance Criteria

- No critical bugs blocking round progression.
- Stable performance on target PCs.

---

## v0.8 — Interface, Sound, and Atmosphere

**Goal:** Finalize presentation and mood.

### Deliverables

- Complete UI (lobby, HUD, end-of-round screens).
- Sound system (ambient, jump scares, interaction SFX).
- Visual effects (neon flicker, steam, distortion on mistakes).

### Acceptance Criteria

- Game evokes intended emotions (tension, anxiety).
- Audio is well-mixed and works on low settings.

---

## v0.9 — Pre-Release Preparation

**Goal:** Prepare for release and visibility.

### Deliverables

- Roblox Store icon and preview images.
- Game description and tags.
- At least 3 level / randomness variations.
- Metrics system: event logging (mistakes, rounds, survivors).

### Acceptance Criteria

- Marketing materials ready.
- Basic analytics in place.

---

## v1.0 — Release

**Goal:** Public launch on Roblox.

### Deliverables

- Game published on Roblox.
- Optional monetization: Game Passes, cosmetics.
- Post-release support plan (patches, content).

### Acceptance Criteria

- Game stable under peak load (basic validation).
- Initial feedback positive; no critical bugs.

---

## Post-Release (v1.x) — Updates and Support

- Minor patches and fixes.
- New anomalies and events (monthly / as needed).
- Events and seasons.
- Improvements based on feedback: balance, level design, QoL.

---

## Technical Stack & Recommendations (Roblox)

- Server-authoritative logic:
  - `RoundManager`, `NPCManager`, `InventoryManager`, `AnomalyManager`.
- Physical items:
  - Optimize active simulations (use network ownership).
- Cameras:
  - `ViewportFrame` for monitoring or `RemoteCam` + `RenderStepped`.
- Animations:
  - Use `Animator` + `AnimationTracks`.
  - Minimize networked animations.
- Optimization:
  - LOD for objects.
  - Disable high-quality effects on low-end clients.

---

## Quality Assurance (QA) Checklist

- Complete round with 1 player.
- Complete round with 4 players.
- All anomaly types trigger correctly.
- Counter closing blocks delivery for all players.
- Cameras show real NPC positions (and fake feeds when applicable).
- No critical memory leaks (objects cleaned up).
- Item replication works correctly.
