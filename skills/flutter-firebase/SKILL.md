---
name: flutter-firebase
description: >
  Firebase Auth, Firestore, Storage, Messaging in Lemsa apps. Use with hybrid
  backends, flutter_data_kit_firebase, or migrating Firebase auth to Supabase.
license: MIT
metadata:
  author: fodilfliti
  version: "1.0.0"
---

# Flutter Firebase (Lemsa)

Versions: `firebase_core` 4.14.0, `cloud_firestore` 6.9.0 (check pub.dev for patch).

## When

- `lemsa.yaml` `backend: firebase` or `hybrid`
- kiwash pattern: Firebase Auth JWT → Dio bearer → REST API

## Adapter

`flutter_data_kit_firebase` maps `FirebaseException` / `FirebaseAuthException` → `AppFailure`.

## Auth stream

`FirebaseAuth.instance.authStateChanges()` → session StreamNotifier.

## Firestore

Queries live in source classes — not in widgets or controller mixins. Realtime listeners in StreamNotifiers (chat).

## Storage

Uploads through repository; optional step failures warn-and-continue in controller submit.

## Messaging

FCM token registration via repository after login — same as kiwash `updateToken`.

## Do not

- Keep dual Firebase+Supabase auth paths without `hybrid` adapter selection
- Use Firestore from controller mixins
- Hardcode google-services without flavors
