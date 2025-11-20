exports.errorHandler = (err, req, res, next) => {
  const status = err.status || 500;
  const payload = { error: err.message || 'Internal Server Error' };
  // Include stack trace only in non-production for debugging
  if (process.env.NODE_ENV !== 'production') {
    payload.details = err.stack;
  }
  res.status(status).json(payload);
};
