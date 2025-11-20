const { db } = require('../config/firebaseConfig');
const { logger } = require('../utils/logger');

exports.submitContact = async (req, res, next) => {
  try {
    const { email, carbonCopy, subject, description, userId } = req.body;
    if (!email || !subject || !description) {
      return res.status(400).json({ error: 'Missing required fields: email, subject, description' });
    }

    const contact = {
      email,
      carbonCopy: carbonCopy || '',
      subject,
      description,
      userId: userId || null,
      createdAt: new Date().toISOString(),
    };

    const docRef = await db.collection('contacts').add(contact);
    return res.json({ message: 'Contact submitted successfully', contactId: docRef.id });
  } catch (err) {
    logger.error('Contact submit error:', err);
    return next(err);
  }
};
