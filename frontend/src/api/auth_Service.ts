// 1. Import instance axios kustom milik Abang yang sudah mengarah ke Vercel
import api from "./axiosConfig"; 

export const loginadmin = async (username: string, password: string) => {
    try {
        // 2. Langsung pakai api.post, otomatis URL-nya jadi ke Vercel online
        const response = await api.post("/4dm13n", { username, password });
        
        // 3. Axios otomatis parse JSON, jadi datanya tinggal diambil dari response.data
        return response.data;
    }
    catch (error: any) {
        // 4. Tangkap error response dari Flask (seperti password/username salah)
        if (error.response && error.response.data) {
            throw new Error(error.response.data.message || "No miras no miras");
        }
        throw new Error(error.message || "Gagal terhubung ke server.");
    }
}