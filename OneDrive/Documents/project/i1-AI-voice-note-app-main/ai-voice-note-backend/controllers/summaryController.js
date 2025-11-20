const { openai } = require('../config/openaiConfig');
const { logger } = require('../utils/logger');

exports.generateSummary = async (req, res, next) => {
  try {
    if (!process.env.OPENAI_API_KEY) {
      return res.status(500).json({ error: 'Server missing OPENAI_API_KEY. Please set it in .env and restart the server.' });
    }
    const { transcript } = req.body;
    if (!transcript) {
      return res.status(400).json({ error: 'Transcript is required' });
    }
    // Prompt asks the model to first correct/clean the transcript (fix translation/grammar),
    // then produce a parsed JSON containing corrected transcript, a short title, a concise summary,
    // and an array of action items. The API consumer expects strictly valid JSON.
    const prompt = `You will be given a transcript of spoken audio. First, correct any translation or grammar issues and return the cleaned, corrected transcript. Then, generate a short title, a concise summary paragraph, and an array of action items derived from the transcript. Respond ONLY with a single valid JSON object with the following keys:\n- corrected_transcript: string\n- title: string\n- summary: string\n- action_items: array of strings\n\nTranscript:\n${transcript}\n\nMake the corrected_transcript natural, preserve speaker content, and keep the meaning. Output only JSON.`;

    const completion = await openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        { role: 'system', content: 'You are a helpful assistant that corrects transcripts and extracts summaries and action items.' },
        { role: 'user', content: prompt }
      ],
      temperature: 0.2,
      max_tokens: 800
    });
    const choices = completion?.choices || completion?.data?.choices;
    if (!choices?.length || !choices[0]?.message?.content) {
      logger.error('OpenAI summary returned unexpected payload', completion);
      return res.status(502).json({ error: 'AI summary failed: unexpected response format' });
    }
    const text = choices[0].message.content;
    let json;
    try {
      json = JSON.parse(text);
    } catch (e) {
      logger.error('Failed to parse summary JSON, attempting JSON substring parse. Raw response:', text);
      const first = text.indexOf('{');
      const last = text.lastIndexOf('}');
      if (first !== -1 && last !== -1 && last > first) {
        const sub = text.substring(first, last + 1);
        try {
          json = JSON.parse(sub);
        } catch (e2) {
          logger.error('JSON substring parse also failed');
          return res.status(500).json({ error: 'AI did not return valid JSON', raw: text });
        }
      } else {
        return res.status(500).json({ error: 'AI did not return valid JSON', raw: text });
      }
    }

    // Normalize keys for backward compatibility: map old keys if present
    if (!json.title && json.summary && json.action_items) {
      // okay
    }

    return res.json(json);
  } catch (err) {
    if (err?.response?.status) {
      const status = err.response.status;
      const message = err.response.data?.error?.message || 'OpenAI API error';
      logger.error(`Summary error (OpenAI ${status}):`, message);
      return res.status(status).json({ error: message });
    }
    logger.error('Summary error:', err);
    return next(err);
  }
};
