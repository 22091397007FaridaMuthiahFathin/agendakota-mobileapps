/*
const express = require('express');
const router = express.Router();

router.post('/api/data', (req, res) => {
  const data = req.body;
  console.log(`Data diterima: ${JSON.stringify(data)}`);
  if (data.Nama && data.Status) {
    res.send(`Data berhasil diterima dengan nama: ${data.Nama} dan status: ${data.Status}`);
  } else {
    res.send('Data tidak lengkap');
  }
});

router.get('/api/data/status', (req, res) => {
  res.send('Data telah diterima oleh server');
});

module.exports = router;

/*router.get('/data', (req, res) => {
    const data = [
        { id: 1, nama: 'Lady Cristal', email: 'ladycristal.22016@mhs.unesa.ac.id', nomorKTP: '1234567890', status: 'Valid' },
        { id: 2, nama: 'Farida Fathin', email: 'faridamuthiah.22007@mhs.unesa.ac.id', nomorKTP: '1357986420', status: 'Valid' },
        { id: 3, nama: 'Aviana', email: 'aviana.22059@mhs.unesa.ac.id', nomorKTP: '9876543210', status: 'Valid' },
    ];
    res.json(data);
});*/