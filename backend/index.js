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

// read data
app.get("/asdf", (req, res)=>{
    const q = "SELECT * FROM contact;"
    db.query(q, (err,data)=> {
        if (err) return res.json(err)
        return res.json(data)
    })
})

app.listen(8080, ()=>{
    console.log("Connected to backend")
})

