import express from "express"
import mysql from "mysql2"
import cors from "cors"

const app = express()

app.get("/", (req,res)=>{
    res.json("hello this is the backend")
})

app.use(express.json())
app.use(cors())

const db = mysql.createConnection({
    host:"localhost",
    user:"root",
    password:"changeme",
    database:"cellarconstitution"
})

// read data from database 
app.get("/inventory", (req, res)=>{
    const q = "SELECT * FROM contact;" // run selection query and store as a variable
    db.query(q, (err,data)=> { // execute query, return err if failed, otherwise, return th selected rows, both as json
        if (err) return res.json(err) 
        return res.json(data)
    })
})

// update (use a different tab/page for now)1
app.post("/inventory", (req, res)=>{
    const q = "INSERT INTO contact (`email`, `phone_number`, `name`, `address`, `email_opt_out`) VALUES (?);" // use (?) instead of inserting actual vals
    const vals = [req.body.email, req.body.phone_number, req.body.name, req.address, req.email_opt_out ?? false] // store values that are being requested to add by user 
    db.query(q, [vals], (err, data) => {
        if (err) return res.json(err) // execute query, return err if failed, otherwise, return th selected rows, both as json
        return res.json("Successfully added contact")
    })
}) 

app.listen(8080, ()=>{
    console.log("Connected to backend")
})

