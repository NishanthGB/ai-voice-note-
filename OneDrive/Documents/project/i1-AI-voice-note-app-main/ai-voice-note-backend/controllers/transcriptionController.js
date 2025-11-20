const fs = require('fs');
const path = require('path');
const axios = require('axios');
const { openai } = require('../config/openaiConfig');
const { logger } = require('../utils/logger');

exports.transcribeAudio = async (req, res, next) => {
  try {
    if (!process.env.OPENAI_API_KEY) {
      return res.status(500).json({ error: 'Server missing OPENAI_API_KEY. Please set it in .env and restart the server.' });
    }
    if (!req.file) {
      return res.status(400).json({ error: 'No audio file uploaded' });
    }
    const audioPath = path.resolve(req.file.path);
    const audioStream = fs.createReadStream(audioPath);

    // Whisper API call
    const response = await openai.audio.transcriptions.create({
      file: audioStream,
      model: 'whisper-1',
      response_format: 'json',
      temperature: 0.2,
      language: 'en'
    });
    fs.unlink(audioPath, () => {}); // Clean up temp file
    // Response shape may vary; be defensive
    const transcript = (response && (response.text || (response.data && response.data.text))) || '';
    return res.json({ transcript });
  } catch (err) {
    logger.error('Transcription error:', err);
    return next(err);
  }
};
