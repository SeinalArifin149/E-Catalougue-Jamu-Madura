import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import DetailProduk from "./Detail_produk";
import NavbarUser from "../../components/navbar_user";
import FooterUser from "../../components/footer_user";
import {
  fetchFilterOptionsPublik,
  fetchKatalogJamuPublik,
} from "../../services/user_dashboard";

type Product = {
  id_jamu: number;
  nama_jamu: string;
  khasiat?: string | null;
  image?: string | null;
  nama_jenis?: string;
  id_kategori?: number | null;
  nama_kategori?: string;
  nama_kabupaten?: string;
};

const BASE_BACKEND_URL = "https://e-catalougue-jamu-madura.vercel.app";

const Catalog: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [jenis, setJenis] = useState<string[]>([]);
  const [kategori, setKategori] = useState<{ id_kategori: number; nama_kategori: string }[]>([]);
  const [selectedKategori, setSelectedKategori] = useState("");
  const [selectedJenis, setSelectedJenis] = useState("");
  const [search, setSearch] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);

  useEffect(() => {
    const loadCatalog = async () => {
      setLoading(true);
      setError(null);
      try {
        const [catalog, filters] = await Promise.all([
          fetchKatalogJamuPublik(),
          fetchFilterOptionsPublik(),
        ]);
        setProducts(catalog);
        setJenis(filters.jenis || []);
        setKategori(filters.kategori || []);
      } catch {
        setError("Katalog tidak dapat dimuat. Silakan coba lagi.");
      } finally {
        setLoading(false);
      }
    };
    void loadCatalog();
  }, []);

  const visibleProducts = products.filter((product) => {
    const matchesJenis = !selectedJenis || product.nama_jenis === selectedJenis;
    const matchesKategori =
      !selectedKategori || String(product.id_kategori) === selectedKategori;
    const normalizedSearch = search.trim().toLowerCase();
    const matchesSearch =
      !normalizedSearch ||
      product.nama_jamu.toLowerCase().includes(normalizedSearch);
    return matchesKategori && matchesJenis && matchesSearch;
  });

  return (
    <div className="flex min-h-screen flex-col bg-[#fdfbf7]">
      <NavbarUser />
      <main className="flex-1 px-4 pb-16 pt-32 sm:px-8 lg:px-16">
        <div className="mx-auto w-full max-w-7xl">
          <div className="mb-8 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <p className="mb-2 text-sm font-semibold uppercase tracking-[0.2em] text-[#967515]">
                Katalog resmi
              </p>
              <h1 className="font-serif text-4xl font-bold text-[#222] sm:text-5xl">
                Jamu Madura
              </h1>
              <p className="mt-2 max-w-2xl text-gray-600">
                Data produk ditampilkan langsung dari katalog database.
              </p>
            </div>
            <Link
              to="/"
              className="rounded-full bg-[#b58e1b] px-5 py-3 text-center font-semibold text-white transition hover:bg-[#967515] focus:outline-none focus:ring-2 focus:ring-[#967515] focus:ring-offset-2"
            >
              Kembali ke beranda
            </Link>
          </div>

          <div className="mb-8 grid gap-3 rounded-2xl bg-white p-4 shadow-md sm:grid-cols-[1fr_220px_240px]">
            <label className="flex flex-col gap-2 text-sm font-semibold text-gray-700">
              Cari nama jamu
              <input
                type="search"
                value={search}
                onChange={(event) => setSearch(event.target.value)}
                placeholder="Contoh: Galian Rapat"
                className="min-h-11 rounded-xl border border-gray-300 px-4 text-base font-normal outline-none focus:border-[#967515] focus:ring-2 focus:ring-[#967515]/30"
              />
            </label>
            <label className="flex flex-col gap-2 text-sm font-semibold text-gray-700">
              Filter kategori
              <select
                value={selectedKategori}
                onChange={(event) => setSelectedKategori(event.target.value)}
                className="min-h-11 rounded-xl border border-gray-300 bg-white px-4 text-base font-normal outline-none focus:border-[#967515] focus:ring-2 focus:ring-[#967515]/30"
              >
                <option value="">Semua kategori</option>
                {kategori.map((item) => (
                  <option key={item.id_kategori} value={item.id_kategori}>
                    {item.nama_kategori}
                  </option>
                ))}
              </select>
            </label>
            <label className="flex flex-col gap-2 text-sm font-semibold text-gray-700">
              Filter jenis dari database
              <select
                value={selectedJenis}
                onChange={(event) => setSelectedJenis(event.target.value)}
                className="min-h-11 rounded-xl border border-gray-300 bg-white px-4 text-base font-normal outline-none focus:border-[#967515] focus:ring-2 focus:ring-[#967515]/30"
              >
                <option value="">Semua jenis</option>
                {jenis.map((item) => (
                  <option key={item} value={item}>
                    {item}
                  </option>
                ))}
              </select>
            </label>
          </div>

          {loading && (
            <div className="rounded-2xl bg-white px-6 py-16 text-center shadow-md" role="status">
              Memuat katalog...
            </div>
          )}
          {!loading && error && (
            <div className="rounded-2xl border border-red-200 bg-red-50 px-6 py-10 text-center text-red-800" role="alert">
              {error}
            </div>
          )}
          {!loading && !error && visibleProducts.length === 0 && (
            <div className="rounded-2xl border border-dashed border-gray-300 bg-white px-6 py-16 text-center text-gray-600">
              Tidak ada produk yang sesuai dengan pencarian atau filter.
            </div>
          )}
          {!loading && !error && visibleProducts.length > 0 && (
            <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
              {visibleProducts.map((product) => (
                <button
                  type="button"
                  key={product.id_jamu}
                  onClick={() => setSelectedProduct(product)}
                  className="flex min-h-[310px] flex-col overflow-hidden rounded-2xl bg-white text-left shadow-md transition hover:-translate-y-1 hover:shadow-xl focus:outline-none focus:ring-2 focus:ring-[#967515] focus:ring-offset-2"
                >
                  <div className="flex aspect-[4/3] items-center justify-center bg-gradient-to-br from-yellow-100 to-orange-300 p-3">
                    {product.image ? (
                      <img
                        src={`${BASE_BACKEND_URL}/static/uploads/${product.image}`}
                        alt={product.nama_jamu}
                        className="h-full w-full rounded-xl object-cover"
                      />
                    ) : (
                      <span className="px-4 text-center font-serif text-lg font-bold text-red-700">
                        {product.nama_jamu}
                      </span>
                    )}
                  </div>
                  <div className="flex flex-1 flex-col p-4">
                    <span className="mb-2 text-xs font-bold uppercase tracking-wide text-[#967515]">
                      {product.nama_jenis || "Tanpa jenis"}
                    </span>
                    <h2 className="line-clamp-2 text-lg font-bold text-gray-900">
                      {product.nama_jamu}
                    </h2>
                    <p className="mt-2 line-clamp-3 text-sm text-gray-600">
                      {product.khasiat || "Informasi khasiat tidak tersedia."}
                    </p>
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>
      </main>
      <FooterUser />
      <DetailProduk
        isOpen={selectedProduct !== null}
        onClose={() => setSelectedProduct(null)}
        product={selectedProduct}
      />
    </div>
  );
};

export default Catalog;
