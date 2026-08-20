# OWC Express 1M2 — Jellyfin Media Organization

## Current Structure

```
/Volumes/OWC Express 1M2/
├── TV Shows/
│   └── Shōgun/
│       └── Season 01/
│           ├── Shōgun - S01E01 - Anjin.mp4
│           ├── Shōgun - S01E02 - Servants of Two Masters.mp4
│           ├── Shōgun - S01E03 - Tomorrow Is Tomorrow.mp4
│           ├── Shōgun - S01E04 - The Eightfold Fence.mp4
│           ├── Shōgun - S01E05 - Broken to the Fist.mp4
│           ├── Shōgun - S01E06 - Ladies of the Willow World.mp4
│           ├── Shōgun - S01E07 - A Stick of Time.mp4
│           ├── Shōgun - S01E08 - The Abyss of Life.mp4
│           ├── Shōgun - S01E09 - Crimson Sky.mp4
│           └── Shōgun - S01E10 - A Dream of a Dream.mp4
├── Movies/
└── Music/
```

## Naming Convention (Jellyfin + Elegentfin Optimized)

### TV Shows
`TV Shows/Show Name/Season XX/Show Name - SXXEXX - Episode Title.ext`

- Use `Season 01`, `Season 02`, etc. (not `S01`)
- Use spaces in filenames (not underscores)
- Include episode title after the episode code for best metadata matching

### Movies
`Movies/Movie Name (Year)/Movie Name (Year) - Quality.ext`

- Create a subfolder for each movie
- Include year in parentheses for accurate metadata
- Optional: add quality tag (1080p, 4K, etc.)

### Music
`Music/Artist Name/Album Name/01 - Track Title.ext`

## Tips for Future Additions

1. **Place new shows in `TV Shows/Show Name/Season XX/`**
2. **Place new movies in `Movies/Movie Name (Year)/`**
3. **Jellyfin will auto-scan** these folders on a schedule (or you can trigger manual scans)
4. **For Elegentfin theme:** Clean folder structure + proper naming = the best visual presentation

## Stats
- **Drive:** OWC Express 1M2 (3.6TB APFS)
- **Used:** ~23GB (mostly Shōgun S1)
- **Free:** ~3.6TB

---
_Updated: 2026-05-19_
