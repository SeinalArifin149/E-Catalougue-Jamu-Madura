import React, { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  fetchJamuById,
  updateJamu,
  deleteJamu,
  fetchAllJenis,
  fetchAllKabupaten,
  fetchAllProdusen,
  fetchAllLokasiProduksi,
  fetchAllPerizinan
} from '../../services/edit_jamu_service'; 

export default function EditJamu() {
  const { id } = useParams();
  const navigate = useNavigate();
  
  const fileInputRef = useRef<HTMLInputElement>(null);
  const videoRef = useRef<HTMLVideoElement>(null);

  // URL Base backend Vercel online untuk load gambar statis admin
  const BASE_BACKEND_URL = 'https://e-catalougue-jamu-madura.vercel.app';

  const [formData, setFormData] = useState<any>({
    id_jamu: '', nama_jamu: '', khasiat: '', kandungan: '', 
    aturan_minum: '', efek_samping: '', image: '',
    id_perizinan: '', id_jenis: '', id_kabupaten: '', 
    id_produsen: '', id_lokasi_produksi: ''
  });

  const [imagePreview, setImagePreview] = useState('');
  const [isCameraActive, setIsCameraActive] = useState(false);
  const [cameraStream, setCameraStream] = useState<MediaStream | null>(null);

  const [options, setOptions] = useState<any>({
    jenis: [], kabupaten: [], produsen: [], lokasiProduksi: [], perizinan: []
  });

  const [loading, setLoading] = useState(true);

  // 🔥 PERBAIKAN 1: useEffect ini HANYA berjalan sekali saat ID berubah (Anti-reset data!)
  // 🔥 OPTIMASI KILAT: Ambil data Jamu utama secara prioritas, dropdown statis diambil dari Cache LocalStorage
  useEffect(() => {
    const loadAllData = async () => {
      try {
        setLoading(true);

        const dataJamu = await fetchJamuById(Number(id));
        
        if (dataJamu) {
          setFormData({
            ...dataJamu,
            id_perizinan: dataJamu.id_perizinan || '',
            id_jenis: dataJamu.id_jenis || '',
            id_kabupaten: dataJamu.id_kabupaten || '',
            id_produsen: dataJamu.id_produsen || '',
            id_lokasi_produksi: dataJamu.id_lokasi_produksi || ''
          });

          if (dataJamu.image) {
            setImagePreview(`${BASE_BACKEND_URL}/static/uploads/${dataJamu.image}`);
          }
        }

        const cachedOptions = localStorage.getItem('jamu_admin_options_cache');
        
        if (cachedOptions) {
          // Jika cache lokal browser ada, pakai langsung tanpa nembak API backend lagi!
          setOptions(JSON.parse(cachedOptions));
        } else {
          // Jika cache kosong (misal baru pertama kali login), baru unduh pelan-pelan di background
          console.log("Menyusun cache opsi master data dropdown admin baru...");
          const [resJenis, resKabupaten, resProdusen, resLokasi, resPerizinan] = await Promise.all([
            fetchAllJenis(),
            fetchAllKabupaten(),
            fetchAllProdusen(),
            fetchAllLokasiProduksi(),
            fetchAllPerizinan()
          ]);

          const masterOptions = {
            jenis: resJenis || [],
            kabupaten: resKabupaten || [],
            produsen: resProdusen || [],
            lokasiProduksi: resLokasi || [],
            perizinan: resPerizinan || []
          };

          setOptions(masterOptions);
          // Amankan ke local storage selama admin membuka panel
          localStorage.setItem('jamu_admin_options_cache', JSON.stringify(masterOptions));
        }

      } catch (error) {
        console.error('Gagal memuat data halaman edit:', error);
        alert('Terjadi kesalahan saat mengambil data dari server.');
      } finally {
        setLoading(false);
      }
    };

    loadAllData();
  }, [id]); // 🚀 Bersih, cuma dengerin ID jamu

  // 🔥 PERBAIKAN 2: Efek terpisah khusus mengurus pembersihan kamera saat pindah halaman
  useEffect(() => {
    return () => {
      if (cameraStream) {
        cameraStream.getTracks().forEach(track => track.stop());
      }
    };
  }, [cameraStream]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData((prev: any) => ({ ...prev, [name]: value }));
  };

  const aktifkanKamera = async () => {
    try {
      setIsCameraActive(true);
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: { ideal: "environment" } },
        audio: false
      });
      
      setCameraStream(stream);
      // Berikan delay micro-seconds agar elemen <video> sempat muncul di DOM sebelum ditembak stream
      setTimeout(() => {
        if (videoRef.current) {
          videoRef.current.srcObject = stream;
        }
      }, 100);
    } catch (err) {
      console.error("Gagal membuka kamera:", err);
      alert("Gagal mengakses kamera. Pastikan izin kamera sudah diberikan!");
      setIsCameraActive(false);
    }
  };

  const jepretFoto = () => {
    if (videoRef.current) {
      const canvas = document.createElement('canvas');
      // Gunakan resolusi asli video, atau fallback ke 640x480 jika belum termuat sempurna
      canvas.width = videoRef.current.videoWidth || 640;
      canvas.height = videoRef.current.videoHeight || 480;
      
      const ctx = canvas.getContext('2d');
      if (ctx) {
        ctx.drawImage(videoRef.current, 0, 0, canvas.width, canvas.height);
      }
      
      canvas.toBlob((blob) => {
        if (blob) {
          const fileFoto = new File([blob], `jamu_kamera_${Date.now()}.jpg`, { type: 'image/jpeg' });
          
          setFormData((prev: any) => ({ ...prev, image: fileFoto }));
          setImagePreview(URL.createObjectURL(fileFoto)); 
          matikanKamera(); // Amankan jalur stream, matikan kamera setelah jepret sukses
        }
      }, 'image/jpeg');
    }
  };

  const matikanKamera = () => {
    if (cameraStream) {
      cameraStream.getTracks().forEach(track => track.stop());
      setCameraStream(null);
    }
    setIsCameraActive(false);
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const berkas = e.target.files?.[0];
    if (berkas) {
      matikanKamera(); 
      setFormData((prev: any) => ({ ...prev, image: berkas }));
      setImagePreview(URL.createObjectURL(berkas));
    }
  };

  const handleSimpan = async (e: React.FormEvent) => {
    e.preventDefault(); 
    try {
      const payload = new FormData();
      Object.keys(formData).forEach(key => {
        if (formData[key] !== null && formData[key] !== undefined) {
          payload.append(key, formData[key]);
        }
      });

      console.log("Mengirim pembaruan data jamu ke backend...");
      await updateJamu(Number(id), payload);
      
      alert('Data jamu berhasil diperbarui!');
      navigate('/dashboard_4dm13n'); 
    } catch (error) {
      console.error('Detail kesalahan saat menyimpan data:', error);
      alert('Gagal memperbarui data jamu. Silakan periksa kembali koneksi backend Anda.');
    }
  };

  const handleHapus = async () => {
    if (window.confirm('Apakah Anda yakin ingin menghapus data jamu ini?')) {
      try {
        await deleteJamu(Number(id));
        alert('Jamu berhasil dihapus!');
        navigate('/dashboard_4dm13n'); 
      } catch (error) {
        alert('Gagal menghapus data jamu.');
        console.error(error);
      }
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#f4f1de] flex items-center justify-center">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-[#2a4447] border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-xl font-bold text-[#2a4447]">Memuat Data Jamu...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#f4f1de] font-sans text-gray-800 flex flex-col">
      {/* HEADER UTAMA */}
      <header className="bg-[#d9823b] text-white px-6 py-4 flex justify-between items-center shadow-md relative">
        <h1 className="text-2xl font-bold tracking-wide mx-auto">JamuKita</h1>
        <div className="absolute right-6 cursor-pointer">
          <div className="w-10 h-10 rounded-full bg-black flex items-center justify-center text-white font-bold">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor" className="w-6 h-6">
              <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
            </svg>
          </div>
        </div>
      </header>

      {/* SUB-HEADER */}
      <div className="bg-[#2a4447] text-white px-8 py-3 flex gap-8 items-center text-sm font-medium">
        <button type="button" className="flex items-center gap-2 border-b-2 border-amber-500 pb-1">
          <span>📝</span> Edit item
        </button>
      </div>

      {/* KONTEN UTAMA FORM */}
      <main className="flex-1 p-6 md:p-8 max-w-7xl mx-auto w-full">
        <form onSubmit={handleSimpan} className="grid grid-cols-1 lg:grid-cols-12 gap-8">
          
          {/* KOLOM KIRI: KAMERA, IMAGE & ACTIONS */}
          <div className="lg:col-span-4 flex flex-col items-center gap-4">
            <div className="w-full aspect-square max-w-[340px] bg-[#6c757d] rounded-3xl p-2 flex items-center justify-center shadow-inner relative overflow-hidden">
             {isCameraActive ? (
              <video 
                ref={videoRef} 
                autoPlay 
                playsInline 
                className="w-full h-full object-cover rounded-2xl bg-black scale-x-[-1]"
              />
            ) : (
              <img 
                src={imagePreview || 'https://via.placeholder.com/300'} 
                alt={formData.nama_jamu || "Pratinjau Jamu"} 
                className="w-full h-full object-cover rounded-2xl"
              />
            )}
            </div>
            
            <input 
              type="file" 
              ref={fileInputRef} 
              onChange={handleFileChange} 
              accept="image/*" 
              className="hidden" 
            />

            <div className="flex gap-3 w-full max-w-[340px] justify-center">
              {isCameraActive ? (
                <>
                  <button type="button" onClick={jepretFoto} className="bg-[#13802b] hover:bg-green-700 text-white text-xs font-bold px-3 py-2 rounded shadow transition">📸 Jepret Foto</button>
                  <button type="button" onClick={matikanKamera} className="bg-[#8e1919] hover:bg-red-700 text-white text-xs font-bold px-3 py-2 rounded shadow transition">❌ Batal</button>
                </>
              ) : (
                <>
                  <button type="button" onClick={aktifkanKamera} className="bg-[#f1dc34] hover:bg-yellow-400 text-black text-xs font-semibold px-3 py-2 rounded shadow transition">📷 Ambil Foto</button>
                  <button type="button" onClick={() => fileInputRef.current?.click()} className="bg-[#f1dc34] hover:bg-yellow-400 text-black text-xs font-semibold px-3 py-2 rounded shadow transition">🖼️ Unggah Foto</button>
                </>
              )}
            </div>
          </div>

          {/* KOLOM KANAN: INPUT FIELDS */}
          <div className="lg:col-span-8 grid grid-cols-1 md:grid-cols-12 gap-4">
            
            <div className="md:col-span-8 flex flex-col gap-1">
              <label className="text-sm font-bold">Nama Jamu:</label>
              <input type="text" name="nama_jamu" value={formData.nama_jamu} onChange={handleChange} className="bg-[#d9823b] text-white px-3 py-2 rounded font-medium focus:outline-none" required />
            </div>

            <div className="md:col-span-4 flex flex-col gap-1">
              <label className="text-sm font-bold">Id Jamu:</label>
              <input type="text" value={formData.id_jamu} disabled className="bg-[#d9823b] text-white px-3 py-2 rounded font-medium opacity-80 cursor-not-allowed text-center" />
            </div>

            <div className="md:col-span-4 flex flex-col gap-1">
              <label className="text-sm font-bold">Perizinan:</label>
              <select name="id_perizinan" value={formData.id_perizinan} onChange={handleChange} className="bg-[#d9823b] text-white px-3 py-2 rounded font-medium focus:outline-none cursor-pointer">
                <option value="">Pilih Perizinan</option>
                {options.perizinan.map((item: any) => (
                  <option key={item.id_perizinan} value={item.id_perizinan}>{item.nama_perizinan}</option>
                ))}
              </select>
            </div>

            <div className="md:col-span-4 flex flex-col gap-1">
              <label className="text-sm font-bold">Jenis:</label>
              <select name="id_jenis" value={formData.id_jenis} onChange={handleChange} className="bg-[#d9823b] text-white px-3 py-2 rounded font-medium focus:outline-none cursor-pointer">
                <option value="">Pilih Jenis</option>
                {options.jenis.map((item: any) => (
                  <option key={item.id_jenis} value={item.id_jenis}>{item.nama_jenis}</option>
                ))}
              </select>
            </div>

            <div className="md:col-span-4 flex flex-col gap-1">
              <label className="text-sm font-bold">Kabupaten:</label>
              <select name="id_kabupaten" value={formData.id_kabupaten} onChange={handleChange} className="bg-[#d9823b] text-white px-3 py-2 rounded font-medium focus:outline-none cursor-pointer">
                <option value="">Pilih Kabupaten</option>
                {options.kabupaten.map((item: any) => (
                  <option key={item.id_kabupaten} value={item.id_kabupaten}>{item.nama_kabupaten}</option>
                ))}
              </select>
            </div>

            <div className="md:col-span-6 flex flex-col gap-1">
              <label className="text-sm font-bold">Khasiat:</label>
              <textarea name="khasiat" rows={6} value={formData.khasiat} onChange={handleChange} className="bg-[#d9823b] text-white p-3 rounded text-xs leading-relaxed resize-none focus:outline-none"></textarea>
            </div>

            <div className="md:col-span-6 flex flex-col gap-1">
              <label className="text-sm font-bold">Kandungan:</label>
              <textarea name="kandungan" rows={6} value={formData.kandungan} onChange={handleChange} className="bg-[#d9823b] text-white p-3 rounded text-xs leading-relaxed resize-none focus:outline-none"></textarea>
            </div>

            <div className="md:col-span-6 flex flex-col gap-1">
              <label className="text-sm font-bold">Aturan Minum:</label>
              <textarea name="aturan_minum" rows={4} value={formData.aturan_minum} onChange={handleChange} className="bg-white text-black p-3 rounded text-xs border border-gray-300 resize-none focus:outline-none"></textarea>
            </div>

            <div className="md:col-span-6 flex flex-col gap-1">
              <label className="text-sm font-bold text-blue-900 underline decoration-2">Efek Samping:</label>
              <textarea name="efek_samping" rows={4} value={formData.efek_samping} onChange={handleChange} className="bg-white text-black p-3 rounded text-xs border border-gray-300 resize-none focus:outline-none"></textarea>
            </div>

            <div className="md:col-span-6 flex flex-col gap-1">
              <label className="text-sm font-bold">Produsen:</label>
              <select name="id_produsen" value={formData.id_produsen} onChange={handleChange} className="bg-[#d9823b] text-white px-3 py-2 rounded font-medium focus:outline-none cursor-pointer">
                <option value="">Pilih Produsen</option>
                {options.produsen.map((item: any) => (
                  <option key={item.id_produsen} value={item.id_produsen}>{item.nama_produsen}</option>
                ))}
              </select>
            </div>

            <div className="md:col-span-6 flex flex-col gap-1">
              <label className="text-sm font-bold">Lokasi Produksi:</label>
              <select name="id_lokasi_produksi" value={formData.id_lokasi_produksi} onChange={handleChange} className="bg-[#d9823b] text-white px-3 py-2 rounded font-medium focus:outline-none cursor-pointer">
                <option value="">Pilih Lokasi Produksi</option>
                {options.lokasiProduksi.map((item: any) => (
                  <option key={item.id_lokasi_produksi} value={item.id_lokasi_produksi}>{item.nama_lokasi}</option>
                ))}
              </select>
            </div>
          </div>

          {/* FOOTER ACTIONS */}
          <div className="mt-12 flex justify-between items-center border-t border-gray-300 pt-4 w-full col-span-12">
            <button type="button" onClick={() => navigate('/dashboard_4dm13n')} className="bg-[#606a6f] hover:bg-gray-700 text-white px-4 py-2 rounded shadow text-sm font-medium transition">⬅️ Kembali</button>
            <div className="flex gap-3">
              <button type="button" onClick={handleHapus} className="bg-[#8e1919] hover:bg-red-800 text-white px-4 py-2 rounded shadow text-sm font-medium transition">🗑️ Hapus</button>
              <button type="submit" className="bg-[#13802b] hover:bg-green-800 text-white px-4 py-2 rounded shadow text-sm font-medium transition">💾 Simpan</button>
            </div>
          </div>
        </form>
      </main>
    </div>
  );
}