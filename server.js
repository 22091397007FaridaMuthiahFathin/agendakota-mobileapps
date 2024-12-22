const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const app = express();
const router = express.Router();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Koneksi ke database MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'db_scanner'
});

db.connect(err => {
  if (err) throw err;
  console.log('Terhubung ke database MySQL');
});

// Route untuk menerima data dari Flutter
app.post('/api/scan-ticket', (req, res) => {
  const { id, Nama, No_KTP, Status } = req.body; // Ambil No_KTP
  console.log('Data diterima dari aplikasi:', { id, Nama, No_KTP, Status });

  // Simpan data ke dalam database
  const sql = 'INSERT INTO tb_scanner (id, Nama, No_KTP, Status) VALUES (?, ?, ?, ?)';
  db.query(sql, [id, Nama, No_KTP, Status], (err, result) => {
    if (err) {
      console.error('Error saat menyimpan data ke database:', err); // Logging error
      return res.status(500).send('Gagal menyimpan data ke database');
    }
    res.status(200).send('Data berhasil diterima dan disimpan');
  });
});

app.listen(3000, () => {
  console.log('Server berjalan di port 3000');
});
