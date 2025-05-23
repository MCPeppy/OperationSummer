# Operation Summer – Repo Code Scaffold

> **Purpose:** Concrete starter files & boiler‑plate. Copy‑paste (or programmatically write) each block to its matching path from the portfolio directory tree.

---

## 1  Top‑Level Files

### .gitignore

```gitignore
# Flutter / Dart
.dart_tool/
.packages
.pub/
build/
# Node
functions/node_modules/
print-daemon/node_modules/
# IDE
.idea/
.vscode/
```

### README.md (root)

```markdown
# Operation Summer
Initial scaffolding auto‑generated.  Run `scripts/dev_setup.sh` after cloning.
```

### scripts/dev\_setup.sh

```bash
#!/usr/bin/env bash
set -e
flutter pub get -C app
npm ci -C functions
npm ci -C print-daemon
```

---

## 2  Flutter App (`app/`)

### pubspec.yaml

```yaml
name: operation_summer
description: >-
  Family hub for chores, calendar & summer learning.
version: 0.1.0
environment:
  sdk: ">=3.2.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_storage: ^12.0.0
  google_sign_in: ^7.0.0
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0
  go_router: ^10.0.0
  syncfusion_flutter_calendar: ^23.1.40
  kanban_board: ^1.3.0
  flutter_pdfview: ^2.1.0
  printing: ^6.2.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  riverpod_generator: ^3.0.0
```

### lib/main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: OperationSummerApp()));
}

class OperationSummerApp extends StatelessWidget {
  const OperationSummerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### lib/core/theme.dart

```dart
import 'package:flutter/material.dart';

const seed = Color(0xFF4E8C68);
final appTheme = ThemeData(colorSchemeSeed: seed, useMaterial3: true);
```

### lib/core/router.dart

```dart
import 'package:go_router/go_router.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/chores/chore_board_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/learning/learning_hub_screen.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
  GoRoute(path: '/chores', builder: (_, __) => const ChoreBoardScreen()),
  GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
  GoRoute(path: '/learning', builder: (_, __) => const LearningHubScreen()),
]);
```

### lib/features/chores/models/chore.dart

```dart
class Chore {
  Chore({required this.id, required this.title, required this.points, required this.status});
  final String id;
  final String title;
  final int points;
  String status; // todo | in_progress | done
  Map<String, dynamic> toJson() => {
        'title': title,
        'points': points,
        'status': status,
      };
  factory Chore.fromJson(String id, Map<String, dynamic> json) => Chore(
        id: id,
        title: json['title'],
        points: json['points'],
        status: json['status'],
      );
}
```

*(Repeat similar stub files for Lesson, Child, providers, screens – omitted here for brevity)*

---

## 3  Cloud Functions (`functions/`)

### package.json

```json
{
  "name": "operationsummer-functions",
  "private": true,
  "engines": { "node": "20" },
  "scripts": {
    "build": "tsc",
    "deploy": "firebase deploy --only functions"
  },
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^4.0.0",
    "googleapis": "^133.0.0",
    "pdfkit": "^0.14.0"
  },
  "devDependencies": {
    "typescript": "^5.4.0"
  }
}
```

### tsconfig.json

```json
{
  "compilerOptions": {
    "lib": ["es2021"],
    "module": "commonjs",
    "target": "es2021",
    "outDir": "lib",
    "esModuleInterop": true,
    "strict": true
  },
  "include": ["src"]
}
```

### src/index.ts

```ts
export * from './chores.sync';
export * from './sheets.sync';
export * from './print.enqueue';
export * from './print.scheduler';
```

### src/chores.sync.ts

```ts
import * as functions from 'firebase-functions/v2';
import * as admin from 'firebase-admin';
admin.initializeApp();

export const choreOnWrite = functions.firestore.onDocumentWritten({
  document: 'users/{uid}/children/{childId}/chores/{choreId}'
}, async (event) => {
  const after = event.data?.after.data();
  const before = event.data?.before.data();
  if (!after) return; // deleted
  if (before?.status !== 'done' && after.status === 'done') {
    const points = after.points ?? 0;
    await admin.firestore().doc(`users/${event.params.uid}/children/${event.params.childId}`)
      .update({ points: admin.firestore.FieldValue.increment(points) });
  }
  // TODO: enqueue sheet sync (call helper)
});
```

### src/print.enqueue.ts

```ts
import * as functions from 'firebase-functions/v2';
import * as admin from 'firebase-admin';

export const printAllMaterials = functions.https.onCall(async (data, context) => {
  const { childId, date } = data;
  const uid = context.auth?.uid;
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login!');
  // pull lessons
  const qs = await admin.firestore().collection(`users/${uid}/children/${childId}/lessons`)
    .where('date', '==', date).get();
  const files: string[] = [];
  qs.forEach(doc => { if (doc.data().attachmentPath) files.push(doc.data().attachmentPath); });
  const job = await admin.firestore().doc(`users/${uid}/printJobs`).collection('printJobs').add({
    files,
    printer: 'HomePrinter',
    status: 'queued',
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });
  return { jobId: job.id };
});
```

*(scheduler & sheets sync stub similarly)*

---

## 4  Print Daemon (`print-daemon/`)

### package.json

```json
{ "name": "print-daemon", "type": "module", "dependencies": { "firebase-admin": "^12.0.0", "node-fetch": "^3.5.0" } }
```

### index.js

```js
import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import fetch from 'node-fetch';
import { exec } from 'child_process';
import { createWriteStream } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

initializeApp({ credential: cert(JSON.parse(process.env.SERVICE_ACCOUNT_JSON)) });
const db = getFirestore();
const uid = process.env.USER_ID;
const printer = process.env.DEFAULT_PRINTER;

async function download(url) {
  const res = await fetch(url);
  const file = join(tmpdir(), `${Date.now()}.pdf`);
  await new Promise((r) => res.body.pipe(createWriteStream(file)).on('finish', r));
  return file;
}

db.collection(`users/${uid}/printJobs`).where('status', '==', 'queued')
  .onSnapshot(snap => snap.docChanges().forEach(async change => {
    const ref = change.doc.ref;
    const { files } = change.doc.data();
    await ref.update({ status: 'printing' });
    for (const url of files) {
      const f = await download(url);
      exec(`lp -d ${printer} "${f}"`);
    }
    await ref.update({ status: 'completed' });
  }));
```

### service.install.md

```markdown
1. Copy `print-daemon` to Raspberry Pi.
2. Create `/etc/systemd/system/ops-print.service`:
```

```
[Unit]
Description=Operation Summer Print Daemon
After=network.target

[Service]
Environment=USER_ID=<FIREBASE_UID>
Environment=DEFAULT_PRINTER=HomePrinter
Environment=SERVICE_ACCOUNT_JSON=<json-string>
WorkingDirectory=/home/pi/print-daemon
ExecStart=/usr/bin/node index.js
Restart=always

[Install]
WantedBy=multi-user.target
```

```
3. `sudo systemctl enable --now ops-print`
```

---

## 5  Infra

### firestore.rules

```rules
rules_version = '2';
service cloud.firestore {
  match /databases/{db}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
      match /children/{childId}/{doc=**} {
        allow read, write: if request.auth.uid == uid;
      }
      match /printJobs/{jobId} {
        allow read, write: if request.auth.uid == uid;
      }
    }
  }
}
```

### firestore.indexes.json

```json
{
  "indexes": []
}
```

### env.example

```bash
FIREBASE_PROJECT_ID=operationsummer-prod
GOOGLE_CLIENT_ID_IOS=
GOOGLE_CLIENT_ID_ANDROID=
GOOGLE_CLIENT_ID_WEB=
SHEETS_SPREADSHEET_ID=
DEFAULT_PRINTER=HomePrinter
SERVICE_ACCOUNT_JSON={...}
```

### github/flutter-ci.yml

```yaml
name: Flutter CI
on:
  push:
    branches: [ main ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: subosito/flutter-action@v2
      with: { flutter-version: '3.22.0' }
    - run: flutter pub get -C app
    - run: flutter analyze -C app
    - run: flutter test -C app
```

---

## 6  Next Steps for AI‑Agent

1. Populate remaining Flutter feature files (models, providers, UI) using Clean Architecture template.
2. Flesh out Cloud Function `sheets.sync.ts` (webhook parser + Firestore update) and `print.scheduler.ts` (cron logic).
3. Implement Riverpod provider logic for chore DnD and calendar APIs.
4. Replace placeholder IDs/secrets in `.env` & Firebase config.
5. Run `scripts/dev_setup.sh` and `firebase emulators:start` – ensure app boots and basic Firestore writes succeed.

> **Reminder:** maintain this scaffold as canonical; future AI‑agent generations must only *append* logic, preserving file paths.
