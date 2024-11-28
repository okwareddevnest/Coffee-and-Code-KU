import React, { useEffect, useState } from "react";
import axios from "axios";
import logo from "../assets/images/logo.png";

const URL = "http://localhost:5000";

function TrackedProductList() {
  const [trackedProducts, setTrackedProducts] = useState([]);

  useEffect(() => {
    fetchTrackedProducts();
  }, []);

  const fetchTrackedProducts = async () => {
    try {
      const response = await axios.get(`${URL}/tracked_products`);
      const data = response.data;
      setTrackedProducts(data);
    } catch (error) {
      console.error("Error fetching tracked products:", error);
    }
  };

  return (
    <div className="mb-8 max-w-2xl mx-auto">
      <div className="flex items-center justify-center mb-4">
        <img src={logo} alt="Logo" className="h-16" />
      </div>
      <h2 className="text-2xl font-semibold mb-4 text-center text-blue-600">
        Tracked Products
      </h2>
      {trackedProducts.length > 0 ? (
        <ul className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {trackedProducts.map((product) => (
            <li
              key={product.id}
              className="p-6 bg-white border border-gray-200 rounded-lg shadow-sm"
            >
              <h3 className="text-lg font-bold mb-2">{product.name}</h3>
              <p className="text-gray-700 mb-1">
                Current Price:{" "}
                <span className="font-medium">${product.price}</span>
              </p>
              <p className="text-gray-500 text-sm">
                Last Updated: {product.lastUpdated}
              </p>
            </li>
          ))}
        </ul>
      ) : (
        <p className="text-gray-600 text-center">
          No products are currently being tracked.
        </p>
      )}
    </div>
  );
}

export default TrackedProductList;
