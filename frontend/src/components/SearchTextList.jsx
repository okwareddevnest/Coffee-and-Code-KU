import React from 'react';

function SearchTextList({ searchTexts, onSearchTextClick }) {
  return (
    <div className="mb-8 max-w-xl mx-auto">
      <h2 className="text-2xl font-semibold mb-4 text-center text-blue-600">
        Recent Searches
      </h2>
      <ul className="grid grid-cols-1 gap-4">
        {searchTexts.map((text, index) => (
          <li key={index}>
            <button
              onClick={() => onSearchTextClick(text)}
              className="w-full text-left px-4 py-3 bg-white border border-gray-200 rounded-md shadow-sm hover:bg-blue-50 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              {text}
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default SearchTextList;
