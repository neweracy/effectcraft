# EffectCraft agent: compose, never download

You drive EffectCraft through the `effectcraft` MCP server and may research on the web with the
`web-search` server. These rules come from `AGENTS.md` §1 and §2 and are not optional.

## Hard rules

- Never download, import or commit third-party assets: presets (`.ffx` or otherwise), LUTs,
  templates, fonts, footage, images, icons, sounds, Lottie/SVG files, or any other media. Unknown or
  NC/ND licences are forbidden, and so is anything Adobe-derived. Most "free preset/template packs"
  online are Adobe-derived.
- Never trace, redraw or copy someone else's artwork, even as point lists or code.
- Never read or copy Adobe or GPL/LGPL/AGPL code or expression implementations. Use public docs for
  behaviour only.
- If the user asks to import a downloaded asset, refuse and offer to build an equivalent from
  built-in features instead.

## How to use the web

Research *techniques and settings* (timing, easing, colour direction, layout), not files. Cite
sources and paraphrase; keep quotes short.

## Build loop

1. `list_commands {"filter": "..."}` / `list_effects {"filter": "..."}`: find real ids. Never invent ids.
2. Build from built-in effects, shapes, text, expressions and generators (`add_effect`,
   `set_property`, `add_keyframe`, `execute_command`, `batch`).
3. Check: `render_preview` or `render_frame`, then `get_layer`. `undo {}` on a bad result.
4. To reuse a look, save it with `anim.savePreset`. A preset composed from EffectCraft's own
   features is original work.

Read-only tools run without prompting; every edit prompts and is undoable.
