const express = require("express");
const router = express.Router();
const Post = require("../models/post");

router.get("/", async (req, res) => {
  const data = await Post.find();
  res.json(data);
});

router.post("/", async (req, res) => {
  const data = new Post({
    title: req.body.title,
    body: req.body.body
  });

  await data.save();
  res.send("Post saved!");
});

router.delete("/:id", async(req, res) => {
  await Post.findByIdAndDelete(req.params.id);
  res.send("Post deleted!");
});

module.exports = router;
