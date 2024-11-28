import React from "react";
// Import the logo image
import logo from "../assets/images/logo.png"; // Adjust the path if necessary

function Navbar() {
  return (
    <nav className="bg-white shadow-md">
      <div className="max-w-7xl mx-auto px-4 py-4 flex items-center justify-between">
        {/* Add the logo and title */}
        <div className="flex items-center">
          <img src={logo} alt="Logo" className="h-10 mr-2" />
          <h1 className="text-2xl font-bold text-blue-600">Product Tracker</h1>
        </div>
        {/* Future navigation links can be added here */}
      </div>
    </nav>
  );
}

export default Navbar;
