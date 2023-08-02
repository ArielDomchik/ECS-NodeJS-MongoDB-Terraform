const express = require('express');
const mongoose = require('mongoose');

const app = express();

// Connect to MongoDB
mongoose
  .connect('mongodb://localhost:27017/mydatabase', { useNewUrlParser: true, useUnifiedTopology: true})
  .then(() => {
    console.log('MongoDB Connected');
    insertInitialData(); // Insert initial data after successful connection
  })
  .catch(err => console.log(err));

const FruitSchema = new mongoose.Schema({
  _id: Number, // Assign _id as Number type with integers starting from 1 and ascending
  name: String,
  qty: Number,
  rating: Number
});

const Fruit = mongoose.model('Fruit', FruitSchema);

function insertInitialData() {
  const fruits = [
    { _id: 1, name: 'apples', qty: 5, rating: 3 },
    { _id: 2, name: 'bananas', qty: 7, rating: 1, microsieverts: 0.1 },
    { _id: 3, name: 'oranges', qty: 6, rating: 2 },
    { _id: 4, name: 'avocados', qty: 3, rating: 5 }
  ];

  Fruit.insertMany(fruits)
    .then(() => console.log('Initial data inserted'))
    .catch(err => console.error('Error inserting initial data:', err));
}

app.get('/', (req, res) => {
  Fruit.findOne({ name: 'apples' })
    .then(fruit => {
      if (!fruit) {
        throw new Error('No fruit found');
      }
      const message = `Hello Octopus! Number of apples: ${fruit.qty}`;
      res.send(message);
    })
    .catch(err => {
      console.error('Error retrieving fruit:', err);
      res.status(500).send('Error retrieving fruit from the database');
    });
});

const port = 3000;

app.listen(port, () => console.log('Server running...'));
