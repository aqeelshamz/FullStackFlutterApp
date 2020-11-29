const express = require('express');
const mongoose = require('mongoose');
const app = express();
const dbURL = "mongodb://localhost/fullStack";
const postRoute = require('./routes/posts');

mongoose.connect(dbURL, {useNewUrlParser: true, useUnifiedTopology: true});
const connection = mongoose.connection;
connection.on('open',() => {
    console.log('DB connected!');
});

app.get("/", (req, res) => {
    res.send("welcome to fullStack");
});

app.use(express.json());
app.use("/posts", postRoute);

app.listen(7777, () => {
    console.log("Server started!");
});