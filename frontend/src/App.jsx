import React, { useState, useEffect } from "react";
import SearchTextList from "./components/SearchTextList";
import PriceHistoryTable from "./components/PriceHistoryTable";
import axios from "axios";
import TrackedProductList from "./components/TrackedProductList";
import './App.css';
import { FaSearch } from "react-icons/fa";
import Navbar from "./components/Navbar";
import logo from "./assets/images/logo.png";
import Footer from "./components/Footer";

const URL = "http://localhost:5000";

function App() {
  const [showPriceHistory, setShowPriceHistory] = useState(false);
  const [priceHistory, setPriceHistory] = useState([]);
  const [searchTexts, setSearchTexts] = useState([]);
  const [newSearchText, setNewSearchText] = useState("");

  useEffect(() => {
    fetchUniqueSearchTexts();
  }, []);

  const fetchUniqueSearchTexts = async () => {
    try {
      const response = await axios.get(`${URL}/unique_search_texts`);
      const data = response.data;
      setSearchTexts(data);
    } catch (error) {
      console.error("Error fetching unique search texts:", error);
    }
  };

  const handleSearchTextClick = async (searchText) => {
    try {
      const response = await axios.get(
        `${URL}/results?search_text=${searchText}`
      );

      const data = response.data;
      setPriceHistory(data);
      setShowPriceHistory(true);
    } catch (error) {
      console.error("Error fetching price history:", error);
    }
  };

  const handlePriceHistoryClose = () => {
    setShowPriceHistory(false);
    setPriceHistory([]);
  };

  const handleNewSearchTextChange = (event) => {
    setNewSearchText(event.target.value);
  };

  const handleNewSearchTextSubmit = async (event) => {
    event.preventDefault();

    try {
      await axios.post(`${URL}/start-scraper`, {
        search_text: newSearchText,
        url: "https://amazon.ca",
      });

      alert("Scraper started successfully");
      setSearchTexts([...searchTexts, newSearchText]);
      setNewSearchText("");
    } catch (error) {
      alert("Error starting scraper:", error);
    }
  };

  return (
    <div className="main bg-gray-50 min-h-screen flex flex-col">
      <Navbar />
      <div className="flex-grow">
        <div className="container mx-auto p-6">
          <header className="mb-8">
            <div className="flex flex-col items-center">
              <img src={logo} alt="Logo" className="h-20 max-w-xs mb-4" />
              <h1 className="text-4xl font-bold text-center text-blue-600 mb-2">
                Product Search Tool
              </h1>
              <p className="text-center text-gray-700 mb-6">
                Track and monitor product prices effortlessly.
              </p>
            </div>
          </header>
          <form onSubmit={handleNewSearchTextSubmit} className="mb-8 max-w-xl mx-auto">
            <label className="block text-lg font-medium text-gray-700 mb-2">
              Search for a new item:
            </label>
            <div className="flex items-center">
              <input
                type="text"
                value={newSearchText}
                onChange={handleNewSearchTextChange}
                className="flex-grow px-4 py-2 border border-gray-300 rounded-l-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Enter product name"
              />
              <button
                type="submit"
                className="px-6 py-2 bg-blue-600 text-white font-semibold rounded-r-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <FaSearch />
              </button>
            </div>
          </form>
          <SearchTextList
            searchTexts={searchTexts}
            onSearchTextClick={handleSearchTextClick}
          />
          <TrackedProductList />
          {showPriceHistory && (
            <PriceHistoryTable
              priceHistory={priceHistory}
              onClose={handlePriceHistoryClose}
            />
          )}
        </div>
      </div>
      <Footer />
    </div>
  );
}

export default App;
