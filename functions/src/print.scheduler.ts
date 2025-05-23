import * as functions from 'firebase-functions/v2';
import * as admin from 'firebase-admin';

export const scheduleDailyPrints = functions.scheduler.onSchedule('0 7 * * *', async () => {
  const today = new Date().toISOString().slice(0, 10);
  const users = await admin.firestore().collection('users').get();
  for (const user of users.docs) {
    const children = await user.ref.collection('children').get();
    for (const child of children.docs) {
      const lessons = await child.ref
        .collection('lessons')
        .where('date', '==', today)
        .get();
      const files: string[] = [];
      lessons.forEach(doc => {
        if (doc.data().attachmentPath) files.push(doc.data().attachmentPath);
      });
      if (files.length) {
        await user.ref.collection('printJobs').add({
          files,
          printer: 'HomePrinter',
          status: 'queued',
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    }
  }
});
