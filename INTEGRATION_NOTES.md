# K5-HUB Combined

This package combines the original K5-HUB UI with the full modular V61.11 engine source from `ironsoulkaitun-main`.

## Main files
- `Yuszx_Merged.lua` — original hub UI plus an **Advanced** tab that launches the V61.11 engine.
- `MERGED_LOADER.lua` — loader for the merged hub.
- `systems/` — full V61.11 modular systems and patches.
- `bootstrap_v61_11.lua` — V61.11 bootstrap.
- `script.lua` — redeem-code helper from the original project.
- `debug.lua` — original debugging helper.

## Important
The V61.11 modules are designed to be loaded by the V61.11 bootstrap. They are therefore kept as modules instead of pasted into the monolithic UI file.

The Advanced bridge maps the hub's compatible settings into `getgenv().K5-HUBConfig` before starting V61.11.

For a fully self-hosted deployment, upload this whole folder to a GitHub repository and set:
`getgenv().K5-HUBEngineBase = "https://raw.githubusercontent.com/USER/REPO/main/"`

The loader URL should point to the uploaded `Yuszx_Merged.lua`.
