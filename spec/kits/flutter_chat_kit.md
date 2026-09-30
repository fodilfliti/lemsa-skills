# flutter_chat_kit

Backend-agnostic chat. Replaces the hand-built chats in valizex (Firestore, sqflite, `Map` messages) and lightnessword (Supabase, ReaxDB blob cache).

The detailed design and build order live in the kit's own repo: `flutter_chat_kit/spec/` (package, invariants, decisions D1–D9) and `flutter_chat_kit/spec/tasks/` (T01–T17).

## Owns

- Typed models: sealed `Message` (text, image, video, audio, file, system, custom), `ChatRoom`, `RoomMember` (read pointers), `ChatUser`, `Attachment`, cursors, `ChatEvent`
- Contracts the app implements: `ChatSource`, `ChatUploader`, `ChatUserResolver`
- Built-in Drift cache (one DB per user), per-room sync, keyset paging, offline outbox with retry
- `ChatKit` root; `InboxController`, `ChatRoomController`, `ComposerController` (plain `ChangeNotifier`)
- `ChatRoomView`, `InboxView`, and every sub-widget, replaceable through `ChatBuilders` / `InboxBuilders`
- `ChatStyle` (presets, options, `customize`) building `ChatTheme`; `ChatScale` takes the app's scale factor (`1.w`, `1.sp`) without importing a scale package
- Consumer skill `skills/flutter-chat-kit`, bundled in this repo

## Depends on

`lemsa_core_kit`, `drift`, `drift_flutter`, `super_sliver_list`, media plugins (`cached_network_image`, `image_picker`, `file_picker`, `record`, `audioplayers`, `video_player`).

## Must not depend on

Backend SDKs (`firebase_*`, `cloud_firestore`, `supabase_flutter`, `dio`), Riverpod, slang, `flutter_page_kit`, scale / theme kits.

## Invariants (summary)

- UI reads the cache; only the repository and outbox write it.
- `localId` is the widget key and the `send` idempotency key.
- Kits never localize: `ChatStrings` from the app.
- Apps on Riverpod wrap `ChatKit` in a provider (family rule: realtime lives in providers in the app).
