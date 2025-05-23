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
