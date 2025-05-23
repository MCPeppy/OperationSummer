import * as functions from 'firebase-functions/v2';
import * as admin from 'firebase-admin';

const SECRET = process.env.SHEETS_TOKEN;

export const sheetsWebhook = functions.https.onRequest(async (req, res) => {
  const token = req.get('x-sheets-token');
  if (!SECRET || token !== SECRET) {
    res.status(401).send('Unauthorized');
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }
  try {
    const { uid, childId, choreId, updates } = req.body;
    if (!uid || !childId || !choreId || !updates) {
      res.status(400).send('Missing fields');
      return;
    }
    await admin
      .firestore()
      .doc(`users/${uid}/children/${childId}/chores/${choreId}`)
      .update(updates);
    res.json({ status: 'ok' });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});
