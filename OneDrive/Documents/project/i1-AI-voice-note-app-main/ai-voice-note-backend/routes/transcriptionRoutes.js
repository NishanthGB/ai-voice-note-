const express = require('express');
const router = express.Router();
const multer = require('multer');
const { transcribeAudio } = require('../controllers/transcriptionController');
const { authenticate } = require('../middleware/authMiddleware');

const upload = multer({
	dest: 'uploads/',
	limits: { fileSize: 10 * 1024 * 1024 }, // 10 MB
	fileFilter: (req, file, cb) => {
		// Accept audio mime types only
		if (file.mimetype && file.mimetype.startsWith('audio')) {
			cb(null, true);
		} else {
			cb(new Error('Only audio files are allowed'));
		}
	}
});

// POST /upload
router.post('/', authenticate, upload.single('audio'), transcribeAudio);

module.exports = router;
