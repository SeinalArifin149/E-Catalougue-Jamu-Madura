import axios from 'axios'

const api = axios.create({
    // 👇 CUKUP GANTI BARIS INI SAJA, BANG 👇
    baseURL: 'https://e-catalougue-jamu-madura.vercel.app/api', 
})

api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('token_jamu')

        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }

        return config;
            
    }, (error) => {
        return Promise.reject(error)
    }
);

api.interceptors.response.use(
    (response) => {
        return response;
    },
    (error) => {
        if (error.response && error.response.status === 401){
            
            // Trik cerdas Abang biar gak mental pas salah input password login
            if (error.config && error.config.url === '/4dm13n') {
                return Promise.reject(error);
            }

            const token = localStorage.getItem('token_jamu')

            if (token) {
                alert ("Sesi telah habis, silahkan login kembali.")
                localStorage.removeItem('token_jamu')
                window.location.href = "/4dm13n"
            } else {
                window.location.href = "/"
            }
            
        }
        return Promise.reject(error);
    }
)

export default api;