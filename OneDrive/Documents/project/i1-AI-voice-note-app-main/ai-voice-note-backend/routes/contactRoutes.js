const express = require('express');
const router = express.Router();
const { submitContact } = require('../controllers/contactController');
const { authenticate } = require('../middleware/authMiddleware');

// POST /contact
router.post('/', authenticate, submitContact);

module.exports = router;
