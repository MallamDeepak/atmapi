const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;
const SECRET_KEY = process.env.JWT_SECRET;
const MONGO_URI = process.env.MONGO_URI;
const CORS_ORIGIN = process.env.CORS_ORIGIN || '*';

if (!SECRET_KEY) {
  console.error('✗ Missing JWT_SECRET environment variable');
  process.exit(1);
}

if (!MONGO_URI) {
  console.error('✗ Missing MONGO_URI environment variable');
  process.exit(1);
}

// Middleware
app.use(cors({ origin: CORS_ORIGIN === '*' ? '*' : CORS_ORIGIN.split(',') }));
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

// Database Connection
mongoose
  .connect(MONGO_URI)
  .then(() => {
    console.log('✓ Connected to MongoDB');
  })
  .catch((err) => {
    console.error('✗ MongoDB connection error:', err);
  });

// MongoDB Schemas
const userSchema = new mongoose.Schema({
  fullName: String,
  accountNumber: { type: String, unique: true },
  email: String,
  phone: String,
  faceData: String,
  balance: { type: Number, default: 50000 },
  createdAt: { type: Date, default: Date.now },
});

const transactionSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  fromAccount: String,
  toAccount: String,
  amount: Number,
  type: { type: String, enum: ['transfer', 'deposit', 'withdrawal'] },
  status: { type: String, enum: ['success', 'pending', 'failed'], default: 'success' },
  createdAt: { type: Date, default: Date.now },
});

const User = mongoose.model('User', userSchema);
const Transaction = mongoose.model('Transaction', transactionSchema);

// Helper: Find or create demo user
async function getDemoUser() {
  try {
    let user = await User.findOne({ accountNumber: 'DEMO0001' });
    if (!user) {
      user = await User.create({
        fullName: 'Demo User',
        accountNumber: 'DEMO0001',
        email: 'demo@banking.com',
        phone: '+91 9876543210',
        balance: 50000,
      });
    }
    return user;
  } catch (error) {
    console.error('Error getting demo user:', error);
    return null;
  }
}

// Routes

// Health check
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'Server is running' });
});

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const user = await getDemoUser();
    if (!user) {
      return res.status(400).json({ success: false, message: 'User not found' });
    }

    const token = jwt.sign({ userId: user._id }, SECRET_KEY, {
      expiresIn: '24h',
    });

    res.json({
      success: true,
      message: 'Logged in successfully',
      user: {
        _id: user._id,
        fullName: user.fullName,
        accountNumber: user.accountNumber,
        email: user.email,
        phone: user.phone,
        balance: user.balance,
      },
      token,
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ success: false, message: 'Login failed' });
  }
});

// Face verification
app.post('/api/auth/face-verify', async (req, res) => {
  try {
    const user = await getDemoUser();
    if (!user) {
      return res.status(400).json({ success: false, message: 'User not found' });
    }

    const { capturedFace } = req.body;
    if (!capturedFace) {
      return res.status(400).json({ success: false, message: 'No face data provided' });
    }

    const token = jwt.sign({ userId: user._id }, SECRET_KEY, {
      expiresIn: '24h',
    });

    res.json({
      success: true,
      message: 'Face verified successfully',
      user: {
        _id: user._id,
        fullName: user.fullName,
        accountNumber: user.accountNumber,
        email: user.email,
        phone: user.phone,
        balance: user.balance,
      },
      token,
    });
  } catch (error) {
    console.error('Face verification error:', error);
    res.status(500).json({ success: false, message: 'Face verification failed' });
  }
});

// Get user profile
app.get('/api/user/profile/:accountNumber', async (req, res) => {
  try {
    const { accountNumber } = req.params;
    const user = await User.findOne({ accountNumber });

    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    res.json({
      success: true,
      user: {
        _id: user._id,
        fullName: user.fullName,
        accountNumber: user.accountNumber,
        email: user.email,
        phone: user.phone,
        balance: user.balance,
      },
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch profile' });
  }
});

// Transfer money
app.post('/api/transactions/transfer', async (req, res) => {
  try {
    const { fromAccountNumber, toAccountNumber, amount } = req.body;

    if (!fromAccountNumber || !toAccountNumber || !amount) {
      return res.status(400).json({ success: false, message: 'Missing required fields' });
    }

    const fromUser = await User.findOne({ accountNumber: fromAccountNumber });
    if (!fromUser) {
      return res.status(404).json({ success: false, message: 'From account not found' });
    }

    if (fromUser.balance < amount) {
      return res.status(400).json({ success: false, message: 'Insufficient balance' });
    }

    fromUser.balance -= amount;
    await fromUser.save();

    await Transaction.create({
      userId: fromUser._id,
      fromAccount: fromAccountNumber,
      toAccount: toAccountNumber,
      amount,
      type: 'transfer',
      status: 'success',
    });

    res.json({
      success: true,
      message: 'Transfer successful',
      newBalance: fromUser.balance,
    });
  } catch (error) {
    console.error('Transfer error:', error);
    res.status(500).json({ success: false, message: 'Transfer failed' });
  }
});

// Get transaction history
app.get('/api/transactions/history/:accountNumber', async (req, res) => {
  try {
    const { accountNumber } = req.params;

    const user = await User.findOne({ accountNumber });
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const transactions = await Transaction.find({ userId: user._id }).sort({
      createdAt: -1,
    });

    res.json({
      success: true,
      history: transactions.map((t) => ({
        _id: t._id,
        type: t.type,
        amount: t.amount,
        recipient: t.toAccount,
        timestamp: t.createdAt,
        status: t.status,
      })),
    });
  } catch (error) {
    console.error('Get history error:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch history' });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`\n🚀 Banking API Server running at http://localhost:${PORT}`);
  console.log(`📍 Base URL: http://localhost:${PORT}/api\n`);
});
