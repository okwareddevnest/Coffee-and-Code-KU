import React from "react";
import logo from "../assets/images/logo.png";

function Footer() {
  return (
    <footer className="bg-white shadow-inner py-4">
      <div className="container mx-auto flex items-center justify-center">
        <img src={logo} alt="Logo" className="h-6 mr-2" />
        <p className="text-gray-600">&copy; {new Date().getFullYear()} Your Company Name</p>
      </div>
    </footer>
  );
}

export default Footer;
