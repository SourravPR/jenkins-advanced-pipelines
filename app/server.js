const express = require('express');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    user: os.userInfo().username,
    uid: os.userInfo().uid,
    hostname: os.hostname(),
    nodeVersion: process.version
  });
});

app.get('/', (req, res) => {
  res.send('Hardened Container Service Running');
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server listening on port ${PORT} as user ${os.userInfo().username}`);
});
