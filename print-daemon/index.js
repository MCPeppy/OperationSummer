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
