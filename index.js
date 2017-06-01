
const express = require("express")
const path = require("path")
const favicon = require("serve-favicon")

const app = express()

app.use(express.static(path.join(__dirname, "public")))
app.use(favicon(path.join(__dirname, "public", "favicon.ico")))

app.use((req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>US 2016 Presidential General Election Results</title>
        <link rel="stylesheet" href="fiber.min.css" />
      </head>
      <body class="m0">
        <div id="app"></div>
        <script src="app.js"></script>
      </body>
    </html>
  `)
})

const PORT = process.env.PORT

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`)
})
