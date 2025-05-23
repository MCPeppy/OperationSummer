import * as functions from 'firebase-functions/v2';
import * as admin from 'firebase-admin';
import { google } from 'googleapis';
admin.initializeApp();

const sheetsAuth = new google.auth.GoogleAuth({
  scopes: ['https://www.googleapis.com/auth/spreadsheets'],
});
const SPREADSHEET_ID = process.env.SHEETS_ID;

async function syncChore(uid: string, childId: string, choreId: string, data: any) {
  if (!SPREADSHEET_ID) return;
  const client = await sheetsAuth.getClient();
  const sheets = google.sheets({ version: 'v4', auth: client });
  await sheets.spreadsheets.values.update({
    spreadsheetId: SPREADSHEET_ID,
    range: `${childId}!A2`,
    valueInputOption: 'USER_ENTERED',
    requestBody: { values: [[choreId, data.title, data.status]] },
  });
}

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
  await syncChore(event.params.uid, event.params.childId, event.params.choreId, after);
});
