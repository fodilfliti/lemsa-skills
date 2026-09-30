# flutter_chat_kit

**Job:** a complete chat (inbox + chat room) on **any backend**, with an offline SQLite cache, a persistent send queue, media stored on disk, and easy styling.

**Not its job:** talking to a specific backend (the app implements `ChatSource`), state management (plain `ChangeNotifier` controllers; apps may wrap them in Riverpod), translations (the app fills `ChatStrings`), or screen scaling math (the app passes its factor through `ChatScale`).

Status: **local**, 0.1.0 ready; publish pending owner. Repo: [fodilfliti/flutter_chat_kit](https://github.com/fodilfliti/flutter_chat_kit).

## Why it exists

The reference apps each hand-built a chat: one on Firestore with `Map` messages and sqflite, one on Supabase with a blob cache. Both mixed backend calls into widgets, lost messages sent offline, and jumped when older pages loaded. This kit keeps the hard parts (cache, sync, ordering, outbox, scroll stability) in one tested place and leaves the backend to a small adapter.

## What it does exactly

- Typed models: sealed `Message` (text, image, video, audio, file, system, custom), `ChatRoom`, read pointers, cursors, `ChatEvent`.
- Contracts the app implements: `ChatSource` (or `ComposedChatSource(data:, realtime:)` to mix REST with Firebase / Supabase / WebSocket realtime), `ChatUploader`, `ChatUserResolver`.
- `ChatKit`: one per signed-in user. Drift cache (one DB per user), keyset paging both ways, gap fill on reconnect, optimistic outbox with retry and backoff that survives restarts.
- Controllers: `InboxController` (one per list: filters, search, unread total), `ChatRoomController`, `ComposerController`.
- Screens: `InboxView`, `ChatRoomView`; every part replaceable with builders that receive the default widget.
- Several profiles per account (`ChatProfileSwitcher`), businesses answered by staff (`agentId` → `Message.sentBy`).
- Styling: `ChatStyle` (presets, simple options, `customize`) builds the `ChatTheme`; `ChatScale` scales it with any screen-size package.

## Architecture

```text
app ChatSource (Firestore / Supabase / REST / WS)
        │
        ▼
ChatKit ── ChatRepository ── DriftChatCache (SQLite)
   │             │
   │           Outbox (retry, backoff)
   ▼
InboxController / ChatRoomController
        │
        ▼
InboxView / ChatRoomView  ◄── ChatStyle (look + scale)
```

Widgets read the cache only; only the repository and outbox write it.

## With scale and theme kits

The chat does not import `flutter_scale_kit` or `flutter_scale_theme_kit`:

- **Size:** `ChatStyle(scale: (context) => ChatScale(1.w, text: 1.sp))`. `14.w == 14 × 1.w`, so chat sizes equal `.w` on the same design numbers, and fonts equal `.sp`. Re-read on every resize and rotation.
- **Look:** the chat follows `ThemeData` colors and dark mode, so `appST.light` / `appST.dark` apply with no code; tokens (`context.st.primary`, `st.radius.lgValue`) can be passed to `ChatStyle`.

## Depends on

`lemsa_core_kit`, `drift`, `drift_flutter`, `super_sliver_list`, media plugins (`image_picker`, `file_picker`, `record`, `audioplayers`, `video_player`, ...).

## Must not depend on

Backend SDKs, Riverpod, slang, scale / theme kits, other Lemsa UI kits.

## Related

- Consumer skill: `skills/flutter-chat-kit` (bundled)
- Short design: [../../spec/kits/flutter_chat_kit.md](../../spec/kits/flutter_chat_kit.md)
- Size: [flutter_scale_kit.md](flutter_scale_kit.md) · Look: [flutter_scale_theme_kit.md](flutter_scale_theme_kit.md)
