const express = require('express');
const router = express.Router();
const { generateSummary } = require('../controllers/summaryController');
const { authenticate } = require('../middleware/authMiddleware');

// POST /summary
router.post('/', authenticate, generateSummary);

module.exports = router;
