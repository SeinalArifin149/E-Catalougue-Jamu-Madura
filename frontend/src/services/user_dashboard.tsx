import api from '../api/axiosConfig';

// 1. Fungsi ambil katalog jamu (yang sudah ada)
export const fetchKatalogJamuPublik = async () => {
  const allProducts = [];
  let page = 1;
  let totalPages = 1;

  do {
    const response = await api.get('/jamu/public', {
      params: { page, per_page: 100 },
    });
    if (response.data.status !== 'success') {
      throw new Error(response.data.message || 'Katalog tidak tersedia.');
    }

    allProducts.push(...(response.data.data || []));
    totalPages = response.data.pagination?.pages || 1;
    page += 1;
  } while (page <= totalPages);

  return allProducts;
};

// 🔥 2. TAMBAHAN: Fungsi ambil opsi menu filter dari Backend
export const fetchFilterOptionsPublik = async () => {
  const response = await api.get('/jamu/public-filters');
  if (response.data.status !== 'success') {
    throw new Error(response.data.message || 'Filter katalog tidak tersedia.');
  }
  return response.data.data;
};