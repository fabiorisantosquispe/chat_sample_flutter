const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send({ response: "O servidor está instalado e funcionando." }).status(200);
});

module.exports = router;