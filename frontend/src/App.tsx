import React from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";

// Import Admin (Kode dari temanmu)
import Login from "./pages/Admin/auth/login";
import Dashboard from "./pages/Admin/dashboard/dashboard";
import AddJamu from "./pages/Admin/add_jamu";
import DetailItem from "./pages/Admin/Detail_item";

// Import User Pages (Kode milikmu)
import UserDashboard from "./pages/user/Dashboard";
// import Catalog from "./pages/user/Catalog";
import Recommendation from "./pages/user/Hasil_pencarian";
import DetailProduk from "./pages/user/Detail_produk";
import KeteranganJamu from "./pages/user/Keterangan_jamu";

import EditJamu from "./pages/Admin/edit_jamu";
const App: React.FC = () => {
  return (
    <Router>
      <Routes>
        {/* Rute User (Milikmu) */}
        <Route path="/" element={<UserDashboard />} />
        <Route path="/recommendation" element={<Recommendation />} />
        <Route path="/detail-produk" element={<DetailProduk />} />
        <Route path="/keterangan-jamu" element={<KeteranganJamu />} />
        <Route path="/admin/edit-jamu/:id" element={<EditJamu />} />

        {/* Rute Admin (Gabungan dengan temanmu) */}
        <Route path="/4dm13n" element={<Login />} />
        <Route path="/dashboard_4dm13n" element={<Dashboard />} />
        <Route path="/admin/add-jamu" element={<AddJamu />} />
        <Route path="/admin/Detail_Item/:id" element={<DetailItem />} />

        {/* Redirect jika path tidak ditemukan */}
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </Router>
  );
};

export default App;