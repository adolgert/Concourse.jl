# SMT2020 dataset-1 (HVLM) loader data

Derived, minute-normalized CSVs consumed by
[`../smt2020_hvlm.jl`](../smt2020_hvlm.jl). They are a **reduced** projection of
the SMT2020 dataset-1 (High-Volume/Low-Mix) workbook — only the fields the
Concourse model uses, all times converted to minutes, no field containing a
comma (so the Julia loader parses with a bare `split(',')`).

## Provenance

Source workbook (untracked — the raw 447 MB testbed stays out of git):

```
examples/SMT2020_data/SMT_2020 - Final/General Data/dataset 1/SMT_2020_Model_Data_-_HVLM.xlsx
```

described in

> D. Kopp, M. Hassoun, A. Kalir, and L. Mönch, "SMT2020 — A Semiconductor
> Manufacturing Testbed," *IEEE Trans. Semiconductor Manufacturing*, vol. 33,
> no. 4, pp. 522–531, Nov. 2020. DOI: 10.1109/TSM.2020.3001933.

The numerical data are the paper's reference [16], downloaded from Lars Mönch's
group at FernUniversität in Hagen
(`https://p2schedgen.fernuni-hagen.de/index.php/downloads/simulation`). See
`../SMT2020_data/DATA_SOURCE.md` for the full download provenance and the raw
Excel schema.

## Regenerating

```
python3 extract_smt2020.py [path-to-SMT_2020_Model_Data_-_HVLM.xlsx]
```

(defaults to the location above; only dependency is `openpyxl`). The script
merges the workbook parse, the minute normalization, and the PM+breakdown
availability arithmetic into one self-contained file, and asserts that no
emitted field contains a comma.

## Files

### `toolgroups.csv` — one row per tool group (106 rows)

| column | meaning |
|---|---|
| `toolgroup` | tool-group name (e.g. `Litho_BE_110`) |
| `area` | process area (11 real areas + the virtual `Delay_32`) |
| `n_tools` | number of tools in the group |
| `availability` | A = 1 − SDT − UDT, precomputed from PM + breakdown (below) |
| `batching` | `YES` for the 10 diffusion furnace groups, else `NO` |
| `cascading` | `YES` if the group pipelines wafers/lots (cascade interval in the route) |
| `loading_min`, `unloading_min` | per-lot load / unload minutes |

`availability` reproduces the paper's Table III per-area availability to ≤0.2
points on all 11 areas. Time-based PMs contribute `TTR/period`; counter-based
PMs (per-tool wafer counters) are converted with the group's offered wafer
throughput; breakdown gives `UDT = MTTR/(MTTF+MTTR)` per area. `Delay_32` is the
virtual 400-tool hold station (A = 1.0); the model runs it as an infinite-server
pure delay, which is why the paper counts 105 tool groups / 1043 tools while the
sheet has 106 / 1443 (1443 − 400 = 1043).

### `route_product3.csv` (583 rows), `route_product4.csv` (343 rows)

One row per route step, ordered by `step`.

| column | meaning |
|---|---|
| `step` | local step index (1..N) |
| `toolgroup` | tool group visited |
| `unit` | `Wafer` / `Lot` / `Batch` (processing granularity) |
| `pt_min` | mean processing time (minutes; per wafer / per lot / per batch by `unit`) |
| `pt_offset_min` | ± offset of the uniform PT distribution |
| `cascade_interval_min` | inter-unit cascade interval (blank if the step does not cascade) |
| `batch_min_wafers`, `batch_max_wafers` | batch size window (Batch steps only) |
| `sample_prob` | metrology sampling / processing probability (1.0 if always executed) |

`unit` + `cascade_interval_min` + the batch fields fully determine per-step
occupancy and latency via the formulas in `smt2020_hvlm.jl` (`occ_lat`).

### `lotrelease.csv` (4 rows)

| column | meaning |
|---|---|
| `product` | `Product_3` / `Product_4` |
| `route` | route sheet name |
| `lot_type` | `Regular_Lot_*` or `HotLot_*` |
| `priority` | source priority (10 regular, 20 hot; **higher = more urgent** in the source data) |
| `wafers_per_lot` | 25 |
| `release_interval_min` | 51.69 (regular) / 2016 (hot) |

The model inverts the priority convention to Concourse's *lowest-key-first*
(hot → 1.0, regular → 2.0). The `SuperHotLot` stream present in the workbook
(Product 3, 27397.6 min interval, ≈0.19 % of P3 releases) is **dropped**: both
the paper's 10,000 WSPW working point and the offered-load oracle use only the
regular + hot streams.

## What is NOT here (dropped from the reduced model)

Sequence-dependent setups, rework loops, CQT (critical-queue-time) links, and
lot-to-lens dedication are present in the workbook but omitted from these CSVs —
each is a documented, quantified drop in the model header and docs page. They
live in the source workbook sheets `Setups` / `Setup_Matrix_*`, the route
`REWORK`/`CQT`/`LTL` columns, respectively, if a future model wants them. The
scouting scripts in the project scratchpad emit them to `setups.csv`, `pm.csv`,
`breakdown.csv` for reference.
