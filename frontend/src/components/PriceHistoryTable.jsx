import React from "react";

function PriceHistoryTable({ priceHistory, onClose }) {
  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-lg shadow-lg w-full max-w-4xl p-6 relative overflow-auto max-h-full">
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-600 hover:text-gray-800 focus:outline-none"
        >
          ✕
        </button>
        <h3 className="text-xl font-bold mb-4 text-center text-blue-600">
          Price History
        </h3>
        <table className="w-full table-auto border-collapse">
          <thead>
            <tr className="bg-gray-100">
              <th className="px-4 py-2 border-b text-left">Date</th>
              <th className="px-4 py-2 border-b text-left">Price</th>
            </tr>
          </thead>
          <tbody>
            {priceHistory.map((item, index) => (
              <tr key={index} className="hover:bg-gray-50">
                <td className="px-4 py-2 border-b">{item.date}</td>
                <td className="px-4 py-2 border-b">${item.price}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default PriceHistoryTable;
