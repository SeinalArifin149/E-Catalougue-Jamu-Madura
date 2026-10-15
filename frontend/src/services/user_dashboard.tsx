import api from '../api/axiosConfig';

// 1. Fungsi ambil katalog jamu (yang sudah ada)
export const fetchKatalogJamuPublik = async () => {
  const response = await api.get('/jamu/public');
  if (response.data.status !== 'success') {
    throw new Error(response.data.message || 'Katalog tidak tersedia.');
  }
  return response.data.data || [];
};

// 🔥 2. TAMBAHAN: Fungsi ambil opsi menu filter dari Backend
export const fetchFilterOptionsPublik = async () => {
  const response = await api.get('/jamu/public-filters');
  if (response.data.status !== 'success') {
    throw new Error(response.data.message || 'Filter katalog tidak tersedia.');
  }
  return response.data.data;
};