const express = require('express');
const router = express.Router();
const { saveNote, getNotes, deleteNote } = require('../controllers/noteController');
const { authenticate } = require('../middleware/authMiddleware');

// POST /save-note
router.post('/save-note', authenticate, saveNote);

// GET /notes?userId=...
router.get('/notes', authenticate, getNotes);

// DELETE /note/:id
router.delete('/note/:id', authenticate, deleteNote);

module.exports = router;
