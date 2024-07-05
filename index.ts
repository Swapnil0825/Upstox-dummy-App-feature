import { Pool } from 'pg';
import express from 'express';
import pool from './database';
import express from 'express';
import routes from './routes';

const pool = new Pool({
  user: 'your_db_user',
  host: 'localhost',
  database: 'upstox',
  password: 'your_db_password',
  port: 5432,
});

export default pool;

const router = express.Router();

router.get('/stock/:symbol', async (req, res) => {
  const { symbol } = req.params;

  try {
    const result = await pool.query('SELECT * FROM stocks WHERE symbol = $1', [symbol]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Stock not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;


const app = express();
const port = 3000;

app.use(express.json());
app.use('/api', routes);

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
