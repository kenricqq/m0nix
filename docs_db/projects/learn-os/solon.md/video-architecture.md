# Video Streaming Architecture Summary

## Goal

Build a local-first video delivery system for a power-user learning platform that supports both:

- **Reliable playback across devices**: smooth streaming from your machine to other devices on the same network
- **Learning-aware playback**: chapters, timestamps, transcript, and analysis layered on top of the video

## Core Stack

### Vidstack

Use Vidstack for **playback UI**.

Best for:

- HLS playback
- custom player controls
- chapter-aware UI
- timeline interaction

Typical responsibilities:

- play HLS streams
- render timeline and controls
- integrate chapter markers and timestamp jumps
- support guided playback UX

### SvelteKit

Use SvelteKit for the **web app and BFF layer**.

Best for:

- player page rendering
- frontend orchestration
- session-aware data loading
- shaping backend responses for the UI

Typical responsibilities:

- render the player page
- fetch transcript, chapters, tags, and analysis
- combine playback and learning data
- serve the local web app over LAN

### FastAPI

Use FastAPI for the **video intelligence and streaming API**.

Best for:

- video ingestion
- HLS metadata endpoints
- transcript, chapter, tag, and analysis APIs
- processing workflows

Typical responsibilities:

- register video assets
- trigger HLS packaging
- serve structured metadata
- expose video intelligence to SvelteKit

### Postgres

Use Postgres for **structured metadata**.

Best for:

- video records
- transcript chunks
- chapters
- tags
- analysis moments
- playback metadata

Typical responsibilities:

- store the system of record
- link videos to HLS manifests
- support timestamp-based queries
- keep learning metadata queryable

### Local Filesystem

Use local disk for **media assets**.

Best for:

- source video files
- generated HLS manifests
- HLS segment files
- thumbnails and derived assets

Typical responsibilities:

- store original video
- store packaged HLS output
- back local/LAN playback

---

## Product Defaults

### Delivery mode

Default to **HLS**.

Reason:
You want playback to work not just on the same machine, but also on other devices on your local network.

Backend:

- ffmpeg-generated HLS assets
- HTTP delivery over LAN
- Vidstack playback

Returns:

- HLS manifest URL
- optional rendition metadata
- poster / thumbnail metadata
- transcript / chapter / analysis metadata

### Network mode

Default to **LAN-accessible local hosting**.

Reason:
Another device cannot use `localhost` to reach your machine. It must use your machine’s local network IP.

Example:

- `http://192.168.x.x:5173`
- `http://192.168.x.x:8000`

---

## Local Files vs HLS

### Local files

Best for:

- fastest prototype
- single-device playback
- minimal setup

Weaknesses:

- one quality only
- less resilient on weak Wi-Fi
- not a strong foundation for multi-device playback

### HLS

Best for:

- multi-device playback on the same network
- adaptive quality
- smoother seeking
- better production path later

That makes HLS the better default for your direction.

---

## HLS Mental Model

### Manifest

The manifest tells the player:

- what stream variants exist
- where segments live
- how playback is organized

Typical file:

- `.m3u8`

### Segments

The video is split into many small chunks.

Reason:
This allows smoother streaming, buffering, and adaptive quality switching.

### Renditions

You can provide multiple versions of the same video.

Example:

- 480p
- 720p
- 1080p

The player can switch between them based on network and device conditions.

---

## Routing Strategy

### Simple v1 routing

Avoid complex streaming infrastructure at first.

Use clear responsibilities:

- **SvelteKit page** -> load player experience
- **FastAPI** -> return video intelligence and playback metadata
- **Static/HLS path** -> serve manifest and segments
- **Vidstack** -> play the HLS stream

This is easy to explain, predictable for users, and cheap to implement.

---

## Mental Model

### HLS answers:

**How do we stream video reliably across devices on the local network?**

### Vidstack answers:

**How do we render playback and timeline interaction cleanly?**

### FastAPI answers:

**How do we generate and serve learning-aware video metadata?**

### Postgres answers:

**What do we know about this video and its important moments?**

That is the cleanest separation of responsibility.

---

## API Layer Shape

### `/videos`

Default mode:

- create / list videos

Backend:

- FastAPI

### `/videos/:videoId/playback`

Default mode:

- playback bootstrap

Backend:

- FastAPI + Postgres

Returns:

- HLS manifest URL
- duration
- poster
- basic playback metadata

### `/videos/:videoId/transcript`

Default mode:

- transcript

Backend:

- FastAPI + Postgres

### `/videos/:videoId/chapters`

Default mode:

- chapter structure

Backend:

- FastAPI + Postgres

### `/videos/:videoId/analysis`

Default mode:

- timestamped analysis moments

Backend:

- FastAPI + Postgres

### `/app/videos/:videoId`

Default mode:

- frontend player route

Backend:

- SvelteKit BFF + page render

---

## Example UX Flow

### Video opens on another device

Flow:

1. User opens the SvelteKit app using the host machine’s LAN IP
2. SvelteKit fetches playback and intelligence data
3. Vidstack loads the HLS manifest
4. Video streams over the local network

### User watches on unstable Wi-Fi

Flow:

1. Vidstack requests the HLS stream
2. Player adjusts based on buffer/network conditions
3. Playback remains smoother than a single large local file
4. Transcript and chapter UX remain unchanged

### User reaches a critical moment

Flow:

1. Playback hits a marked analysis point
2. UI shows a subtle prompt or context card
3. User can pause, reflect, or continue
4. Transcript and chapter state stay in sync

---

## Why this design works

- supports local-first development
- works across multiple devices on your LAN
- gives you a better playback foundation than plain local files
- keeps the learning intelligence layer independent from delivery format
- fits naturally with Vidstack, SvelteKit, FastAPI, and Postgres

## Recommended v1

- **Vidstack for playback**
- **SvelteKit on LAN as web app + BFF**
- **FastAPI on LAN as video intelligence API**
- **Postgres for structured metadata**
- **Local filesystem for source video and HLS assets**
- **ffmpeg cli for HLS packaging**
- **HLS as the default delivery format**

## Subprocess example

```py
import subprocess

result = subprocess.run(
    ["git", "status"],
    capture_output=True,
    text=True,
    check=False,
)

print(result.returncode)
print(result.stdout)
print(result.stderr)
```
