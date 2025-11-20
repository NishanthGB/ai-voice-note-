const { db } = require('../config/firebaseConfig');
const { logger } = require('../utils/logger');

exports.saveNote = async (req, res, next) => {
  try {
    // Accept corrected_transcript from frontend if available
    const { title, transcript, corrected_transcript, summary, userId } = req.body;
    // Require title, transcript (or corrected_transcript), and userId
    const finalTranscript = corrected_transcript || transcript;
    if (!title || !finalTranscript || !userId) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const note = {
      title,
      // store both raw and corrected (if provided) for traceability
      transcript: transcript || '',
      corrected_transcript: corrected_transcript || '',
      summary: summary || '',
      userId,
      createdAt: new Date().toISOString()
    };

    const docRef = await db.collection('notes').add(note);
    return res.json({ message: 'Note saved successfully', noteId: docRef.id });
  } catch (err) {
    logger.error('Save note error:', err);
    return next(err);
  }
};

exports.getNotes = async (req, res, next) => {
  try {
    const userId = req.query.userId;
    if (!userId) {
      return res.status(400).json({ error: 'userId is required' });
    }
    const snapshot = await db.collection('notes').where('userId', '==', userId).orderBy('createdAt', 'desc').get();
    const notes = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    return res.json(notes);
  } catch (err) {
    logger.error('Get notes error:', err);
    return next(err);
  }
};

exports.deleteNote = async (req, res, next) => {
  try {
    const noteId = req.params.id;
    if (!noteId) {
      return res.status(400).json({ error: 'Note ID is required' });
    }
    await db.collection('notes').doc(noteId).delete();
    return res.json({ message: 'Note deleted successfully' });
  } catch (err) {
    logger.error('Delete note error:', err);
    return next(err);
  }
};
