import logo from './logo.svg';
import './style.css';

import { // import routes for requesting/getting data
  BrowserRouter,
  Routes,
  Route
} from 'react-router-dom'

// import pages for frontend pages (make sure name is different than the route names)
import Fetch from "./pages/fetch";
import Add from "./pages/add";
import Update from "./pages/update";

function App() {
  return ( // allow for page to update based on path
    <div className="App">
      <BrowserRouter> 
        <Routes>
          <Route path="/" element={<Fetch/>}/>
          <Route path="/add" element={<Add/>}/>
          <Route path="/update" element={<Update/>}/>
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
