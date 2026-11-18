// Fetch component: loads all contacts from the backend and displays them
import React, {useState, useEffect} from 'react'
import axios from 'axios'

const Fetch = () =>  {
    // contacts: stores list of all contacts
    // setContacts: replaces list and re-renders when updated
    const [contacts, setContacts] = useState([]) 

    //
    useEffect (() => { // runs once after the first render 
        const fetchContacts = async () => {
            try {
                const res = await axios.get("http://localhost:8080/contact") // send GET request to the backend to get contacts, 
                setContacts(res.data); // save rows into a state so the page updates
            } catch(err) { // print error if it finds one
                console.log(err)
            }
        }
        fetchContacts()
    }, []);
    
    return ( // this allows us to display requested data (from our Fetch method earlier) onto the page
        <div>
            <h1>Contacts</h1>
            {contacts.map((c) => ( // c is each contact tuple/row and you can get an attribute using c.[attribute_name]
                <div className='contacts' key={c.email}>
                    <h2>{c.name}</h2>
                    <p>{c.email}</p>
                </div>
            ))}
        </div>
    )
}

export default Fetch