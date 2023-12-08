const express = require('express');
const app = express ();
const PORT = 3056;
app.use(express.json());

app.listen(PORT, () => {
  console.log("Server Listening on PORT: ", PORT );
});

//response.send(status) is now a function that takes the JSON object as the argument.

app.get("/status", (req, res) => {
   console.log("Nouvel appel sur /status");
   const res200 = {
      "Status": "Running",
      "Date": new Date
   };
   res.cookie('CookTest', 'voila voila');
   res.cookie('CookTestPlus', 'voila.plus.voila');
   //res.setHeader('Content-Type', 'application/json');
   //res.status(200).send(res200);
   //res.status(200).json(status);
   res.writeHead(200, {'Content-Type': 'application/json'}); 
   res.write(JSON.stringify(res200));
   //res.send(status);
   res.end();
});

app.get("/secondAppel", (req, res) => {
   console.log("Nouvel appel sur /secondAppel");
   console.log(JSON.stringify(req.headers));
   const res200 = {
      "Status": "request"
   };
   res.writeHead(200, {'Content-Type': 'application/json'});
   res.write(JSON.stringify(res200));
   //res.send(status);
   res.end();
});
