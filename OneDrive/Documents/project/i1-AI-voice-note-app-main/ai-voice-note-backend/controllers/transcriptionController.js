const fs = require('fs');
const path = require('path');
const axios = require('axios');
const { Readable } = require('stream');
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
    const originalFilename = req.file.originalname || `audio${Date.now()}`;
    
    // Create a readable stream with proper file metadata
    const audioStream = fs.createReadStream(audioPath);
    audioStream.path = originalFilename;
    audioStream.filename = originalFilename;
    
    try {
      // Whisper API call - requires filename for format validation
      const response = await openai.audio.transcriptions.create({
        file: audioStream,
        model: 'whisper-1',
        response_format: 'json',
        temperature: 0.2,
        language: 'en'
      });
      
      // Clean up temp file
      fs.unlink(audioPath, () => {});
      
      // Response shape may vary; be defensive
      const transcript = (response && (response.text || (response.data && response.data.text))) || '';
      return res.json({ transcript });
    } catch (openaiError) {
      // Clean up temp file if OpenAI call fails
      fs.unlink(audioPath, () => {});
      throw openaiError;
    }
  } catch (err) {
    logger.error('Transcription error:', err);
    
    // Provide more helpful error message for unsupported formats
    if (err.message && err.message.includes('Unrecognized file format')) {
      return res.status(400).json({ 
        error: 'Unsupported audio format. Please use one of: mp3, mp4, mpeg, mpga, m4a, ogg, opus, flac, wav, or webm',
        details: err.message
      });
    }
    
    return next(err);
  }
};
