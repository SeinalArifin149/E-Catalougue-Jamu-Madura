import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import NavbarUser from '../../components/navbar_user';
import FooterUser from '../../components/footer_user';
import bgImageRight from './Background kanan .png';
import bgImageLeft from './Background hadap kiri.png';
import DetailProduk from './Detail_produk';

// IMPORT SERVICES
import { fetchKatalogJamuPublik, fetchFilterOptionsPublik } from '../../services/user_dashboard'; 

const UserDashboard: React.FC = () => {
  const navigate = useNavigate();
  const searchInputRef = useRef<HTMLInputElement>(null);
  
  const [keluhan, setKeluhan] = useState("");
  const [isFilterOpen, setIsFilterOpen] = useState(false);

  // URL Base backend Vercel online untuk load gambar
  const BASE_BACKEND_URL = 'https://e-catalougue-jamu-madura.vercel.app';

  // State Penampung Data Utama
  const [dataJamu, setDataJamu] = useState<any[]>([]);
  
  // --- STATE LOADING TAMBAHAN ---
  const [loading, setLoading] = useState<boolean>(true);

  // State Menampung daftar menu checkbox dari backend
  const [menuFilters, setMenuFilters] = useState<{ jenis: string[]; kabupaten: string[]; perizinan: string[] }>({
    jenis: [],
    kabupaten: [],
    perizinan: []
  });

  // State Modal Detail Produk
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState<any>(null);

  // State Filter Aktif (Pilihan User)
  const [filterJenis, setFilterJenis] = useState<string[]>([]);
  const [filterAsal, setFilterAsal] = useState<string[]>([]);
  const [filterPerizinan, setFilterPerizinan] = useState<string[]>([]);

  // State untuk Pagination
  const itemsPerPage = 12;
  const [currentPage, setCurrentPage] = useState(1);

  // --- 🛰️ EFFECT: LOAD DATA KATALOG & MENU FILTER SEKALIGUS ---
  useEffect(() => {
    const memuatSemuaData = async () => {
      try {
        setLoading(true); 
        const [hasilKatalog, hasilFilter] = await Promise.all([
          fetchKatalogJamuPublik(),
          fetchFilterOptionsPublik()
        ]);
        
        setDataJamu(hasilKatalog || []);
        setMenuFilters(hasilFilter || { jenis: [], kabupaten: [], perizinan: [] }); 
      } catch (error) {
        console.error("Gagal memuat data publik:", error);
      } finally {
        setLoading(false); 
      }
    };
    memuatSemuaData();
  }, []);

  // --- 🛠️ LOGIKA TOGGLE CHECKBOX FILTER ---
  const handleToggleJenis = (jenis: string) => {
    setFilterJenis((prev) =>
      prev.includes(jenis) ? prev.filter((item) => item !== jenis) : [...prev, jenis]
    );
    setCurrentPage(1); 
  };

  const handleToggleAsal = (asal: string) => {
    setFilterAsal((prev) =>
      prev.includes(asal) ? prev.filter((item) => item !== asal) : [...prev, asal]
    );
    setCurrentPage(1);
  };

  const handleTogglePerizinan = (izin: string) => {
    setFilterPerizinan((prev) =>
      prev.includes(izin) ? prev.filter((item) => item !== izin) : [...prev, izin]
    );
    setCurrentPage(1);
  };

  // --- 🔍 PROSES PENYARINGAN REAL-TIME MULTIPLE CHOICE ---
  const filteredCards = dataJamu.filter((item) => {
    const cocokJenis = filterJenis.length > 0 ? filterJenis.includes(item.nama_jenis) : true;
    const cocokAsal = filterAsal.length > 0 ? filterAsal.includes(item.nama_kabupaten) : true;
    const cocokPerizinan = filterPerizinan.length > 0 ? filterPerizinan.includes(item.nama_perizinan) : true;
    return cocokJenis && cocokAsal && cocokPerizinan;
  });

  // Perhitungan Data Pagination
  const totalPages = Math.ceil(filteredCards.length / itemsPerPage);
  const currentCards = filteredCards.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

  // Efek untuk animasi scroll-in (Intersection Observer)
  useEffect(() => {
    if (loading) return; 

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('show-animate');
        }
      });
    }, { threshold: 0.1 });

    const hiddenElements = document.querySelectorAll('.hide-animate');
    hiddenElements.forEach((el) => observer.observe(el));

    return () => {
      hiddenElements.forEach((el) => {
        if (el) observer.unobserve(el);
      });
    };
  }, [currentCards, loading]);

  const handleCardClick = (product: any) => {
    setSelectedProduct(product);
    setIsModalOpen(true);
  };

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (keluhan.trim() !== "") {
       navigate("/recommendation", { state: { pencarian: keluhan } });
    }
  };

  const scrollToSearch = () => {
    searchInputRef.current?.scrollIntoView({ behavior: 'smooth', block: 'center' });
    setTimeout(() => {
      searchInputRef.current?.focus();
    }, 500);
  };

  return (
    <div className="flex flex-col bg-gray-50">
      
      {/* ================= HERO SECTION ================= */}
      <div 
        className="min-h-screen relative flex flex-col bg-cover bg-center bg-no-repeat overflow-hidden"
        style={{ backgroundImage: `url('${bgImageRight}')` }}
      >
        <div className="absolute inset-0 bg-white/20 sm:bg-transparent pointer-events-none z-0"></div>

        <div className="relative z-50">
          <NavbarUser />
        </div>

        <main className="flex-grow flex flex-col items-center justify-center relative z-10 px-4 sm:px-6 pt-32 pb-16">
          <div className="text-center animate-[slideUpFade_1s_ease-out_forwards] opacity-0 max-w-4xl mx-auto">
            <h1 className="text-[50px] sm:text-[68px] md:text-[84px] font-bold font-serif text-[#111] leading-[1.1] mb-6 drop-shadow-md">
              Selamat Datang di<br />JamuKita
            </h1>
            <p className="text-[18px] sm:text-[20px] md:text-[22px] text-[#333] font-medium leading-relaxed mb-14 drop-shadow-sm max-w-3xl mx-auto">
              Temukan dan Sampaikan jika Anda memiliki keluhan, <br className="hidden md:block"/>
              kami akan memaparkan rekomendasi terbaik dari produk kami
            </p>
          </div>

          <form 
            onSubmit={handleSearch}
            className="flex items-center w-full max-w-[800px] bg-[#757575]/95 backdrop-blur-md rounded-full px-8 py-5 sm:py-6 shadow-2xl animate-[slideUpFade_1s_ease-out_0.3s_forwards] opacity-0 transition-all duration-300 hover:scale-[1.02] focus-within:scale-[1.02] focus-within:ring-4 focus-within:ring-[#b58e1b]/40"
          >
            <button type="submit" className="focus:outline-none group p-1 flex-shrink-0" aria-label="Search">
              <svg className="w-8 h-8 text-black group-hover:scale-110 transition-transform" fill="none" viewBox="0 0 24 24">
                 <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </button>
            
            <input 
              ref={searchInputRef}
              type="text"
              className="flex-grow bg-transparent border-none text-white placeholder-gray-300 px-6 text-[18px] sm:text-[20px] focus:outline-none focus:ring-0"
              placeholder="Masukkan keluhan Anda disini yeah :)"
              value={keluhan}
              // ✅ DIKEMBALIKAN KE FUNGSI ASLINYA BIAR INPUT KELUHAN JALAN NORMAL
              onChange={(e) => setKeluhan(e.target.value)} 
            />
          </form>
        </main>
      </div>

      {/* ================= CATALOG SECTION ================= */}
      <div 
        id="catalog-section"
        className="min-h-screen relative flex flex-col bg-cover bg-fixed bg-center bg-no-repeat py-20 pb-40"
        style={{ backgroundImage: `url('${bgImageLeft}')` }}
      >
        <div className="absolute inset-0 bg-white/30 sm:bg-transparent pointer-events-none z-0"></div>

        <div className="relative z-10 w-full px-4 sm:px-8 lg:px-16 mx-auto flex-grow flex flex-col">
           
            {/* Top Row: Judul Katalog & Tombol Filter */}
            <div className="flex justify-between items-start mb-16 relative min-h-[60px] sm:min-h-[120px] hide-animate">
               <div className="absolute left-1/2 transform -translate-x-1/2 text-center font-serif text-[#111] w-full max-w-2xl pointer-events-none">
                  <h2 className="text-[36px] md:text-[44px] font-bold leading-tight drop-shadow-sm">Daftar Produk</h2>
                  <h2 className="text-[36px] md:text-[44px] font-bold leading-tight drop-shadow-sm">Jamu Madura kita</h2>
               </div>

              <div className={`transition-all duration-500 ease-in-out flex flex-col absolute right-0 z-20 origin-top-right ${isFilterOpen ? 'bg-[#34C759] rounded-[24px] w-[320px] p-8 shadow-2xl' : 'bg-transparent w-auto p-0'}`}>
                 <div className={`flex items-center justify-end gap-8 ${isFilterOpen ? 'mb-8' : 'mb-0'}`}>
                    <button onClick={scrollToSearch} className="text-[24px] font-bold text-[#111] hover:opacity-70 transition-opacity whitespace-nowrap">Cari</button>
                    <button onClick={() => setIsFilterOpen(!isFilterOpen)} className="flex justify-center items-center focus:outline-none" aria-label="Toggle Filter">
                       <div className={`transition-transform duration-500 ease-in-out flex flex-col gap-[6px] ${isFilterOpen ? 'rotate-90' : 'rotate-0'}`}>
                          <div className="w-[32px] h-[5px] bg-[#111] rounded-full"></div>
                          <div className="w-[32px] h-[5px] bg-[#111] rounded-full"></div>
                          <div className="w-[32px] h-[5px] bg-[#111] rounded-full"></div>
                       </div>
                    </button>
                 </div>

                 {/* Dropdown Filter Content */}
                 <div className={`transition-all duration-500 ease-in-out overflow-hidden ${isFilterOpen ? 'opacity-100 max-h-[900px]' : 'opacity-0 max-h-0'}`}>
                    <div className="w-full text-white">
                       <h3 className="text-[26px] font-bold text-[#111] mb-6">Filter Jamu</h3>
                       
                       {/* Filter Jenis */}
                       <div className="mb-6">
                         <h4 className="font-bold text-[#111] text-[18px] mb-3">Jenis</h4>
                         <div className="grid grid-cols-2 gap-y-3 gap-x-3 text-[16px] font-medium text-white">
                            {loading ? (
                              <span className="text-xs italic text-white/60">Memuat...</span>
                            ) : (
                              menuFilters.jenis.map((j) => (
                                <label key={j} className="flex items-center gap-3 cursor-pointer">
                                  <input type="checkbox" checked={filterJenis.includes(j)} onChange={() => handleToggleJenis(j)} className="w-5 h-5 accent-[#111] rounded-sm cursor-pointer" /> {j}
                                </label>
                              ))
                            )}
                         </div>
                       </div>

                       {/* Filter Asal */}
                       <div className="mb-6">
                         <h4 className="font-bold text-[#111] text-[18px] mb-3">Asal</h4>
                         <div className="grid grid-cols-2 gap-y-3 gap-x-3 text-[16px] font-medium text-white">
                            {loading ? (
                              <span className="text-xs italic text-white/60">Memuat...</span>
                            ) : (
                              menuFilters.kabupaten.map((a) => (
                                <label key={a} className="flex items-center gap-3 cursor-pointer">
                                  <input type="checkbox" checked={filterAsal.includes(a)} onChange={() => handleToggleAsal(a)} className="w-5 h-5 accent-[#111] rounded-sm cursor-pointer" /> {a}
                                </label>
                              ))
                            )}
                         </div>
                       </div>

                       {/* Filter Perizinan */}
                       <div>
                         <h4 className="font-bold text-[#111] text-[18px] mb-3">Perizinan</h4>
                         <div className="grid grid-cols-2 gap-y-3 gap-x-3 text-[14px] font-medium text-white">
                            {loading ? (
                              <span className="text-xs italic text-white/60">Memuat...</span>
                            ) : (
                              menuFilters.perizinan.map((p) => (
                                <label key={p} className="flex items-center gap-3 cursor-pointer">
                                  <input type="checkbox" checked={filterPerizinan.includes(p)} onChange={() => handleTogglePerizinan(p)} className="w-5 h-5 accent-[#111] rounded-sm cursor-pointer" /> {p}
                                </label>
                              ))
                            )}
                         </div>
                       </div>
                    </div>
                 </div>
              </div>
           </div>

            {/* Layout Grid Katalog Dinamis */}
            <div className="w-full max-w-[1400px] mx-auto mt-[100px] sm:mt-0 min-h-[350px] flex items-center justify-center flex-col">
              {loading ? (
                <div className="flex flex-col items-center justify-center py-20 gap-4">
                  <div className="w-16 h-16 animate-spin rounded-full border-4 border-gray-200 border-t-[#34C759]"></div>
                  <p className="text-lg font-serif italic text-gray-800 animate-pulse tracking-wide font-medium">
                    Memuat katalog produk Jamu Madura pilihan...
                  </p>
                </div>
              ) : (
                <div className={`transition-all duration-500 ease-in-out grid gap-8 sm:gap-10 justify-items-center justify-center mb-16 w-full
                   ${isFilterOpen ? 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 lg:pr-[360px]' : 'grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-4'}
                `}>
                   {currentCards.length > 0 ? (
                      currentCards.map((item, idx) => (
                        <div 
                          key={item.id_jamu || idx} 
                          className="hide-animate bg-[#eef6ec] w-full max-w-[340px] rounded-[20px] p-4 shadow-lg flex flex-col items-center hover:-translate-y-2 hover:shadow-2xl cursor-pointer transition-all duration-300 border border-green-100" 
                          style={{transitionDelay: `${idx * 0.03}s`}}
                          onClick={() => handleCardClick(item)}
                        >
                          <div className="w-full aspect-[4/5] bg-gradient-to-b from-yellow-100 to-orange-400 rounded-2xl shadow-inner overflow-hidden mb-6 relative flex flex-col items-center justify-center p-2 text-center border-[4px] border-orange-300">
                             {item.image ? (
                                <img 
                                  // ✅ DIUBAH MENEMBAK BASE URL CLOUD VERCEL
                                  src={`${BASE_BACKEND_URL}/static/uploads/${item.image}`} 
                                  alt={item.nama_jamu} 
                                  className="w-full h-full object-cover rounded-xl"
                                />
                             ) : (
                                <>
                                  <span className="text-red-600 font-black text-[22px] leading-tight mb-2 uppercase px-2">{item.nama_jamu}</span>
                                  <span className="text-red-600 font-black text-[14px] leading-tight mb-4 uppercase">{item.nama_jenis || 'Tradisional'}</span>
                                </>
                             )}
                          </div>
                          
                          <div className="w-full text-center flex-grow flex flex-col justify-between">
                             <div>
                                <h3 className="text-gray-900 font-bold text-[22px] mb-2 truncate w-full px-2 capitalize">{item.nama_jamu}</h3>
                                <p className="text-gray-600 text-[16px] font-semibold mb-3 uppercase tracking-wide">{item.nama_jenis || "Jamu Madura"}</p>
                                <span className="inline-block px-4 py-1 bg-green-100 text-green-800 text-[14px] font-bold italic rounded-full shadow-sm">{item.nama_kabupaten || "Lokal"}</span>
                             </div>
                          </div>
                       </div>
                      ))
                   ) : (
                      <div className="col-span-full py-28 text-center text-gray-500 font-medium text-xl italic">
                         Tidak ada jamu yang sesuai dengan filter pilihan, Bang.
                      </div>
                   )}
                </div>
              )}
            </div>

            {/* PAGINATION DYNAMIS */}
            {!loading && totalPages > 1 && (
               <div className="flex justify-center mt-16 mb-20 w-full z-20 relative hide-animate" style={{transitionDelay: '0.1s'}}>
                 <div className="flex items-start font-serif text-[44px] md:text-[56px] font-bold text-[#34C759] select-none">
                    <button 
                       onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                       disabled={currentPage === 1}
                       className={`hover:-translate-x-2 transition-transform mr-6 ${currentPage === 1 ? 'opacity-30 cursor-not-allowed' : 'cursor-pointer'}`}
                    >
                       &lt;
                    </button>
                    
                    <span className="tracking-tight">ja</span>
                    
                    <div className="flex">
                       {Array.from({length: totalPages}).map((_, i) => {
                          const pageNum = i + 1;
                          const isActive = currentPage === pageNum;
                          return (
                             <div key={pageNum} className="flex flex-col items-center cursor-pointer group px-1" onClick={() => setCurrentPage(pageNum)}>
                                <span className={`leading-none tracking-tight transition-colors ${isActive ? 'text-[#34C759]' : 'text-[#34C759]/60 group-hover:text-[#34C759]/80'}`}>m</span>
                                <span className={`text-[20px] md:text-[24px] font-black mt-2 font-sans transition-colors ${isActive ? 'text-black' : 'text-gray-400 group-hover:text-gray-600'}`}>{pageNum}</span>
                             </div>
                          );
                       })}
                    </div>
                    
                    <span className="tracking-tight">u</span>
                    
                    <button 
                       onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
                       disabled={currentPage === totalPages}
                       className={`hover:translate-x-2 transition-transform ml-6 ${currentPage === totalPages ? 'opacity-30 cursor-not-allowed' : 'cursor-pointer'}`}
                    >
                       &gt;
                    </button>
                 </div>
              </div>
           )}
        </div>
      </div>

      <FooterUser />

      <DetailProduk 
        isOpen={isModalOpen} 
        onClose={() => setIsModalOpen(false)} 
        product={selectedProduct} 
      />

      <style>
        {`
          @keyframes slideUpFade {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
          }
          .hide-animate { opacity: 0; transform: translateY(50px); transition: all 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94); }
          .show-animate { opacity: 1 !important; transform: translateY(0) !important; }
        `}
      </style>
    </div>
  );
};

export default UserDashboard;