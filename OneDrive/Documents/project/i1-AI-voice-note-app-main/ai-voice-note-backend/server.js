require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const path = require('path');
const { errorHandler } = require('./middleware/errorHandler');
const { logger } = require('./utils/logger');

const transcriptionRoutes = require('./routes/transcriptionRoutes');
const summaryRoutes = require('./routes/summaryRoutes');
const noteRoutes = require('./routes/noteRoutes');
const contactRoutes = require('./routes/contactRoutes');

const app = express();

// Allow cross-origin requests and explicitly permit the x-api-key header
app.use(cors({
  origin: true,
  allowedHeaders: ['Content-Type', 'x-api-key']
}));
// Limit JSON body size to prevent large payloads
app.use(express.json({ limit: '1mb' }));
app.use(morgan('dev'));

// Health endpoint
app.get('/health', (req, res) => res.json({ status: 'ok' }));

// Friendly root endpoint for uptime monitors and quick checks
app.get('/', (req, res) => {
  res.json({
    name: 'AI Voice Note Backend',
    status: 'ok',
    uptime: process.uptime(),
  });
});

// Routes
app.use('/upload', transcriptionRoutes);
app.use('/summary', summaryRoutes);
app.use('/', noteRoutes);
app.use('/contact', contactRoutes);

// Error handler
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
// Ensure uploads directory exists for multer
const fs = require('fs');
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

// Bind explicitly to 0.0.0.0 so external tools (ngrok) and other hosts can reach the service
const HOST = process.env.HOST || '0.0.0.0';
const server = app.listen(PORT, HOST, () => {
  logger.info(`Server running on ${HOST}:${PORT}`);
});

// Graceful error handling for uncaught exceptions/rejections
process.on('uncaughtException', (err) => {
  logger.error('Uncaught Exception:', err);
  // give a bit of time for logs to flush
  setTimeout(() => process.exit(1), 100);
});

process.on('unhandledRejection', (reason, p) => {
  logger.error('Unhandled Rejection at:', p, 'reason:', reason);
  setTimeout(() => process.exit(1), 100);
});
