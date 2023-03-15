const express = require("express");
const jwt = require("jsonwebtoken");
const cookieParser = require("cookie-parser");

const app = express();
const SECRET_KEY = "secret";

// middleware
app.use(express.json());

app.use(cookieParser());

// login
app.post("/api/login", (req, res) => {
  const { account, password } = req.body;

  // Verify account, password here...

  // Generate an access token
  const accessToken = jwt.sign({ sub: account }, SECRET_KEY);

  // Set the access token as an HTTP-only cookie
  res.cookie("access_token", accessToken, { httpOnly: true });

  res.json({ access_token: accessToken });
});

// retrive access_token from cookie and send back to client
app.get("/api/getAccessToken", (req, res) => {
  const accessToken = req.cookies.access_token;

  if (!accessToken) {
    return res.status(401).json({ error: "Access token missing." });
  }

  try {
    const decoded = jwt.verify(accessToken, SECRET_KEY);
    const user = decoded.sub;

    // now you can user data, you can take this to do sth...

    return res.json({ access_token: accessToken });
  } catch (e) {
    return res.status(401).json({ error: "Access token is invalid." });
  }
});

// retrive user data
app.get("/api/data", (req, res) => {
  const tokenHeader = req.headers.authorization;
  const accessToken = tokenHeader && tokenHeader.split(" ")[1];

  if (!accessToken) {
    return res.status(401).json({ error: "Access token missing." });
  }

  try {
    const decoded = jwt.verify(accessToken, SECRET_KEY);
    const user = decoded.sub;

    // now you can user data, you can take this to do sth...
    return res.json({ user: user });
  } catch (e) {
    return res.status(401).json({ error: "Access token is invalid." });
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`app is listening on port: ${PORT}...`);
});
