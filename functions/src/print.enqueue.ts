import * as functions from 'firebase-functions/v2';
import * as admin from 'firebase-admin';

export const printAllMaterials = functions.https.onCall(async (data, context) => {
  const { childId, date } = data;
  const uid = context.auth?.uid;
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Login!');
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
