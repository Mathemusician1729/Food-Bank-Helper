import express from "express"
import mysql from "mysql2"
import cors from "cors"
import "dotenv/config"

const app = express()

app.get("/", (req,res)=>{
    res.json("hello this is the backend")
})

app.use(express.json())
app.use(cors())

const db = mysql.createConnection({
    host:"localhost",
    user:"root",
    password:process.env.DB_PASSWORD,
    database:"cellarconstitution"
})

app.listen(8080, ()=>{
    console.log("Connected to backend")
})

// test database connection
db.connect((err) => {if (err) {console.error("DB connection failed"), err.code, err.message} console.log('connected to database success')})