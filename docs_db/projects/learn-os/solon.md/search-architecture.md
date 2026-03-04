# Search Architecture Summary

## Goal

Build a search experience for a power-user learning platform that supports both:

- **Catalog discovery**: find the right course, lesson, or video
- **Moment retrieval**: find the exact segment and timestamp where something is explained

## Core Stack

### ParadeDB

Use ParadeDB for **catalog search**.

Best for:

- course / lesson / video discovery
- metadata filtering
- relevance ranking on titles, descriptions, tags
- faceting / browse UX

Typical questions:

- "best videos on habit formation"
- "beginner biology courses"
- "advanced postgres lessons"

### VectorChord

Use VectorChord for **moment search**.

Best for:

- transcript / chunk retrieval
- semantic search
- timestamped results
- "jump to the exact explanation"

Typical questions:

- "where do they explain habit formation?"
- "find all timestamps talking about MVCC"
- "show me the part about spaced repetition"

---

## Product Defaults

### Home search

Default to **catalog mode**.

Reason:
Users on the home page usually want to discover the right video / lesson / course first.

Backend:

- ParadeDB

Returns:

- videos
- lessons
- courses
- ranked metadata results
- optional filters/facets

### Lesson page search

Default to **moment mode**.

Reason:
Once the user is inside a lesson, they usually want the exact place where something is discussed.

Backend:

- VectorChord

Returns:

- transcript chunks
- timestamps
- snippets
- jump-to-moment results

---

## Hybrid Search

Support an optional **hybrid mode** for advanced users.

Good trigger:

- command palette prefix
- explicit mode selection

Examples:

- `/hybrid habit formation`
- `h: habit formation`
- `m: dopamine prediction error`
- `c: best biology lectures`

### When hybrid is useful

Use hybrid when the query needs both:

1. **object selection** (which videos/lessons matter)
2. **moment retrieval** (which timestamps inside them matter)

Example:

- "find beginner videos and their timestamps about habit formation"

### Hybrid orchestration

1. **ParadeDB** finds candidate videos / lessons
2. **VectorChord** searches transcript chunks inside those candidates
3. API groups chunk hits by parent video / lesson
4. UI shows both parent object and matching timestamps

---

## Routing Strategy

### Simple v1 routing

Avoid complex intent classification at first.

Use page context as the default router:

- **Home** -> catalog
- **Lesson page** -> moment
- **Command palette prefix** -> explicit override

This is easy to explain, predictable for users, and cheap to implement.

### Optional smart upgrade

If a home query strongly signals moment intent, optionally show a small **Matching moments** section.

Example query:

- "find all the videos and their timestamps talking about habit formation"

Possible response shape:

- normal catalog results
- plus a top "Matching moments" block

---

## Mental Model

### ParadeDB answers:

**Which videos or lessons should I look at?**

### VectorChord answers:

**Where inside those videos or lessons is the answer?**

That is the cleanest separation of responsibility.

---

## API Layer Shape

### `/search/home`

Default mode:

- catalog

Backend:

- ParadeDB

### `/search/lesson/:lessonId`

Default mode:

- moment

Backend:

- VectorChord

### `/search/command`

Advanced mode:

- explicit prefix-based routing

Backend:

- catalog / moment / hybrid depending on prefix

---

## Example UX Flow

### Query on home

"beginner algebra"

Flow:

1. Home search calls ParadeDB
2. Return relevant videos / lessons / courses
3. Show filters and ranked results

### Query inside lesson

"where do they explain factoring visually?"

Flow:

1. Lesson search calls VectorChord
2. Search transcript chunks semantically
3. Return timestamps and snippets

### Hybrid query

"find me all the videos and their timestamps talking about habit formation"

Flow:

1. ParadeDB gets candidate videos
2. VectorChord searches transcript chunks in those videos
3. Group matches by video
4. Return:

- video title
- matching timestamps
- snippets

---

## Why this design works

- simple mental model for users
- simple routing model for engineering
- avoids premature intent-classifier complexity
- supports both discovery and precision lookup
- gives power users an advanced path without cluttering the default UI

## Recommended v1

- **Home = catalog**
- **Lesson = moment**
- **Command palette = hybrid override**
- optionally auto-upgrade obvious timestamp-seeking home queries
