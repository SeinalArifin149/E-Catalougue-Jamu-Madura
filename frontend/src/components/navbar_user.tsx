import React, { useState, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import logoJamu from '../pages/user/Logo jamu madura.png';

const NavbarUser: React.FC = () => {
  const location = useLocation();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);

  // Deteksi scroll untuk mengubah background navbar
  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 20) {
        setIsScrolled(true);
      } else {
        setIsScrolled(false);
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const [activeSection, setActiveSection] = useState('home');

  const scrollToSection = (sectionId: string) => {
    setActiveSection(sectionId);
    if (location.pathname !== '/') {
      window.location.href = '/';
      return;
    }

    if (sectionId === 'home') {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } else if (sectionId === 'catalog') {
      const el = document.getElementById('catalog-section');
      if (el) el.scrollIntoView({ behavior: 'smooth' });
    } else if (sectionId === 'footer') {
      const el = document.querySelector('footer');
      if (el) el.scrollIntoView({ behavior: 'smooth' });
    }
    setIsMobileMenuOpen(false);
  };

  const getBtnStyle = (sectionId: string) => {
    return activeSection === sectionId 
           ? 'bg-[#967515] scale-105 shadow-lg cursor-pointer' 
           : 'bg-[#b58e1b] hover:bg-[#a37f18] hover:scale-105 hover:shadow-lg cursor-pointer';
  };

  return (
    <>
      <style>
        {`
          /* Animasi Masuk (Entrance) */
          @keyframes slideDownFade {
            0% {
              opacity: 0;
              transform: translateY(-30px);
            }
            100% {
              opacity: 1;
              transform: translateY(0);
            }
          }
          .animate-navbar {
            animation: slideDownFade 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
          }
          
          /* Animasi Denyut (Pulse) saat Hover Logo */
          @keyframes pulseSoft {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
          }
          .hover-pulse:hover {
            animation: pulseSoft 1.5s infinite;
          }
        `}
      </style>

      {/* Kontainer Navbar - Fixed mengikuti scroll */}
      <nav className={`fixed top-0 left-0 w-full z-50 px-3 sm:px-8 lg:px-16 flex justify-between items-center animate-navbar transition-all duration-300 ${
        isScrolled ? 'bg-[#FDFBF7]/80 backdrop-blur-md shadow-md py-2 sm:py-3' : 'bg-transparent py-3 sm:py-5'
      }`}>
        
        {/* Kiri: Logo */}
        <Link to="/" className="flex items-center gap-1 sm:gap-4 group min-w-0">
          <div className="w-[52px] h-[62px] sm:w-[85px] sm:h-[95px] overflow-hidden hover-pulse transition-all duration-300 shrink-0">
            <img src={logoJamu} alt="Logo Jamu Madura" className="w-full h-full object-contain drop-shadow-md" />
          </div>
          <div className="flex flex-col text-left font-serif text-[#333] min-w-0">
            <span className="text-[20px] sm:text-[32px] leading-[1.1] drop-shadow-sm transition-colors group-hover:text-[#b58e1b]">JamuMadura</span>
            <span className="text-[20px] sm:text-[32px] leading-[1.1] text-center ml-1 sm:ml-2 drop-shadow-sm transition-colors group-hover:text-[#b58e1b]">Kita</span>
          </div>
        </Link>

        {/* Tengah: Tautan Navigasi (Desktop) */}
        <div className="hidden md:flex items-center gap-6">
          <button 
            onClick={() => scrollToSection('home')}
            className={`px-8 py-2.5 rounded-full text-white font-medium transition-all duration-300 ${getBtnStyle('home')}`}
          >
            Home
          </button>
          <button 
            onClick={() => scrollToSection('catalog')}
            className={`px-8 py-2.5 rounded-full text-white font-medium transition-all duration-300 ${getBtnStyle('catalog')}`}
          >
            Catalog
          </button>
          <button 
            onClick={() => scrollToSection('footer')}
            className={`px-8 py-2.5 rounded-full text-white font-medium transition-all duration-300 ${getBtnStyle('footer')}`}
          >
            Hubungi 
          </button>
        </div>

        {/* Tombol Menu Mobile */}
        <div className="md:hidden">
          <button 
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            className="text-gray-800 p-2 rounded-md hover:bg-white/20 transition-colors focus:outline-none"
            aria-label="Toggle Menu"
          >
            <svg className="w-7 h-7 sm:w-8 sm:h-8 drop-shadow-sm" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              {isMobileMenuOpen ? (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12" />
              ) : (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6h16M4 12h16M4 18h16" />
              )}
            </svg>
          </button>
        </div>
      </nav>

      {/* Dropdown Menu Mobile */}
      <div 
        className={`md:hidden fixed top-[70px] sm:top-[90px] left-0 w-full bg-white/95 backdrop-blur-md shadow-xl z-40 flex flex-col items-center py-5 gap-3 transition-all duration-500 ease-in-out origin-top transform ${isMobileMenuOpen ? 'scale-y-100 opacity-100' : 'scale-y-0 opacity-0 pointer-events-none'}`}
      >
        <button 
          onClick={() => scrollToSection('home')}
          className={`w-3/4 text-center px-8 py-3 rounded-full text-white font-medium transition-all duration-300 ${getBtnStyle('home')}`}
        >
          Home
        </button>
        <button 
          onClick={() => scrollToSection('catalog')}
          className={`w-3/4 text-center px-8 py-3 rounded-full text-white font-medium transition-all duration-300 ${getBtnStyle('catalog')}`}
        >
          Catalog
        </button>
        <button 
          onClick={() => scrollToSection('footer')}
          className={`w-3/4 text-center px-8 py-3 rounded-full text-white font-medium transition-all duration-300 ${getBtnStyle('footer')}`}
        >
          Hubungi
        </button>
      </div>
    </>
  );
};

export default NavbarUser;