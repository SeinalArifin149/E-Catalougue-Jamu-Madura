-- PRAGMA foreign_keys=OFF;
-- BEGIN TRANSACTION;
    CREATE TABLE kabupaten (
        id_kabupaten INTEGER PRIMARY KEY, --AUTOINCREMENT,
        nama_kabupaten TEXT NOT NULL
    );
    INSERT INTO kabupaten VALUES(1,'sampang');
    INSERT INTO kabupaten VALUES(2,'bangkalan');
    INSERT INTO kabupaten VALUES(3,'pamekasan');
    INSERT INTO kabupaten VALUES(4,'sumenep');
    CREATE TABLE jenis (
        id_jenis INTEGER PRIMARY KEY, --AUTOINCREMENT,
        nama_jenis TEXT NOT NULL
    );
    INSERT INTO jenis VALUES(1,'pil');
    INSERT INTO jenis VALUES(2,'cair');
    INSERT INTO jenis VALUES(3,'serbuk');
    INSERT INTO jenis VALUES(4,'serbuk dan pil');
    INSERT INTO jenis VALUES(5,'selai');
    INSERT INTO jenis VALUES(6,'cair dan serbuk');
    INSERT INTO jenis VALUES(7,'kapsul');
    INSERT INTO jenis VALUES(8,'krim');
    CREATE TABLE perizinan (
        id_perizinan INTEGER PRIMARY KEY, --AUTOINCREMENT,
        nama_perizinan TEXT NOT NULL
    );
    INSERT INTO perizinan VALUES(1,'kemenkes');
    INSERT INTO perizinan VALUES(2,'bpom');
    INSERT INTO perizinan VALUES(3,'p-irt');
    INSERT INTO perizinan VALUES(4,'tdi & ukot');
    CREATE TABLE lokasi_pemasaran (
        id_lokasi_pemasaran INTEGER PRIMARY KEY, --AUTOINCREMENT,
        nama_lokasi_pemasaran TEXT NOT NULL
    );
    INSERT INTO lokasi_pemasaran VALUES(1,'jl pahlawan 21 sampang');
    INSERT INTO lokasi_pemasaran VALUES(2,'burneh');
    INSERT INTO lokasi_pemasaran VALUES(3,'se-madura');
    INSERT INTO lokasi_pemasaran VALUES(4,'bangkalan');
    INSERT INTO lokasi_pemasaran VALUES(5,'se-indonesia');
    INSERT INTO lokasi_pemasaran VALUES(6,'madura dan sekitarnya');
    INSERT INTO lokasi_pemasaran VALUES(7,'bangkalan, kamal, tanjung bumi, arosbaya');
    INSERT INTO lokasi_pemasaran VALUES(8,'madura, luar jawa');
    INSERT INTO lokasi_pemasaran VALUES(9,'madura');
    INSERT INTO lokasi_pemasaran VALUES(10,'hingga luar madura');
    INSERT INTO lokasi_pemasaran VALUES(11,'online (se-indonesia)');
    INSERT INTO lokasi_pemasaran VALUES(12,'sampang');
    INSERT INTO lokasi_pemasaran VALUES(13,'tromol pos 01 bangkalan');
    INSERT INTO lokasi_pemasaran VALUES(14,'luar indonesia');
    INSERT INTO lokasi_pemasaran VALUES(15,'online');
    INSERT INTO lokasi_pemasaran VALUES(16,'indonesia');
    CREATE TABLE produsen (
        id_produsen INTEGER PRIMARY KEY, --AUTOINCREMENT,
        nama_produsen TEXT NOT NULL,
        id_kabupaten INTEGER,
        FOREIGN KEY (id_kabupaten) REFERENCES kabupaten(id_kabupaten)
    );
    INSERT INTO produsen VALUES(1,'madura sari',NULL);
    INSERT INTO produsen VALUES(2,'jamu tradisional madura',NULL);
    INSERT INTO produsen VALUES(3,'jamu assegaf',NULL);
    INSERT INTO produsen VALUES(4,'jamu intan',NULL);
    INSERT INTO produsen VALUES(5,'sari madu',NULL);
    INSERT INTO produsen VALUES(6,'firdaus kurnia indah',NULL);
    INSERT INTO produsen VALUES(7,'kampung paseraman kamal',NULL);
    INSERT INTO produsen VALUES(8,'njonja boolan',NULL);
    INSERT INTO produsen VALUES(9,'jamu pusaka kraton cakraningrat',NULL);
    INSERT INTO produsen VALUES(10,'jamu putri bangkalan',NULL);
    INSERT INTO produsen VALUES(11,'mustika madura',NULL);
    INSERT INTO produsen VALUES(12,'pj. alam insani herbal',NULL);
    INSERT INTO produsen VALUES(13,'toko nur',NULL);
    INSERT INTO produsen VALUES(14,'toko bu ema',NULL);
    INSERT INTO produsen VALUES(15,'warda',NULL);
    INSERT INTO produsen VALUES(16,'toko anggrek',NULL);
    INSERT INTO produsen VALUES(17,'ratohqu',NULL);
    INSERT INTO produsen VALUES(18,'tresna',NULL);
    INSERT INTO produsen VALUES(19,'naturna',NULL);
    INSERT INTO produsen VALUES(20,'pt. firdaus',NULL);
    INSERT INTO produsen VALUES(21,'ribkah maryam jokotole',NULL);
    INSERT INTO produsen VALUES(22,'wahyu sejati',NULL);
    INSERT INTO produsen VALUES(23,'ibu masturah',NULL);
    INSERT INTO produsen VALUES(24,'h. mifki',NULL);
    INSERT INTO produsen VALUES(25,'pt.qomar jaya nusantara',NULL);
    INSERT INTO produsen VALUES(26,'karya ibu abdullah',NULL);
    INSERT INTO produsen VALUES(27,'ud.mustika bani',NULL);
    INSERT INTO produsen VALUES(28,'pd sakera madura',NULL);
    INSERT INTO produsen VALUES(29,'jku super',NULL);
    INSERT INTO produsen VALUES(30,'jokotole',NULL);
    INSERT INTO produsen VALUES(31,'ud. simpang tiga',NULL);
    INSERT INTO produsen VALUES(32,'ny. hj hayati',NULL);
    INSERT INTO produsen VALUES(33,'jkm',NULL);
    INSERT INTO produsen VALUES(34,'cv.wahyu illahi',NULL);
    INSERT INTO produsen VALUES(35,'berkah madu/sumber madu',NULL);


    --  bts
CREATE TABLE lokasi_produksi (
    id_lokasi_produksi INTEGER PRIMARY KEY , --AUTOINCREMENT,
    nama_lokasi TEXT NOT NULL,
    id_kabupaten INTEGER,
    FOREIGN KEY (id_kabupaten) REFERENCES kabupaten(id_kabupaten)
);
INSERT INTO lokasi_produksi VALUES(1,'jl pahlawan 21 sampang',NULL);
INSERT INTO lokasi_produksi VALUES(2,'burneh',NULL);
INSERT INTO lokasi_produksi VALUES(3,'klobungan jeddih',NULL);
INSERT INTO lokasi_produksi VALUES(4,'jl. ki lemur duwur',NULL);
INSERT INTO lokasi_produksi VALUES(5,'bangkalan',NULL);
INSERT INTO lokasi_produksi VALUES(6,'bancaran',NULL);
INSERT INTO lokasi_produksi VALUES(7,'jl.jokotole no.20',NULL);
INSERT INTO lokasi_produksi VALUES(8,'jl.jokotole no.21',NULL);
INSERT INTO lokasi_produksi VALUES(9,'jl.jokotole no.22',NULL);
INSERT INTO lokasi_produksi VALUES(10,'jl.jokotole no.23',NULL);
INSERT INTO lokasi_produksi VALUES(11,'jl.jokotole no.24',NULL);
INSERT INTO lokasi_produksi VALUES(12,'jl.jokotole no.25',NULL);
INSERT INTO lokasi_produksi VALUES(13,'jl.jokotole no.26',NULL);
INSERT INTO lokasi_produksi VALUES(14,'jl.jokotole no.27',NULL);
INSERT INTO lokasi_produksi VALUES(15,'jl.jokotole no.28',NULL);
INSERT INTO lokasi_produksi VALUES(16,'jl.jokotole no.29',NULL);
INSERT INTO lokasi_produksi VALUES(17,'jl.jokotole no.30',NULL);
INSERT INTO lokasi_produksi VALUES(18,'jl. kabupaten, gladak anyar',NULL);
INSERT INTO lokasi_produksi VALUES(19,'pamekasan',NULL);
INSERT INTO lokasi_produksi VALUES(20,'jl.anggrek, lingkungan delama, pajagalan',NULL);
INSERT INTO lokasi_produksi VALUES(21,'bunten bar, ketapang',NULL);
INSERT INTO lokasi_produksi VALUES(22,'jl.k.h hasyim asyari, demangan',NULL);
INSERT INTO lokasi_produksi VALUES(23,'jl. yakurt blok ed/2 taman gili',NULL);
INSERT INTO lokasi_produksi VALUES(24,'jl. kh lemah duwur gg. v gg.ix no.60, barat tambak,pejagan',NULL);
INSERT INTO lokasi_produksi VALUES(25,'jl.kha. marzuki 68 b',NULL);
INSERT INTO lokasi_produksi VALUES(26,'sumenep',NULL);
INSERT INTO lokasi_produksi VALUES(27,'jl.panglima sudirman gg.1',NULL);
INSERT INTO lokasi_produksi VALUES(28,'jl.panglima sudirman gg.0',NULL);
INSERT INTO lokasi_produksi VALUES(29,'jl.panglima sudirman gg.2',NULL);
INSERT INTO lokasi_produksi VALUES(30,'tlanakan',NULL);
INSERT INTO lokasi_produksi VALUES(31,'jl.panglima sudirman gg.3',NULL);
INSERT INTO lokasi_produksi VALUES(32,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69115',NULL);
INSERT INTO lokasi_produksi VALUES(33,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69116',NULL);
INSERT INTO lokasi_produksi VALUES(34,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69117',NULL);
INSERT INTO lokasi_produksi VALUES(35,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69118',NULL);
INSERT INTO lokasi_produksi VALUES(36,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69119',NULL);
INSERT INTO lokasi_produksi VALUES(37,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69120',NULL);
INSERT INTO lokasi_produksi VALUES(38,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69121',NULL);
INSERT INTO lokasi_produksi VALUES(39,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69122',NULL);
INSERT INTO lokasi_produksi VALUES(40,'jl. kh. mohamad kholil no.50a, demangan timur, demangan, kec. bangkalan, kabupaten bangkalan, jawa timur 69123',NULL);
CREATE TABLE jamu (
    id_jamu INTEGER PRIMARY KEY ,-- AUTOINCREMENT,
    nama_jamu TEXT NOT NULL,
    khasiat TEXT,
    kandungan TEXT,
    aturan_minum TEXT,
    efek_samping TEXT,
    id_jenis INTEGER,
    id_produsen INTEGER,
    id_lokasi_produksi INTEGER,
    id_kabupaten INTEGER,
    id_perizinan INTEGER,
    id_lokasi_pemasaran INTEGER,
    image TEXT,
    FOREIGN KEY (id_jenis) REFERENCES jenis(id_jenis),
    FOREIGN KEY (id_produsen) REFERENCES produsen(id_produsen),
    FOREIGN KEY (id_lokasi_produksi) REFERENCES lokasi_produksi(id_lokasi_produksi),
    FOREIGN KEY (id_kabupaten) REFERENCES kabupaten(id_kabupaten),
    FOREIGN KEY (id_perizinan) REFERENCES perizinan(id_perizinan),
    FOREIGN KEY (id_lokasi_pemasaran) REFERENCES lokasi_pemasaran(id_lokasi_pemasaran)
);
INSERT INTO jamu VALUES(1,'Galian Rapat Wangi','mengurangi bau badan, mengurangi bau tidak sedap serta membuat rapet dan kesed area kewanitaan','kunci, kunyit, pinang muda parabes','','tidak ada',1,1,1,1,1,1,'jamu_1.jpg');
INSERT INTO jamu VALUES(2,'Empot-empot legit sari','Mengurangi lendir berlebih, mengatasi keputihan serta menimbulkan sensasi denyut saat berhubungan','kunci, kunyit, pinang muda parabes','','tidak ada',1,1,1,1,1,1,'jamu_2.jpg');
INSERT INTO jamu VALUES(3,'galian singset','mengurangi lemak dalam tubuh, menambah nafsu makan dan melancarkan BAB','kunyit, daun sirih, delima putih','','tidak ada',1,1,1,1,1,1,'jamu_3.jpg');
INSERT INTO jamu VALUES(4,'jamu kecantikan','perawatan khusus remaja putri, mengurangi bau badan dan mengatasi keputihan','daun sirih, kunyit, kulit manggis, kunci, pinang muda','','tidak ada',1,1,1,1,1,1,'jamu_4.jpg');
INSERT INTO jamu VALUES(5,'jamu galian montok','untuk menambah nafsu makan','temulawak , jahe','','tidak ada',1,1,1,1,1,1,'jamu_5.jpg');
INSERT INTO jamu VALUES(6,'jamu terlambat bulan (lancar darah)','mengurangi nyeri haid dan melancarkan peredaran darah sehingga lebih teratur','kunyit, kunci','','tidak ada',1,1,1,1,1,1,'jamu_6.jpg');
INSERT INTO jamu VALUES(7,'jamu melancarkan asi (pejje)','melancarkan keluarnya ASI','daun katule,kedawung, morinya, kulit manggis, temu ireng','','tidak ada',1,1,1,1,1,1,'jamu_7.jpg');
INSERT INTO jamu VALUES(8,'serbuk wasiat dan butiran delima','mengatasi keputihan dan lendir berlebih di area kewanitaan','manjakani, daun sirih, pinang muda, air kapur sirih','','tidak ada',1,1,1,1,1,1,'jamu_8.jpg');
INSERT INTO jamu VALUES(9,'parfum rempah','menyegarkan bau badan dengan aroma khas rempah khas','kayu gaharu, sentok','','tidak ada',2,1,1,1,1,1,'jamu_9.jpg');
INSERT INTO jamu VALUES(10,'cebokan rempah','mengatasi keputihan dan gatal akibat bakteri dan jamur','temu gunung, daun sirih','','tidak ada',3,1,1,1,1,1,'jamu_10.jpg');
INSERT INTO jamu VALUES(11,'pancuran nikmat','antiseptic kewanitaan tanpa dibilas','daun sirih, air kapur sirih, kunci','','tidak ada',2,1,1,1,1,1,'jamu_11.jpg');
INSERT INTO jamu VALUES(12,'sabun kesed','sabun khusus wanita untuk mengatasi keputihan','minyak zaitun, daun sirihair kapur sirih, essence','','tidak ada',2,1,1,1,1,1,'jamu_12.jpg');
INSERT INTO jamu VALUES(13,'v-spa rempah','detoksifikasi kewanitaan agar bebas keputihan dan bau yang kurang sedap','kayu gaharu, seccang, sentok, temu gunung, pandiyan','','tidak ada',3,1,1,1,1,1,'jamu_13.jpg');
INSERT INTO jamu VALUES(14,'jamu bersalin','perawatan khusus pasca melahirkan, mengembalikan tubuh seperti semula, melancarkan ASI dan mencegah timbulnya varises','jamu asi, param atas, param bawah, cebokan, dupa, godokan temulawak, jamu 40hari tapel pales','','tidak ada',1,1,1,1,1,1,'jamu_14.jpg');
INSERT INTO jamu VALUES(15,'paket perawatan pranikah','mengurangi bau badan, membuat kulit bersih dan lebih cerah','lulur rempah, mandi rempah dupa, sabun kesed, godokan rapetwangi, arfum rempah cemceman rambut','','tidak ada',3,1,1,1,1,1,'jamu_15.jpg');
INSERT INTO jamu VALUES(16,'1 paket ramuan khusus wanita','perawatan khusus wanita untuk menjaga tubuh tetap prima dan hubungan suami istri makin mesra','rapet wangi, empot, butiran delima, pancuran nikmat, sabun kesed.','','tidak ada',4,1,1,1,1,1,'jamu_16.jpg');
INSERT INTO jamu VALUES(17,'jamu penyubur kandungan','menyuburkan kandungan','kunyit, temu gunung sentok, temulawak','','tidak ada',1,1,1,1,1,1,'jamu_17.jpg');
INSERT INTO jamu VALUES(18,'cemceman rambut','mengatasi ketombe dan kerontokan rambut','jeruk purut, sentok','','tidak ada',2,1,1,1,1,1,'jamu_18.jpg');
INSERT INTO jamu VALUES(19,'minyak bulus','mengencangkan kulit dan area khusus baik pria maupun wanita','','','tidak ada',2,1,1,1,1,1,'jamu_19.jpg');
INSERT INTO jamu VALUES(20,'minyak zaitun','','','','tidak ada',2,1,1,1,1,1,'jamu_20.jpg');
INSERT INTO jamu VALUES(21,'lulur rempah','membuat kulit bersih serta tampak lebih cerah','panduyang, manyir, kulit jeruk perut','','tidak ada',3,1,1,1,1,1,'jamu_21.jpg');
INSERT INTO jamu VALUES(22,'bedak dingin','masker bengkoang untuk mencerahkan wajah, memudarkan bekas jerawat dan mengecilkan pori','bengkoang, tepung beras','','tidak ada',3,1,1,1,1,1,'jamu_22.jpg');
INSERT INTO jamu VALUES(23,'pegal linu','mengurangi capek, nyeri sendi dan melancarkan peredaran darah','lempuyang, laos, cabe jamu jahe merah, kencur, merica, ketumbar, sentok peok','','tidak ada',1,1,1,1,1,1,'jamu_23.jpg');
INSERT INTO jamu VALUES(24,'jamu pembersih darah','mengatasi gatal gatal dan alergi pada kulit','sambel loto, daun bawang, bawang putih','','tidak ada',1,1,1,1,1,1,'jamu_24.jpg');
INSERT INTO jamu VALUES(25,'jamu kencing manis','menurunkan kadar gula dalam darah','lempuyang','','tidak ada',1,1,1,1,1,1,'jamu_25.jpg');
INSERT INTO jamu VALUES(26,'bumbu minuman pokak','minuman herbal dari bahan jahe emprit','jahe emprit, sentok, kayu manis, cengkeh, jeruk puru','','tidak ada',2,1,1,1,1,1,'jamu_26.jpg');
INSERT INTO jamu VALUES(27,'1 paket jamu suami istri','mengharmoniskan hubungan suami istri','','','tidak ada',4,1,1,1,1,1,'jamu_27.jpg');
INSERT INTO jamu VALUES(28,'Jamu ma''jun super (plus madu)','menambah stamina, menambah masa otot dan melancarkan peredaran darah','bahan sehat lelaki + madu','','tidak ada',5,1,1,1,1,1,'jamu_28.jpg');
INSERT INTO jamu VALUES(29,'jamu jantan super','menjaga stamina tubuh agar tetap fit','gingseng, pasak bumi, cabe jamu, jahe merah, temu ireng','','tidak ada',1,1,1,1,1,1,'jamu_29.jpg');
INSERT INTO jamu VALUES(30,'jamu aktivitas','penambah stamina khusus pekerja berat. Suplemen khusus untuk menambah stamina pria','','','tidak ada',1,1,1,1,1,1,'jamu_30.jpg');
INSERT INTO jamu VALUES(31,'jamu darah tinggi','menurunkan tekanan darah tinggi','daun salam, temu ireng, kunyit, bawang putih','','tidak ada',1,1,1,1,1,1,'jamu_31.jpg');
INSERT INTO jamu VALUES(32,'1 paket ramuan khusus pria','suplemen khusus bagi pria untuk menjaga stamina dan kesehatan tubuh','sehat lelaki, ma''jun aktivitas','','tidak ada',4,1,1,1,1,1,'jamu_32.jpeg');
INSERT INTO jamu VALUES(33,'Jamu Tradisional Madura','Buat Kesehatan, Bau Badan, Keputihan','Sirih, Kunyit, Jahe, Kencur, Temulawak','','tidak ada',6,2,2,2,NULL,2,'jamu_33.jpg');
INSERT INTO jamu VALUES(34,'Bom','Untuk kuat berhubungan, dan Pegal - pegal','Rempah','','Pusing ringan',3,3,3,2,NULL,3,'jamu_34.jpg');
INSERT INTO jamu VALUES(35,'Jamu Hitam','Untuk segala macam penyakit','Herbal','','tidak ada',4,4,4,2,NULL,4,'jamu_35.jpg');
INSERT INTO jamu VALUES(36,'Jamu Pelintiran darah tinggi','Menurunkan tekanan darah tinggi, menetralisir sirkulasi jantung, Menormalkan sirkulasi jantung','Rempah-rempah','','tidak ada',1,5,5,2,NULL,5,'jamu_36.jpg');
INSERT INTO jamu VALUES(37,'Empot-empot Super','1.Memulihkan elastisitas organ intim wanita; 2. Mengencangkan ototÂ² miss V; 3. Mengencangkan payudara; 4. Mengencangkan seluruh kulit shg tampak lebih muda; 5. Menambah gairah dan semangat dalam berhubungan suami istri; 6. Menghilangkan gatalÂ² di miss V','rempah','','tidak ada',1,6,6,2,NULL,6,'jamu_37.jpg');
INSERT INTO jamu VALUES(38,'Jamu selokarang','Menurunkan pusing, panas dalam sakit gigi tenggorokan','rempah','','tidak ada',2,7,5,2,NULL,5,'jamu_38.jpg');
INSERT INTO jamu VALUES(39,'Jamu Bengkes','Awet Muda Wajah Berseri','Rempah - Rempah','','tidak ada',3,8,5,2,NULL,7,'jamu_39.jpg');
INSERT INTO jamu VALUES(40,'Empot Ayam Super','1.Melegitkan dan menghaluskan vagina; 2. Mengencangkan otot kendor setelah melahirkan; 3. Menghilangkan bau serta gatalÂ²; 4. Mengatasi masalahÂ² ibu yg ikut bermacamÂ² KB; 5. Utk wanita frigid dan suami istri selalu harmonis; 6. Membuat awet muda dan cantik','Rempah-rempah','','tidak ada',1,9,5,2,NULL,8,'jamu_40.jpg');
INSERT INTO jamu VALUES(41,'Jamu Delima Putih','Mengatasi keputihan/pektay','Rempah-rempah','','tidak ada',3,10,5,2,NULL,9,'jamu_41.jpg');
INSERT INTO jamu VALUES(42,'Sariawan Sekalor','Menyembuhkan radang gusi, radang tenggorokan, sakit gigi, sakit kepala, amandel, ambeyen, demam,kolesterol dan mendetox darah.','Sirih, Kunyit, Meniran, Pare, ketumbar, kencur, adas manis, sambiloto, secang','Sehari 2x Pagi 5 butir, Malam 5 butir','tidak ada',1,11,7,3,NULL,10,'jamu_42.jpg');
INSERT INTO jamu VALUES(43,'Galian Singset ( Susut Perut)','Melangsingkan badan, mengecilkan dan mengencangkan perut kendur,memadatkan tubuh,melancarkan BAB, membuat wajah segar dan tidak mudah keriput, menghilangkan selulit.','Temu Kunci, Temu Lawak, Sirih, Lengkuas, Partai Cina, Adas Manis, Delima, Asam Gelugur','1 x 5 butir sehari / sore hari','tidak ada',1,11,8,3,NULL,10,'jamu_43.jpg');
INSERT INTO jamu VALUES(44,'Sehat Laki-laki Perkasa','Menambah stamina dan juga menambah hormon, Menghilangkan capek/letih/encok, Menjaga tubuh tetap perkasa, Tidak mudah masuk angin, Mengentalkan sperma, Mencegah ejakulasi dini.','Kubeba, Jahe, Jintan hitam, kemukus, kapulaga, jintan putih, fenugreek','1 x 3 butir sehari/ sore hari. Penderita darah tinggi dan jantung tidak dianjurkan untuk meminum jamu ini.','tidak ada',1,11,9,3,NULL,10,'jamu_44.jpg');
INSERT INTO jamu VALUES(45,'Sari Rapet Empot-Empot','Mengharumkan bagian kewanitaan, Menyembuhkan keputihan/gatal disebabkan bakteri, Merapatkan vagina,Mengencangkan otot rahim, Menambah keharmonisan rumah tangga.','Ek Quercus Lusitanica, Terminalia Chebula, delima, sirih, temu kunci, adas manis','Setiap hari 5 butir/sore hari','tidak ada',1,11,10,3,NULL,10,'jamu_45.jpg');
INSERT INTO jamu VALUES(46,'Pluntur(Pelancar Darah)','Melancarkan darah, menghilangkan pegel linu, menjaga stamina tubuh, mengurangi angka kelahiran.','Kubeba, Lengkuas, Lada Jawa, jahe, jintan putih','Setiap berhubungan 5 butir, Jika mengalami terlambat mens diminum setiap hari sampai 10 butir.','tidak ada',1,11,11,3,NULL,10,'jamu_46.jpg');
INSERT INTO jamu VALUES(47,'Strong','Menambah stamina tubuh, Menghilangkan capek/letih/encok, Menjaga tubuh tetap perkasa,  Mengentalkan sperma, Mencegah ejakulasi dini, Tahan lama.','Kubeba, Jahe, Jintan Hitam, Kemukus, Kapulaga, Jintan Putih, Fenugreek','1 x 2 kapsul. Penderita darah tinggi dan jantung tidak dianjurkan untuk meminum jamu ini.','tidak ada',7,12,NULL,3,NULL,10,'jamu_47.jpg');
INSERT INTO jamu VALUES(48,'Seger Montok','Mengencangkan dan memontokkan payudara, Memadatkan tubuh, Mencerahkan wajah, Memberi nafsu makan, Menyehatkan badan.','Temu lawak, adas manis, lengkuas, temu kunci, delima,jintan hitam','1xsehari 5 butir.','tidak ada',1,11,11,3,NULL,10,'jamu_48.jpg');
INSERT INTO jamu VALUES(49,'Rapet Wangi Spesial','Mengharumkan bagian kewanitaan, Menyembuhkan keputihan/Gatal disebabkan bakteri, merapatkan vagina, Mengencangkan otot rahim, Menambah keharmonisan rumah tangga.','Oak Lusitanica Lamk, Terminalia Chebula, delima, sirih, temu kunci, adas manis','2 x 2 kapsul / pagi-sore hari','tidak ada',7,11,12,3,NULL,10,'jamu_49.jpg');
INSERT INTO jamu VALUES(50,'Tolak Angin','Menyembuhkan demam,pusing, perut mual, kembung, tenggorokan kering dan menambah daya tahan tubuh.','lengkuas, jintan hitam, kapulaga, petai cina, adas manis, temu lawak, jahe','Sehari 2x Pagi 5 butir, Malam 5 butir','tidak ada',1,11,13,3,NULL,10,'jamu_50.jpg');
INSERT INTO jamu VALUES(51,'Subur Kandungan','Diramu dari bahan jamu berupa tumbuh-tumbuhan dan akar yang berkhasiat tinggi untuk membantu menyehatkan, menyuburkan dan menguatkan kandungan. Jamu ini sangat baik bagi ibu-ibu yang sering keguguran dan sulit mendapatkan kehamilan.','','Satu bungkus jamu ini direbus dengan 1 liter air selama  10 menit, diminum setiap hari pagi dan sore 1 gelas. Apabila habis airnya ditambah air lagi, dan rebus kembali.','tidak ada',3,11,14,3,NULL,10,'jamu_51.jpg');
INSERT INTO jamu VALUES(52,'Sehat Wanita','','','','tidak ada',NULL,11,15,3,NULL,10,'jamu_52.jpg');
INSERT INTO jamu VALUES(53,'Sehat Laki-laki ( Helbeh)','','','','tidak ada',NULL,11,16,3,NULL,10,'jamu_53.jpg');
INSERT INTO jamu VALUES(54,'Natural Lulur Sari temugiring','Menghaluskan dan mencerahkan kulit, melembabkan, menghilangkan bekas noda di tubuh.','Terbuat dari ekstrak Sari Temu Giring.','','tidak ada',NULL,11,17,3,NULL,10,'jamu_54.jpg');
INSERT INTO jamu VALUES(55,'Empot Sari Rapet','mengembalikan masa keperawanan dan menambah keharmonisan dalam rumah tangga, memadatkan tubuh dan membuat badan lebih segar.','Daun Kacip Fatimah, gambir, kulit palamelia, daun sirih, rimpang kunyit','3X Sehari 2 Butir','tidak ada',1,13,18,3,NULL,10,'jamu_55.jpg');
INSERT INTO jamu VALUES(56,'Awet Muda','membantu memelihara kecantikan','Temu Kunci, Kayu Manis, Bibhitaki, gambir','2X Sehari 2 Butir','tidak ada',1,13,18,3,NULL,10,'jamu_56.jpg');
INSERT INTO jamu VALUES(57,'Ma''jun','menyembuhkan sakit pinggang, pegel linu, encok dan rematik, menghilangkan rasa lelah sehingga menambhan setamina dan syahwat','konyingar, delingu, masoji, sentok, prabas, adas, pulosari dll','2X Sehari 1 Butir','tidak ada',1,13,18,3,NULL,10,'jamu_57.jpg');
INSERT INTO jamu VALUES(58,'Sale Karang','sakit gigi, gusi bengkak dan gusi berdarah','','','tidak ada','',13,18,3,'',10,'jamu_58.jpg');
INSERT INTO jamu VALUES(59,'Ibu Hamil','biar tidak mudah capek','','','tidak ada',NULL,13,18,3,NULL,10,'jamu_59.jpg');
INSERT INTO jamu VALUES(60,'Diabet','menstabilkan kadar gula','','','tidak ada',NULL,13,18,3,NULL,10,'jamu_60.jpg');
INSERT INTO jamu VALUES(61,'Nafsu Makan','Untuk menambah nafsu makan','Adas, pulosari, jahe dll','','tidak ada',NULL,14,19,3,NULL,10,'jamu_61.jpg');
INSERT INTO jamu VALUES(62,'Sehat Pria','Untuk menambah tenaga lelaki','Jahe, jintan hitam,kiji beling, muso dan kedewung, pinang muda, daun sirih, kulit jeruk','seminggu 1x','tidak ada',NULL,14,19,3,NULL,10,'jamu_62.jpg');
INSERT INTO jamu VALUES(63,'Sehat Wanita','Untuk menambah setamina perempuan dan menjaga organ kewanitaan','Jahe, jintan hitam,kiji beling, muso dan kedewung, pinang muda, daun sirih, kulit jeruk, kayu rapet, majaan','seminggu 1x','tidak ada',NULL,14,19,3,NULL,10,'jamu_63.jpg');
INSERT INTO jamu VALUES(64,'Nafsu Makan','menambah nafsu makan','jahe, adas, pulosari, muso, kedewung, temulawak','seminggu2x','tidak ada',NULL,14,19,3,NULL,10,'jamu_64.jpg');
INSERT INTO jamu VALUES(65,'Gatal-gatal','untuk menyembuhkan gatal-gatar dan alergi','jahe, daun sirih, kulit jeruk, sambi roto, muso dan kedewung','sehari 1x','tidak ada',NULL,14,19,3,NULL,10,'jamu_65.jpg');
INSERT INTO jamu VALUES(66,'Ibu Melahirkan','memperlancar ASI','Adas, pulosari, muso , kedwung, daun sirih, kulit jeruk, kayu rapet, majaan, sambi roto','sehari 1x, jika sudah lancar maka boleh seminggu 3x','tidak ada',NULL,14,19,3,NULL,10,'jamu_66.jpg');
INSERT INTO jamu VALUES(67,'Jamu Sakit Pinggang','meredakan nyeri pinggang dan menambah stamina','kiji beling, jahe, muso , kedewung, daun sirih, kulit jeruk, dan pinang muda','seminggu 3x','tidak ada',NULL,14,19,3,NULL,10,'jamu_67.jpg');
INSERT INTO jamu VALUES(68,'Jaselang','Menambah stamina, pegal linu, capek-capek, mengahangatkan badan dll','jahe emprit, seccang, akar alang-alang, biji pala, kapulaga, dan gula pasir ','1,5 sendok di seduh dengan 1 gelas air hangat','tidak ada',3,15,19,3,NULL,10,'jamu_68.jpg');
INSERT INTO jamu VALUES(69,'Macho','Menambah stamina dan ereksi, meningkatkan libido, mengobati pegal linu, capek-capek, dan menghangatkan badan','habbatus sauda'', pinang muda, bawang putih lanang, temu kunci dll','1,5 sendok di seduh dengan 1 gelas air hangat','tidak ada',3,15,19,3,NULL,10,'jamu_69.jpg');
INSERT INTO jamu VALUES(70,'Kusir','menghilangkan bau badan, sakit kepala dll','kunyit, asam, daun sririh pilihan dll','1,5 sendok di seduh dengan 1 gelas air hangat','tidak ada',3,15,19,3,NULL,10,'jamu_70.jpg');
INSERT INTO jamu VALUES(71,'Sarpet Manjakani','mencegah keputihan, menghilangkan bau  badan, meraptkan vagina dll','temu kunci, jahe, pinang muda, sirih, manjakani','1,5 sendok di seduh dengan 1 gelas air hangat','tidak ada',3,15,19,3,NULL,10,'jamu_71.jpg');
INSERT INTO jamu VALUES(72,'Jamu Sondhep','meredakan nyeri otot bagian bahu, otot piggang, dan memperlancar peredaran darah','','diminum ketika sakit nyeri oto bagian puggung, 1-2 sendok diseduh dengan air hangat','tidak ada',3,16,20,4,NULL,10,'jamu_72.jpg');
INSERT INTO jamu VALUES(73,'Sale Karang','sakit gigi, gusi bengkak dan gusi berdarah','','diminum ketika sakit gigi atau gusi, 1-2 diseduh dengan air hangat','tidak ada',3,16,20,4,NULL,10,'jamu_73.jpg');
INSERT INTO jamu VALUES(74,'Daun sirih','menghilangkan bau badan, mengobati sariawan, menghilangkan mau bulut, mencegah keropos pada gigi dan tulang','','1 bungkus diseduh dengan air hangat','tidak ada',3,16,20,4,NULL,10,'jamu_74.jpg');
INSERT INTO jamu VALUES(75,'Kuda Hitam','Untuk meningkatkan kekuatan pada pria','tangkur, pasak bumi, pinang muda, bawang lanang, jahe merah, rempah dll','1 bungkus diseduh dengan 150 ml air hangat','tidak ada',3,17,21,1,NULL,11,'jamu_75.jpg');
INSERT INTO jamu VALUES(76,'Jahe Merah Plus','Untuk menambah stamina tubuh','jahe merah, gula,  sereh, kayu manis, kapulaga, cengkeh','2 sendok makan dan 250 ml air hangat','tidak ada',3,17,21,1,NULL,11,'jamu_76.jpg');
INSERT INTO jamu VALUES(77,'ekstrak jahe','untuk mengobati gejala masuk angin','jahe emprit, gula,  sereh, kayu manis, kapulaga, cengkeh','2 sendok makan dan 250 ml air hangat','tidak ada',3,17,21,1,NULL,11,'jamu_77.jpg');
INSERT INTO jamu VALUES(78,'ekstrak temulawak','untuk mengobati penyakit asam lambung dan menambah nafsu makan','temulawak, gula,  sereh, kayu manis, kapulaga, cengkeh','2 sendok makan dan 250 ml air hangat','tidak ada',3,17,21,1,NULL,11,'jamu_78.jpg');
INSERT INTO jamu VALUES(79,'ektrak kunyit','untuk mengobati penyakit asam lambung ','kunyit, gula,  sereh, kayu manis, kapulaga, cengkeh','2 sendok makan dan 250 ml air hangat','tidak ada',3,17,21,1,NULL,11,'jamu_79.jpg');
INSERT INTO jamu VALUES(80,'kopi lake''','Untuk meningkatkan kekuatan pada pria','kopi, pinang muda, kapulaga, jahe','2 sendok makan dan 250 ml air hangat','tidak ada',3,17,21,1,NULL,11,'jamu_80.jpg');
INSERT INTO jamu VALUES(81,'wedang jahe merah','Menambah stamina tubuh','jahe, kunyit, sereh, cengkeh, gula merah','sehari 1 botol','tidak ada',2,17,21,1,'',12,'jamu_81.jpg');
INSERT INTO jamu VALUES(82,'kunyit asam madu','untuk merawat kesehatan lambung, dan mengobati panas dalam','kunyit, asam, jahe, gula pasir, madu','sehari 1-2 botol','tidak ada',2,17,21,1,NULL,12,'jamu_82.jpg');
INSERT INTO jamu VALUES(83,'manjakani','untuk merawat kesehatan wanita seperti mempelancar haid dan keputihan','kunyit, jahe, temukunci, biji manjakani, pinang muda, sirih, kayu rapat, gula','sehari 1 botol','tidak ada',2,17,21,1,NULL,12,'jamu_83.jpg');
INSERT INTO jamu VALUES(84,'kuda hitam cair','Untuk meningkatkan kekuatan pada pria','kopi, pinang muda, kapulaga, jahe','sehari 1 botol','tidak ada',2,17,21,1,NULL,12,'jamu_84.jpg');
INSERT INTO jamu VALUES(85,'ETABARI','untuk penderita kencing manis(diabetes)','Ramuan Andrografis 30%, Ortosifon 20%, Rimpang Imperatae 20%,Rimpang Temulawak 20%, Ramuan Centellae 10%','Sehari 10 pil','tidak ada',1,18,22,2,2,13,'jamu_85.jpg');
INSERT INTO jamu VALUES(86,'Subur Kandungan','menyuburkan kandungan, menguatkan kandungan yang lemah','','tiap hari 10 pil','tidak ada',1,18,22,2,1,13,'jamu_86.jpg');
INSERT INTO jamu VALUES(87,'TOLAK AMBEYEN','Menyembuhkan ambeyen baru atau sudah lama, menjaga kesehatan','','sehari 5-7 pil, diminum sampai sembuh','tidak ada',1,18,22,2,1,13,'jamu_87.jpg');
INSERT INTO jamu VALUES(88,'TOLAK BATUK/ASMA','membantu mengobati batuk yang masih baru maupun yang sudah lama, membantu mengobati penyakit alergi pernapasan bagian atas dan penyakit asma, membantu menurunkan panas demam disebabkan flu dan radang tenggorokan.','daun lada 50 mg, rimpang kunyit 50mg,  Bawang Putih 50 mg, Rimpang Temu Kunci 30 mg, buah adas 20mg','tergantung keadaan. Untuk pencegahan sehari 15 pil, apabila dalam keaadan sakit 3x sehari 15 pil, untuk anak-anak umur 6 bulan keatas sehari 5 pil boleh lebih.','tidak ada',1,18,22,2,2,13,'jamu_88.jpg');
INSERT INTO jamu VALUES(89,'Susut perut Tresna','membantu mengurangi lemak tubuh terutama di bagian perut dan membantu menurunkan berat badan','daun guazuma 30%, korteks parameria 20%, rimpang jahe 20%, Rimpang Boesenbegia 15%, rimpang kunyit 15%','untuk mengurangi berat badan sehari 10-15 pil, boleh 2-3x 15 pil sampai mencapai berat badan ideal','tidak ada',1,18,22,2,2,13,'jamu_89.jpg');
INSERT INTO jamu VALUES(90,'PANYAMAN EMPOT-EMPOT','membantu merapatkan organ kewanitaan, mengencangkan otot-otot rahim dan sekitarnya, vagina menjadi keset dan sensitif, membantu para wanita agar lebih cepat mencapai orgasme, memberi getaran-getaran apabila ada sentuhan','pabrik adas biasa 10%, alyxia stellata 10%,Parameria Berambut 15%, Temu Kunci Angustifolia Roscoe 40%, Temu Ireng Roxb','sehari 10-15 pil','tidak ada',1,18,22,2,2,13,'jamu_90.jpg');
INSERT INTO jamu VALUES(91,'masker v','membantu para wanita mengatasi frigit dan agar mempunyai gairah melayani pasangan','','ambil secukupnya dan balukan merata ke daerah v, diamkan +15 menit, lalu cuci bersih','tidak ada',3,18,22,2,NULL,13,'jamu_91.jpg');
INSERT INTO jamu VALUES(92,'LAMSAM','untuk menurunkan/menormalkan tekanan darah tinggi(hipertensi), dan melancarkan peredangan darah dalam tubuh','Ketumbar 25%, Seledri 5%, Kumis Kucing 25%, Bunga Matahari Liar B 25%','sehari 10-15 pil, untuk pengobatan 3x 15 pil, jika tekanannya sangat tinggi','tidak ada',1,18,22,2,NULL,13,'jamu_92.jpg');
INSERT INTO jamu VALUES(93,'lulur wangi','untuk mengatasi jerawat dan mengangkat komedo','','','tidak ada',3,18,22,2,NULL,13,'jamu_93.jpg');
INSERT INTO jamu VALUES(94,'PETODHU','untuk kesehatan tulang untuk pria dan wanita','Kunyit 25%, dll','sehari 10-15 pil','tidak ada',1,18,22,2,NULL,13,'jamu_94.jpg');
INSERT INTO jamu VALUES(95,'GALIAN PUTRI','menjaga agar tubuh tetap segar, sehat, lincah dan tidak pucat, mengatasi bau ketiak dan bau badan yang kurang sedap, membantu mengatasu penyakur keputihan, menjaga organ kewanitaan sehingga pakaian dalan tetap bersih dari noa\da, melancarkan haid',' Kunyit 50%, Jintan Hitam 25%, Lada Hitam 25%,  Sirih 50%, Anggrek Lidah Ular 50%','sehari 10-15 pil, jika sakit sehari 2-3x 10 pil','tidak ada',1,18,22,2,NULL,13,'jamu_95.jpg');
INSERT INTO jamu VALUES(96,'GALIAN RAPET','membantu merapatkan organ kewanitaan, menjaga keharmonisan rumah tangga, menghilangkan bau tidak sedap, membantu mengatasi keputihan','','sehari 10-15 pil. Ibu hamil an wanita datang bulan dilarang mengkonsumsi jamu ini','tidak ada',1,18,22,2,2,13,'jamu_96.jpg');
INSERT INTO jamu VALUES(97,'lulur ayu','memelihara dan kecantikan wajah dan anggota badan, membersihkan dan menghaluskan kulit','','larutkan 1 sendok makan lulur dnegan air secukupnya, oleskan ke seluruh anggota tubuh sambil digosok pelan-pelan sampai mengering','tidak ada',3,18,22,2,NULL,13,'jamu_97.jpg');
INSERT INTO jamu VALUES(98,'PAS JUDHU','membantu mengatasi asam urat, kolestrol, nyeri reumatik','kunyit 30%, bawang putih 20%, Kayu Manis Sintok 10%, Jahe Aromatik 30%,  Lada Hitam 10%','sehari 10-15 pil, jika dalam keadaan sakit 3 x 10-15 pil','tidak ada',1,18,22,2,NULL,13,'jamu_98.jpg');
INSERT INTO jamu VALUES(99,'SEHAT L.M','memperlancar peredaran darah, menambah tenaga serta meningkatkan daya tahan tubuh terhadap penyakut, membantu mengatasi gejala penuaan, nyeri otot,nyeri sendi,pegal-pegal, rabun mata, encegah masuk angin, pusing dan maag','Pegagan 15%, Kumis Kucing 15%,  Kunyit 50%, Jahe 20%','untuk pencegahan 10 pil, untuk pengobatan 3x sehari 15 pil, untuk anak-anak 5 pil','tidak ada',1,18,22,2,2,13,'jamu_99.jpg');
INSERT INTO jamu VALUES(100,'GALIAN RAPET','membantu merapatkan organ kewanitaan, menjaga keharmonisan rumah tangga, menghilangkan bau tidak sedap, membantu mengatasi keputihan','Rimpang Boesenbergia 30%, Korteks Parameria 20%, Kulit Buah Delima 20%, Rimpang Kunyit 20%, Rimpang Temu Kunci 10%','sehari 10-15 pil','tidak ada',1,18,22,2,2,13,'jamu_100.jpg');
INSERT INTO jamu VALUES(101,'cream montok','membantu membesarkan payudara','','bisa diguankan setiap hari dengan cara di oleskan','tidak ada',8,18,22,2,NULL,13,'jamu_101.jpg');
INSERT INTO jamu VALUES(102,'GALIAN MONTOK','membantu mengobati buah dada yang kecil supaya jadi montok dan besar, buah dada menjadi padat berisi','','sehari 10-15 pil','tidak ada',1,18,22,2,'',13,'jamu_102.jpg');
INSERT INTO jamu VALUES(103,'BERSIH JERAWAT','membantu mengatasi / membersihkan jerawat, mencegah timbulnya jerawat, memelihara wajah agar tetap halus','','sehari 15 pil ','tidak ada',1,18,22,2,NULL,13,'jamu_103.jpg');
INSERT INTO jamu VALUES(104,'AWET AYU','mengandung formula ''anti aging'' yang berguna untuk menghambat proses penuaan seperti mengurangi keriput, memudarkan lingkaran hitam di mata dan dapat mengurangi kantung mata, membantu mengatasi penyakit keputihan, menghilangkan bau badan, merapatkan vagina, menjaga organ kewanitaan tetap bersih, mengurangi dan menghilangkan rasa sakit serta menjelang haid','','sehari 10 pil, untuk pencegahan penyakit keputihan boleh ditingkatkan 2-3x sehari 10 pil','tidak ada',1,18,22,2,NULL,13,'jamu_104.jpg');
INSERT INTO jamu VALUES(105,'PANYAMAN','untuk mnegatasi kurang gairah, mengencangkan otot-otot rahim dan sekitarnya, vagina menjadi keset dan sensitif, membantu para wanita agar lebih cepat mencapai orgasme, memberi getaran-getaran apabila ada sentuhan','','sehari 10-15 pil','tidak ada',1,18,22,2,NULL,13,'jamu_105.jpg');
INSERT INTO jamu VALUES(106,'JAMU PERKASA','mencegah ejakulasi dini, menambah daya tahan lama pria, menambah tenaga dan gairah keperkasaan pria, menambah kesehatan dan kebugaran','Biji Pinang 20%, Rimpang Terminalia 20%,  Biji Cuscuta 30%,Bahan Lainnya sampai 100%','sehari 7-10 (menurut kebutuhan) di minum kira-kira 3-4 jam sebelum efek yang diinginkan','tidak ada',1,18,22,2,NULL,13,'jamu_106.jpg');
INSERT INTO jamu VALUES(107,'peluntur &pelangsing','mengurangi lemak dalam tubuh terutama di perut yang gendut, mengencangkan otot-otot yang kendor, memelihara tubuh agar tetap langsing padat dan ideal secara alami','','7-15 pil sehari, wanita hamil/penderita diare dilarang minum jamu ini','tidak ada',1,18,22,2,1,13,'jamu_107.jpg');
INSERT INTO jamu VALUES(108,'BEDAK SARI','pengharum tubuh','','di semprotkan ke bagian tubuh','tidak ada',2,18,22,2,NULL,13,'jamu_108.jpg');
INSERT INTO jamu VALUES(109,'HABBATUS SAUDA','menjaga stamina, memperkuat daya kosentrasi, anti bakteri, mengatasi infeksi, menghangatkan dan melegakan saluran pernapasan, meringankan gejala batuk pilek, menurunkan demam, membantu mempercepat penyembuhan penyakit, membantu mengatasu maag, mengeluarkan masuk angin dan kembung','','3x sehari 1-2 kapsul','tidak ada',7,18,22,2,3,13,'jamu_109.jpg');
INSERT INTO jamu VALUES(110,'SELEDRI MIX','untuk mengatasi asam urat','seledri, kencur, jahe, gula','1 sendok teh seduh dengan air 200 ml','tidak ada',3,19,23,2,3,5,'jamu_110.jpg');
INSERT INTO jamu VALUES(111,'KUNYIT ASEM','meningkatkan data tahan tubuh, menjaga stamina, menghilangkan bau badan, melancarkan datang bulan, menghaluskan kulit, mencegah penuaan dini, mencegah diare','kunyit, asem, gula','1 sendok teh seduh dengan air 200 ml','tidak ada',3,19,23,2,3,5,'jamu_111.jpg');
INSERT INTO jamu VALUES(112,'TEMU LAWAK','mengatasi maag, mengatasi radang sendi, menghilangkan bau badan, mengatasi diare, mengatasi kolesterol, melancarkan pencernaan, mencegah penuaan dini, anti kanker, menyehatkan liver dan ginjal','temulawak dan gula','1 sendok teh seduh dengan air 200 ml','tidak ada',3,19,23,2,3,5,'jamu_112.jpg.jpeg');
INSERT INTO jamu VALUES(113,'BERAS KENCUR','mengatasi batuk pilek, meredakan hidung tersumbat, menambah nafsu makan, mengatasi sakit maag, meningkatkan imun tubuh','beras, kencur, gula','','tidak ada',2,19,23,2,3,5,'jamu_113.jpg');
INSERT INTO jamu VALUES(114,'SIRIH PINANG','menjaga kesehatan gigi, mencegah sariawan, menghilangkan bau mulut, menghilangkan bau badan, mengatasi keputihan, melancarkan pencernaan, mencegah gusi berdarah','daun sirih, pinang, kunci pepet, gula','1 sendok teh seduh dengan air 200 ml','tidak ada',3,19,23,2,3,5,'jamu_114.jpg');
INSERT INTO jamu VALUES(115,'POKA''','mengatasi masuk angin,mual, pusing, meredakan nyeri sendi, meningkatkan imun tubuh, mencegah penuaan dini, anti kanker, mencegah kolesterol','','','tidak ada',2,19,23,2,3,5,'jamu_115.jpg');
INSERT INTO jamu VALUES(116,'BUNGA TELANG','menyehatkan mata, menyehatkan otak, menghaluskan kulit, melancarkan pencernaan, mencegah penuaan dini','bunga telang, gula','','tidak ada',2,19,23,2,3,5,'jamu_116.jpg');
INSERT INTO jamu VALUES(117,'jahe merah instant','untuk mengobati masuk angin, pusing,dan mual','jahe merah, gula','1 sendok teh seduh dengan air 200 ml','tidak ada',3,19,23,2,3,5,'jamu_117.jpg');
INSERT INTO jamu VALUES(118,'Empot wangi','membantu mengurangi lendir yang berlebihan pada daerah kewanitaan','Paramecia nigeria 40mg, Temulawak hitam atau temulawak biru 40mg, Galalit 40mg, Madu abe/asli 220mg, Natrium benzoat','2x sehari 2-3 pil','tidak ada',1,20,24,2,2,5,'jamu_118.jpg');
INSERT INTO jamu VALUES(119,'Galian singset ++','mengurangi kelebihan lemak (kolestrol) dalam tubuh, mengecilkan perut, menjaga bentuk tubuh yang ideal, menjaga penampilan selalu awet muda, membantu mengurangi lemak di tubuh, melangsingkan badan, membuat tampil seksi dan percaya diri, menormalkan BAB yang tidak lancar','','','tidak ada',1,20,24,2,4,5,'jamu_119.jpg');
INSERT INTO jamu VALUES(120,'asi booster','melancarkan asi, menyegarkan badan muka tidak pucat, menyehatkan ibu dan bayi yang dilahirkan, menuntaskan sisa darah, meningkatkan kualitas nutrisi dalam asi','flore insertus, venerable aerospace, kunyit putih dll','2x sehari 5 pil','tidak ada',1,20,24,2,4,5,'jamu_120.jpg');
INSERT INTO jamu VALUES(121,'gadis remaja','menghilangkan bau badan yang kurang sedap, mencegah tumbuhnya jerawat, menyembuhkan keputihan, menjaga bentuk tubuh tetap ideal','tembakau, temulawak hitam, kunyit, cubeba','2x sehari 2 kapsul','tidak ada',7,20,24,2,4,5,'jamu_121.jpg');
INSERT INTO jamu VALUES(122,'empot-empot','menambah kemesraan dan keharmonisan keluarga, kembali muda bagaikan gadis remaja, membuat suami makin sayang sama istri, kenikmatan dan kepuasan selalu menjelma','','5 pil 2x sehari','tidak ada',1,20,24,2,4,5,'jamu_122.jpg');
INSERT INTO jamu VALUES(123,'sehat lelaki','menambah semangat stamina dan kesehatan, menguatkan dan menghangatkan badan, pegal linu otot kaku dan lesu','','5 pil 2x sehari 2 kapsul 2x sehari','tidak ada',1,20,24,2,4,5,'jamu_123.jpg');
INSERT INTO jamu VALUES(124,'rapet harum asmara','merapatkan dan melenturkan miss v, mengatasi bau tak sedap, serta gatal-gatal disekitar organ intim, mengatasi cairan berlebih, mengaharumkan area vagina, menjaga keharmonisan hubungan suami istri, menyembuhkan keputihan, serta gejalanya','galalit, kunyit, temulawak hitam, kencur putih','2x sehari 5 pil','tidak ada',1,20,24,2,4,5,'jamu_124.jpg');
INSERT INTO jamu VALUES(125,'feminia','menjaga miss v tetap keset elastis, menambah libido, menghilangkan bau badann dan miss v yang kurang sedap, menyembuhkan keputihan, menjaga payudara tetap kenyal dan montok, melindungi rahim dari berbagai virus, menormalkan hormon estrogen, menghangatkan badan, mengurangi pegel-pegel/linu','galalit, temulawak hitam, kencur putih, dll','2x sehari 5 pil','tidak ada',1,20,24,2,4,5,'jamu_125.jpg');
INSERT INTO jamu VALUES(126,'awet muda','memulihkan elastisitas organ intim wanita( kencangkan otot miss v), menghilangkan gatal-gatal, keputihan dan bau kurang menyenangkan, mencegah penuaan dini, menstabilkan PH asam dan mengurangi cairan( basah) berlebihan, meningkatkan hormon estrogen, menambah gairah dan tahan lama, peremajaan tubuh usai melahirkan/haid, mencegah kanker servix dan kanker payudara','manjakani, jinten hitam, jinten putih dll s/d 100%','5pil 2x sehari/ 2 kapsul 2x sehari','tidak ada',1,20,24,2,4,5,'jamu_126.jpg');
INSERT INTO jamu VALUES(127,'jakuat','memperbaiki stamina pria, meningkatkan kebugaran tubuh dalam hubungan pasutri, membantu mengatasi ejakulasi dini, mengentalkan sperma, menambah kejantanan pria','akar jahe, biji sirih kuning, jinten putih, madu raja dll sampai 100%','5 pil 2x sehari','tidak ada',1,20,24,2,4,5,'jamu_127.jpg');
INSERT INTO jamu VALUES(128,'sirih wangi','menghilangkan bau badan dan mulut, menyembuhkan radang tenggorokan dan gusi, mengatasi keputihan, menyembuhkan jerawat, menghaluskan kulit, melancarkan air seni, penambah tenaga/ stamina, mengurangi keringat berlebih, mengatasi penyakit kulit/gatal-gatal','Biji Sirih (Piper betle), Biji Sirih Hutan (Boesenbergia rotunda), Biji Kunyit (Curcuma longa),Biji Kabesak (Piper cubeba)','2x sehari 3 kapsul','tidak ada',1,20,24,2,4,5,'siri_wangi.jpg');
INSERT INTO jamu VALUES(129,'Rapet Wangi','membantu mengurangi lendir yang berlebihan pada daerah kewanitaan','125mg Biji Ek Quercus indica, 62,5mg Biji Pinang (Areca catechu), 10mg Kulit Buah Jeruk, 41mg Madu Murni yang Diproses','2x sehari 2-3 pil','tidak ada',1,20,24,2,2,5,'jamu_129.jpg');
INSERT INTO jamu VALUES(130,'bersih darah','melancarkan peredaran darah di dalam tubuh, membersihkan darah kotor yang ada di dalam tubuh, mengatasi gatal-gatal pada kulit, mengatasi / meringankan bisul, mengobati korengan dan beberapa masalah kulit lainnya, menyembuhkan serta mencegah jerawat','','5 pil 2x sehari','tidak ada',1,20,24,2,4,5,'jamu_130.jpg');
INSERT INTO jamu VALUES(131,'kencing manis','mengobati kencing manis, menurunkan kadar gula seperti sering merasa haus, sering kencing terutama dimalam hari','','5 pil 2x sehari','tidak ada',1,20,24,2,4,5,'jamu_131.jpg');
INSERT INTO jamu VALUES(132,'sari rapat','menambah gairah hubungan suami istri, mengobati keputihan dan gejalanya seperti berair, berlendir, berbau, merapatkan otot-otot vagina','','5 pil 2x sehari','tidak ada',1,20,24,2,4,5,'jamu_132.jpg.jpeg');
INSERT INTO jamu VALUES(133,'delima putih','mencegah dan mengobati keputihan seperti muka pucat tidak bergairah sakit pinggang mengurangi lendir serta menghilangkan bau (keringat) kurang sedap, merapatkan vagina pemakaian secara teratur maka wajah bercahaya cantik & awet muda','','5 pil 2x sehari','tidak ada',1,20,24,2,4,5,'jamu_133.jpg');
INSERT INTO jamu VALUES(134,'empot-empot love','mengencangkan organ intim (rapet), mengencangkan kulit, menambah libido, atasi payudaya kendur, membersihkan bakteri dan jamur (keputihan), mengobati kista, mencegah kanker payudaram menguatkan pinggang, melancarkan datang bulan','Kayu parameria atau kayu putih, Temulawak hitam atau temulawak biru, Galalit, dll hingga 100%','3x sehari 3 pil','tidak ada',1,20,24,2,4,5,'jamu_134.jpg');
INSERT INTO jamu VALUES(135,'manjakani','menormalkan hormon estrogen, mengencangkan wajah dan kulit, mengencangkan payudara, mengencangkan otot-otot kewanitaan (rapet), mencegah osteoporosis (tulang keropos), menyembuhkan keputihan, menguatkan pinggang, melancarkan datang bulan','Galalit, Temulawak hitam atau temulawak biru, Kencur asli atau kencur putih','2x sehari 3 pil','tidak ada',1,20,24,2,4,5,'jamu_135.jpg');
INSERT INTO jamu VALUES(136,'gemuk sehat','menambah nafsu makan, menghambat pertumbuhan sek kanker, meningkatkan daya tahan tubuh, menjaga kesehatan liver, memperbaiki jaringan tubuh yang rusak, membantu melawan bakteri dan jamur di tubuh, menyembuhkan penyakit kuning','Likoris, Temulawak hitam, Kayu manis asli, dll','2x sehari 5 pil','tidak ada',1,20,24,2,4,5,'jamu_136.jpg');
INSERT INTO jamu VALUES(137,'oil mahabbah','agar payudaya tetap kencang dan motok setelah melahirkan, merawat kesehatan payudara, menghaluskan kulit payudara','','pijak payudara dengan oil mahabbah secukupnya, untuk hasil maksimal lakukan setiap hari secara rutin','tidak ada',2,20,24,2,4,5,'jamu_137.jpg');
INSERT INTO jamu VALUES(138,'bubuk herbal ajaib','merapatkan dan mengencangkan otot vagina, mengeringkan miss v yang basah, sama-sama meberikan kenikmatan dan kebahagiaan hubungan suami istri','','ambil bubuk sedikit, letakkan dijari yang telah dibersihkan masukkan ke miss v ','tidak ada',3,20,24,2,4,5,'jamu_138.jpg');
INSERT INTO jamu VALUES(139,'butiran putri delima','merapatkan dan mengencangkan otot vagina, keset/kering bikin wanita percaya diri, sama-sama meberikan kenikmatan dan kebahagiaan hubungan suami-istri','','','tidak ada',1,20,24,2,4,5,'jamu_139.jpg');
INSERT INTO jamu VALUES(140,'penyubur kandungan','menguatkan rahim, menambah hormon menyuburkan kandungan','','1x sehari 1 sdm','tidak ada',5,20,24,2,4,5,'jamu_140.jpg');
INSERT INTO jamu VALUES(141,'setanggi zahra','bermanfaat sebagai aromatherapy menenangkan  hati dan menambah keintiman suami istri','gaharu, melati, kasturi, kulit jeruk, dll','dibakar dengan batu bara/arang atau dengan peralatan aromatherapy. Aroma yang muncul dapat langsung di uapkan pada rambut atau pakaian','tidak ada',NULL,20,24,2,4,5,'jamu_141.jpg');
INSERT INTO jamu VALUES(142,'timung / mandi uap','melancarkan peredaran darah, mengeluarkan keringat berlebih, membakar lemak, mengharumkan badan, membuat badan segar, harum dan berseri','','rebus 1 atas 1/2 bungkus ramuantimung dengan air +- 1 liter','tidak ada',NULL,20,24,2,4,5,'jamu_142.jpg');
INSERT INTO jamu VALUES(143,'hormolak','menstabilkan hormon laki-laki yang sangat diperlukan untuk produksi sperma, memberikan suplement tambahan sehingga produksi sperma dapat lebih maksimal, mempercepat produksi sperma dan memperbanyak jumlah cairan sprema, menghangatkan badan, mengurangi ejakulasi dini','','setiap hari 1 sdm disampur kuning telur (tambahkan madu jika suka rasa manis) dan air panas secukupnya','tidak ada',5,20,24,2,4,5,'jamu_143.jpg');
INSERT INTO jamu VALUES(144,'lintah hitam papua','melancarkan sirkulasi darah, mengencangkan otot-otot yang kendor, meningkatkan kajantanan pria, mengobati lemah syahwat, ejakulasi dini, memperbesar dan memperpanjang penis.','','oleskan keseluruh alat vital secara merata, kemudia diurut dari pangkal sampai keujung satu arah selama 5-10 menit setiap hari (minimal sehari sekali), diutamakan waktu pagi (bangun tidur pagi), dilakukan secara rutin dalam waktu singkat','tidak ada',8,20,24,2,4,5,'jamu_144.jpg');
INSERT INTO jamu VALUES(145,'jamu gemuk sehat','membantu memperbaiki nafsu makan, menambah berat badan, menyelaraskan alat-alat pencernaan tubuh, menghilangkan letih, lesu, lemah dan kurang bersemangat','Ekstrak daun carica/papaya, Ekstrak akar curcuma biru, Ekstrak akar kunyit, Ekstrak akar kencur asli, Ekstrak akar kunyit domestika','2x sehari 4 kapsul sesudah makan pagi dan malam','tidak ada',7,21,25,2,2,5,'jamu_145.jpg');
INSERT INTO jamu VALUES(146,'jamu sepet madura *empot-empot)','membantu mengurangi lendir yang berlebihan pada daerah kewanitaan, memperkuat otot-otot vagina untuk membuat denyut-denyut istimewa pada vagina, mengeraskan otot vagina, menghilangkan keputihan dan gatal-gatal','Ekstrak biji jintan hitam, kstrak kulit kayu massalah, Ekstrak biji ketumbar, Ekstrak kulit pohon paramaria','2x sehari 4 kapsul sesudah makan pagi dan malam','tidak ada',7,21,25,2,2,5,'jamu_146.jpg');
INSERT INTO jamu VALUES(147,'PLUNTUR(TERLAMBAT BULAN)','sangat efektif untuk wanita yang sering terlambat bulan, datang bulan tidak teratur, sakit badan pada waktu datang bulan (dianjurkan untuk keterlambat) yang tidak lebih dari tiga bulan','Rumput kampung hitam, Temulawak Cina atau ijo, Salam gajah atau kayu salam, Jintan hitam, Cengkih asli atau kencur','2 x 1 bungkus setiap hari (pagi dan malam)','tidak ada',3,21,25,2,1,5,'jamu_147.jpg');
INSERT INTO jamu VALUES(148,'Jamu Tradisional Madura','amandel, tekanan darah tinggi, asma, kencing batu, lever, alergi, lemah jantung, kurang nafsu makan, asam urat, pegal linu, kencing manis, ginjal, reumatik, sakit gigi, magh, exsim, kurang darah','daun carica/papaya, akar carica/papaya, akar curcuma biru, akar jahe, akar kunyit, biji koffe/kopi','1 hari 1x pada malam hari, 1 sendok makan + 1/2 gelas air hangat untuk dewasa, 1 sendok teh + 1/2 gelas air hangat untuk anak-anak','tidak ada',3,22,26,4,2,5,'jamu_148.jpg');
INSERT INTO jamu VALUES(149,'Lulur Bengkoang','mengangkat sel-sel kulit mati, menghilangkan jerawat, flex hitam juga memutihkan kulit','','1 sdm lulur tambahkan air mawar, lalu digosokkan pada wajah juga seluruh badan, biarkan sampai kering  lalu bilas','tidak ada',3,23,27,2,NULL,14,'jamu_149.jpg');
INSERT INTO jamu VALUES(150,'pintu surga','bermanfaat untuk perawatan kewanitaan dan juga menuntaskan keputihan','','langsung dioleskan ke daerah v','tidak ada',3,23,28,2,NULL,14,'jamu_150.jpg');
INSERT INTO jamu VALUES(151,'jamu manjakani','merapetkan vagina, bikin keset untuk keputihan dan juga menyehatkan badan','Buah Sirih Hutan (Boesenbergia rotunda), Buah Pinang (Areca catechu), Daun Sirih (Piper betle)','','tidak ada',7,23,27,2,NULL,14,'jamu_151.jpg');
INSERT INTO jamu VALUES(152,'air cewok','bikin keset, merapetkan, menghilangkan keputihan juga menghilangkan bau daerah v','','ambil separuh air cewok rebus sampai mendidih, disaring lalu di tambah air dicebokin ke kemaluan / berendam, ampasnya bisa ditambah air lagi sampai bening','tidak ada',3,23,29,2,NULL,14,'jamu_152.jpg');
INSERT INTO jamu VALUES(153,'jamu melahirkan','ibu dan bayi menjadi sehat dan bugar','temulawak, kunyit,temu ireng, jahe, daun beluntas, daun serat, daun sirih, daun pepaya, daun asam, kasimbu''an','2x sehari 1 gelas pagi dan sore selama 20 hari','tidak ada',3,24,30,3,NULL,6,'jamu_153.jpg');
INSERT INTO jamu VALUES(154,'sehat lelaki','hubungan suami istri lebih intim, untuk kejantanan lelaku','jahe, temulawak, temu ireng, kunyit, pinang muda','seminggu 1 kali 1 gelas','tidak ada',3,24,30,3,NULL,6,'jamu_154.jpg');
INSERT INTO jamu VALUES(155,'sehat wanita','untuk keputihan, stamina wanita, hubungan suami istri lebih intim','temulawak, kunyit, manjakani, jelebi, jekkeleng','seminggu 1 kali 1 gelas','tidak ada',3,24,30,3,NULL,6,'jamu_155.jpg');
INSERT INTO jamu VALUES(156,'salekarang','untuk flu, batuk, sakit gigi, pusing','temu ireng, temulawak sambiroto','seminggu 1 kali 1 gelas','tidak ada',3,24,30,3,'',6,'jamu_158.jpg');
INSERT INTO jamu VALUES(157,'Kopi racikan madura','Menjaga organ hati, membantu membersihkan saluran pencernaan, membantu membakar lemak, mencegah penyakit jantung, diabetes','kopi','','tidak ada',3,23,29,2,NULL,14,'jamu_157.jpg');
INSERT INTO jamu VALUES(158,'dupa kemanten','mengharumkan tubuh, baju, juga ruangan. Harumnya lengket sepanjang hari','','','',3,23,31,2,NULL,14,'jamu_158.jpg');
INSERT INTO jamu VALUES(159,'galian singset','membantu mengurangi lemak, membuat badan menjadi langsing','','','',NULL,21,25,2,2,5,'jamu_159.jpg');
INSERT INTO jamu VALUES(160,'jamu jerawat','membantu mengatasi jerawat, menjaga kulit tetap halus bercahaya','','','',NULL,21,25,2,2,5,'jamu_160.jpg');
INSERT INTO jamu VALUES(161,'jamu pelangsing(bobot idaman)','menurunkan berat badan sesuai dengan idaman, menahan bobot badan supaya tidak gemuk berlebihan, mengontrol kadar lemak bagian perut','','','',NULL,21,25,2,2,5,'jamu_161.jpg');
INSERT INTO jamu VALUES(162,'jamu pegel linu','sangat berkhasiat menyembuhkan pegel-pegel linu otot-otot anda, menyembuhkan penyakit rheumatic/encok dan sakit pinggang','','','',NULL,21,25,2,2,5,'jamu_162.jpg');
INSERT INTO jamu VALUES(163,'jamu nifas (pluntur)','sangat efektif untuk wanita yang sering terlambat bulan, datang bulan tidak teratur, sakit-sakit badan waktu datang bulan','','','',NULL,21,25,2,2,5,'jamu_163.jpg');
INSERT INTO jamu VALUES(164,'sehat lelaki (perkasa lelaki)','Memperkuat fungsi lelaki serta meningkatkan katahanan kejantanan','','','',NULL,21,25,2,2,5,'jamu_164.jpg');
INSERT INTO jamu VALUES(165,'sepet madura(empot-empotan','membuat denyut-denyut istimewa yang khas, memperkuat otot-otot kewanitaan, menghilangkan bau tidak enak gatal-gatal dan keputihan','','','',NULL,21,25,2,2,5,'jamu_165.jpg');
INSERT INTO jamu VALUES(166,'sehat perempuan(montok payudaya)','mengencangkan payudara, memperbesar payudara yang kurang ideal, menyehatkan dan memperindah payudara','','','',NULL,21,25,2,2,5,'jamu_166.jpg');
INSERT INTO jamu VALUES(167,'sari harum(keputihan)','sangat mujarab dan benar-benar ampuh untuk segala macam keputihan yang lama maupun yang baru. Menghilangkan bau yang tidak enak, gatal-gatal dll','','','',NULL,21,25,2,2,5,'jamu_167.jpg');
INSERT INTO jamu VALUES(168,'awet ayu','membuat dan menjaga kulit tubuh anda segar halus dan bercahaya, mengencangkan seluruh otot-otot tubuh anda agar tetap singset. Menjaga tubuh tetap sehat dan segar selalu','','','',NULL,21,25,2,2,5,'jamu_168.jpg');
INSERT INTO jamu VALUES(169,'SUPER SEHAT BURUNG WALET','Insya Allah sangat ampuh untuk mencegah dan menyembuhkan Reumatik, Asam urat, Tekanan darah tinggi, Asma, Maag, Ginjal, Tipes, Cacingan, Sakit gigi, Lemah syahwat, Gatal-gatal alergi, Paru-paru basah, Kurang nafsu makan, Melancarkan Sirkulasi darah, Jerawat, Bisul, Kudis, Panu, Merawat Ms.V, Mengatasi keputihan, Merawat dan mengencangkan kulit, Mencegah dan mengatasi penyakit menahun, Kelumpuhan/badan mati separuh seperti Stroke, Kanker, Liver, Kencing manis basah/kencing manis kering, Menjaga dan menambah daya tahan tubuh.','Rimpang Kunyit,Rimpang Kencur, Rimpang Jahe, Herba Sambiloto','pengobatan, dewasa 1 sendok makan 2x sehari. Anak-anak 1/2 sendok makan 2x sehari diseduh dengan air matang 200 ml. untuk menjaga badan tetap sehat dan bugar diminum rutin 1x sehari','Jamu walet super sehat dapat mengakibatkan sering buang air besar, sering buang air kecil, keringat berlebih, mual dan muntah, namun efek samping berikut hanya bersifat sementara sesuai dengan tingkat/level penyakit yang diderita.',3,25,26,4,1,15,'jamu_169.jpg');
INSERT INTO jamu VALUES(170,'SUPER KUAT BURUNG WALET','Insyaallah sangat ampuh untuk menambah kepuasan Sex, Tahan keluarnya air sperma, menambah kejantanan, mengencangkan otot dzakar, menguatkan dan mengobati impoten yang menahun, merangsang dan mempercepat hidupnya dzakar, menambah energi baru setelah berhubungan, mengganti sel-sel tubuh yang aus, mengobati lesu, loyo, sakit pinggang, sakit kepala, dan menambah daya tahan tubuh dan menambah vitalitas pria dan wanita.','10% Ekstrak Kopi Rempah, 15% Kulit Batang Kayu Manis (Cassia), 20% Daun Psidium','Sehari 2 bungkus diminum pagi dan sore/malam 25menit-1 jam sebelum tidur (Boleh dicampur dengan telur ayam kampung dan madu) Untuk menjaga tubuh tetap sehat diminum 1 hari sekali.','',3,25,26,4,1,15,'jamu_170.jpg');
INSERT INTO jamu VALUES(171,'KOPI JANTAN ANTI DIABETES','Insya Allah sangat ampuh untuk mengatasi penyakit diabetes, lemah syahwat, ejakulasi dini, meningkatkan libido, menambah stamina, vitalitas dan meningkatkan daya tahan tubuh pria dan wanita.','15% Ekstrak Kopi Rempah, 10% Ekstrak Andrografis, 20% Ekstrak Akar Ginseng, 20% Ekstrak Rimpang Jahe Merah, Dan bahan lainnya hingga total 100%.','Terapi pengobatan sehari 2 bungkus diminum pagi dan malam hari. Untuk menjaga tubuh tetap sehat 1 bungkus diminum satu kali sehari.','',3,25,26,4,1,15,'jamu_171.jpg.jpeg');
INSERT INTO jamu VALUES(172,'MADU Ruqyah','Insya Allah dapat mencegah dan Menyembuhkan segala macam penyakit: Diabetes, Kolesterol, Asam Urat, Asam Lambung, Alergi, Ginjal, Asthma, Maag, Darah Tinggi, Lever, Kanker, Kusta, Stroke, Lumpuh, Keputihan, Meningkatkan gairah sex pria/wanita, kesulitan mendapatkan keturunan, Gangguan Jin/Psikis, dan kena Sihir/Santet','Madu Pahit, Sarang Burung Walet, Habbatus Saudah','2X sehari, 1 sendok makan diseduh dengan air hangat 200ml, diminum sebelum makan dan sebelum tidur. untuk mendapat hasil maksimal diminum secara rutin dan teratur.','',2,25,26,4,1,15,'jamu_172.jpg');
INSERT INTO jamu VALUES(173,'SUSU SUPER SEHAT GOLD','Mengatasi kencing manis basah/kering, Diabetes, Asam urat, Liver, Kanker, Mudah lesu/loyo/letih/kurang semangat atau kurang energik, Merawat dan memperkuat otot Mr.P, Menambah stamina pria dan wanita, Merawat dan mengencangkan Ms V, Mengatasi keputihan, Lendir berlebih pada Ms,V, Bau badan tidak sedap, Kurang darah, Jerawat, bisul, kudis dan sejenisnya, Merawat, mengencangkan dan mengatasi kulit mati/ mudah kering, Menambah nafsu makan, baik untuk dewasa ataupun bagi anak-anak(usia minimal 5 tahun), Menambah berat badan dengan menambah nafsu makan, DII, intinya MULTI KHAS','Terbuat dari biji kedelai pilihan, sarang burung walet, pemanis alami dari sari bunga dan tebu, akar tanaman, dan bahan-bahan khsus lainnya yang 100 alami dan asli dari madura','Aman diminum sebelum atau sesudah makan, namun kami anjurkan untuk diminum sesudah makan dan 2 jam sebelum tidur','',3,25,26,4,1,15,'jamu_173.jpg');
INSERT INTO jamu VALUES(174,'SUBUR KANDUNGAN','dapat menyuburkan kandungan. Baik untuk ibu yang baru keguguran','','','',NULL,26,NULL,3,1,15,'jamu_174.jpg');
INSERT INTO jamu VALUES(175,'SABUN CAIR SIRIH','harum dan keset pembersih daerah khusus kewanitaan','','','',2,27,NULL,NULL,NULL,15,'jamu_175.jpg');
INSERT INTO jamu VALUES(176,'krim rondo ayu','Khasiat dapat mengencangkan payudara yang turun. Disarankan diminum dengan kapsul montok payudara untuk hasil yang maksimal.','','','',8,26,NULL,3,NULL,9,'jamu_176.jpg');
INSERT INTO jamu VALUES(177,'harum rempah spray(perfume)','Dapat menghilangkan bau badan. Bisa digunakan untuk ketiak, leher, kaki, dan rambut.','','','',2,26,NULL,3,NULL,9,'jamu_177.jpg');
INSERT INTO jamu VALUES(178,'virginity spray','dapat membuat wangi bagian bawah','','','',2,26,NULL,3,NULL,9,'jamu_178.jpg');
INSERT INTO jamu VALUES(179,'empot-empot ayam super','Menggairahkan kembali hubungan suami istri, Menyerap kelebihan lendir (keputihan), Mencegah dan menghilangkan bau tidak sedap pada bagian kewanitaan dan menghilangkan bau badan, Mengencangkan kembali ototÂ² kewanitaan setelah melahirkan, Mengembalikan kegadisan / keperawanan, Tidak dianjurkan diminum ketika sedang masa haid/masa nifas','','','',1,26,NULL,3,NULL,9,'jamu_179.jpg');
INSERT INTO jamu VALUES(180,'galian rapet awet muda','Menggairahkan kembali hubungan suami istri, Menyerap kelebihan lendir (keputihan), Mencegah dan menghilangkan bau tidak sedap pada bagian kewanitaan dan menghilangkan bau badan, Dapat dikonsumsi oleh gadis / remaja, Mengembalikan kegadisan / keperawanan, Tidak dianjurkan diminum ketika sedang masa haid/masa nifas','','','',1,26,NULL,3,NULL,9,'jamu_180.jpg');
INSERT INTO jamu VALUES(181,'serbuk nikmat surga','Menambah rasa kenikmatan dalam bersetubuh, Menggairahkan kembali hubungan suami istri, Menyerap kelebihan lendir (keputihan), Menghilangkan bau tidak sedap pada bagian kewanitaan, Tidak dianjurkan diminum ketika sedang masa haid/masa nifas','','','',3,26,NULL,3,NULL,9,'jamu_181.jpg');
INSERT INTO jamu VALUES(182,'Bedak madu','Mengangkat selÂ² kulit mati, Mencegah timbulnya jerawat, Menghilangkan flek hitam di wajah, Menghilangkan mata panda, menghilangkan biang keringat','','','',1,26,NULL,3,NULL,9,'jamu_182.jpg');
INSERT INTO jamu VALUES(183,'Gemuk Sehat','Menambah nafsu makan, Membersihkan jerawat, Menghaluskan kulit, Menghilangkan bau mulut dan bau badan, Membuat tubuh padat berisi (montok), Menambah semangat kerja','10% Kayu Secang, 10% Kulit Batang Kayu Manis (Cassia), 15% Buah Fomiculli (Pastikan penulisan yang benar), 10% Bunga Cengkeh, Dan bahan lainnya hingga total 100%.','','',7,26,NULL,3,2,9,'jamu_183.jpg');
INSERT INTO jamu VALUES(184,'Montok Payudara','Membuat tubuh montok dan berisi, Melangsingkan dan menyingsetkan tubuh, Mengencangkan payudara, Menghilangkan pegalÂ² dan kecapean, Menambah semangat kerja, Menggantikan selÂ² kulit mati dengan segera, Kulit menjadi halus dan berseri','','','',7,26,NULL,3,1,9,'jamu_184.jpg');
INSERT INTO jamu VALUES(185,'Peluntur Lemak','Melarutkan lemak dalam tubuh, Mengurangi nafsu makan, Menyusutkan lemak perut, Menurunkan kolesterol, Melancarkan BAB','','','',7,26,NULL,3,2,9,'jamu_185.jpg');
INSERT INTO jamu VALUES(186,'empot-empotan','Mengobati keputihan, Menyehatkan / menyingsetkan badan, Menambah gairah hubungan suami-istri, Mengobati gatalÂ² dan menghilangkan bau badan dan bau mulut, Cocok bulanan, Menguatkan ototÂ² muda kembali','','','',7,26,NULL,3,2,9,'jamu_186.jpg');
INSERT INTO jamu VALUES(187,'Kuat Semangat Helbeh Mutiara','Mengatasi lemah syahwat, sakit pinggang, rematik, encok dll, Helbeh mutiara ini merangsang otot dan syaraf yang lemah pada seluruh organ tubuh, Menghilangkan jantung berdebar, letih, lesu, dan asam urat, Menghilangkan nyeri tulang dan tambah darah','','','',7,26,NULL,3,2,9,'jamu_187.jpg');
INSERT INTO jamu VALUES(188,'jamu kuat Helbeh Mutiara','Menghilangkan rasa letih, Menambah tenaga /energi, Mengobati lemah syahwat, Mengobati jantung berdebar, Menghilangkan sakit pinggang, Menghilangkan rematik/encok, Mengurangi asam urat, Menghancurkan batu ginjal','','','',2,26,NULL,3,2,9,'jamu_188.jpg');
INSERT INTO jamu VALUES(189,'jamu kuat pria dewasa semalam di madura','meningkatkan stamina dan daya tubuh pria','','','',NULL,28,NULL,NULL,1,NULL,'jamu_189.jpg');
INSERT INTO jamu VALUES(190,'jamu helbeh semangat ramuan herbal madura','menguatkan badan, mencerdaskan otak, mencegah reumatik, menambah semangat, menyembuhkan batuk asma, menyembuhkan sakit pinggang','','','',5,29,NULL,3,NULL,NULL,'jamu_190.jpg');
INSERT INTO jamu VALUES(191,'jamu sariwangi ramuan madura','untuk membantu menghilangkan bau mulut dan bau badan pada pria dan wanita, produk sari wangi ini merupakan jamu herbal yang bisa membantu menghilangkan bau mulut, bau badan dan keringat serta bau yang keluar dari tubuh manusia, dan juga bau yang keluar dari mulut yang bersumber dari perut dan pencernaan.','','','',7,30,NULL,2,NULL,16,'jamu_191.jpg');
INSERT INTO jamu VALUES(192,'Serimpang','','kunyit dan gula','larutkan 2 sdm ekstrak herbal kunyit dengan 150 ml air panas atau dingin','',3,31,NULL,1,3,NULL,'jamu_192.jpg');
INSERT INTO jamu VALUES(193,'Lancar darah','untuk melancarkan keluarnya darah pada waktu dan masa datang bulan, mencegah dan mengurangi sakit perut, sakit pinggang, pusing, dan nyeri yang timbul pada masa datang bulan','','','',NULL,1,NULL,1,1,NULL,'jamu_193.jpg');
INSERT INTO jamu VALUES(194,'jamu tradisional madura kecantikan','menjaga agr badan tetap sehat, segar, awet muda dan mencegah timbulnya jerawat, melangsingkan tubuh dan mengencangkan tubuh, mengurangi bau badan','','','',1,32,NULL,1,1,NULL,'jamu_194.jpg');
INSERT INTO jamu VALUES(195,'jamu gendong klasik madura(JKM)','Menjaga kebersihan Miss V, Mencegah keputihan, Menghilangkan bau tak sedap, Menghilangkan gatal - gatal, Mengurangi lendir berlebih, Merapatkan miss V, Empot - Empot, Membuat Miss V lebih keset dan harum, Mengencangkan otot - otot Miss V, Cocok untuk ibu menyusui, Melancarkan HAID, Mendetox kotoran yg ada pada rahim','','','',1,33,NULL,NULL,NULL,NULL,'jamu_195.jpg');
INSERT INTO jamu VALUES(196,'ramuan tradisional madura','asma, reumatik, tekanan darah tinggi, kencing manis, kencing batu, ginjal, amandel, tumor, migrain, lever alergi mag, mag, lemah jantung, exim, kurang nafsu makan, kurang darah, lemah syahwat, asam urat','','','',3,34,26,4,2,NULL,'jamu_196.jpg');
INSERT INTO jamu VALUES(197,'jamu sehat bugar','Membantu menyembuhkan, Asma, Sebagai obat Reumatik, Bisa mengobati Tekanan, Darah Tinggi, Dapat membantu menyembuhkan, Kencing Manis (diabetes), Dapat membantu menyembuhkan Kencing Batu, Bisa Membantu menyembuhkan Penyakit, Ginjal, Membantu menyembuhkan Amandel, Membantu Menyembuhkan,Tumor, Dapat membantu menyembuhkan, Migrain (sakit kepala), Bisa membantu menyembuhkan, Lever atau hepatitis, Dapat membantu menyembuhkan, Alergi, Bisa membantu menyembuhkan, Menyembuhkan Mag, Dapat membantu menyembuhkan, Lemah Jantung, Membantu , Mengobati Eksim (penyakit kulit), Menambah Nafsu makan, Bisa membantu menyembuhkan Kurang darah, Bisa membantu menyembuhkan Lemah, Syahwat, dan Dapat membantu menyembuhkan Asam Urat','temulawak 3,75 gram,  rimpang jahe 3 gram, kencur 3 gram, kayu manis 2,25 gram, laos 2,70, kopi arabica 0,30 gram','','',3,34,26,4,2,NULL,'jamu_197.jpg.jpeg');
INSERT INTO jamu VALUES(198,'galian singset (susut perut)','untuk mengurangi lemak dalam tubuh','30% Daun Guazumae, 10% Bunga Cengkeh, 15% Rimpang Temulawak, 15% Rimpang Jahe, 15% Kulit Batang Kayu Manis (Cassia), Dan bahan lainnya hingga total 100%.','','',5,35,32,2,2,16,'jamu_198.jpg');
INSERT INTO jamu VALUES(199,'super empot','Mengencangkan kembali otot otot kewanitaan, Mengurangi lendir berlebihan pada daerah kewanitaan, Memberikan kepuasan hubungan suami istri, Menjaga kesehatan wanita, Menjaga agar awet muda.','Kulit Buah Delima, bubuk Pronojiwo, Majakani,Akar Licorice Acutilobum, Kayu Rapet','2 x 5 pil sehari ( pada pagi dan malam / 30 menit setelah makan ). Jamu diminum sebanyak 5 pil , yaitu pagi waktu 30 menit sesudah dan petang sesudah makan malam','',1,35,33,2,2,16,'jamu_199.jpg');
INSERT INTO jamu VALUES(200,'super rapet','membantu mengurangi lendir','','3xsehari 5 butir.','',1,35,34,2,2,16,'jamu_200.jpg');
INSERT INTO jamu VALUES(201,'JAMU PEGEL LINU','mengatasi gatal2 dan bau yg kurang sedap pada wanita','','','',1,35,35,2,2,16,'jamu_201.jpg');
INSERT INTO jamu VALUES(202,'galian rapet','rapat mencengkram saat berhubungan intim.hingga melestarikan hubungan suami istri ','','3 x sehari @5 pil sekali minum ','',1,35,36,2,2,16,'jamu_202.jpg');
INSERT INTO jamu VALUES(203,'jamu dalimah putih','dan selalu awet muda','','3 x sehari @ 5 biji','',1,35,37,2,2,16,'jamu_203.jpg');
INSERT INTO jamu VALUES(204,'GALIAN SEHAT / MONTOK','Pil jamu ramuan Madura untuk wanita / pria yang kurang nafsu makan, berbadan kurus, muka pucat, sering sakit, badan lemah dan lain-lain. Minumlah jamu ini secara teratur supaya badan jadi sehat, segar dan montok padat berisi.','Rimpang Kunyit,Rimpang Temulawak, Rimpang Lengkuas,Buah Kabesak','Minum 3 x 5 pil / hari.','',1,35,38,2,2,16,'jamu_204.jpg');
INSERT INTO jamu VALUES(205,'minyak zaitun','Mangencangkan dan menghaluskan kulit muka dan seluruh tubuh (kulit bersisik, pecah-pecah dan kasar), dan sebagai pengganti pelembab dan bisa juga untuk minyak urut/pijat baik untuk dewasa dan anak/bayi.','','Oleskan minyak zaitun secukupnya bagian kulit/tubuh yang dikehendaki.','',2,35,39,2,2,16,'jamu_205.jpg');
INSERT INTO jamu VALUES(206,'super pria','Menyembuhkan lemah syahwat dan impotensi pada laki laki, Menambah gairah bagi pria.','Biji Benalu,batang tumbuhan, biji pinang 20%, kulit kering  20% Dan bahan lain sampai 100%','','',1,35,40,2,2,16,'jamu_206.jpg');
INSERT INTO sqlite_sequence VALUES('jenis',8);
INSERT INTO sqlite_sequence VALUES('produsen',35);
INSERT INTO sqlite_sequence VALUES('kabupaten',4);
INSERT INTO sqlite_sequence VALUES('perizinan',4);
INSERT INTO sqlite_sequence VALUES('lokasi_pemasaran',16);
INSERT INTO sqlite_sequence VALUES('lokasi_produksi',40);
INSERT INTO sqlite_sequence VALUES('jamu',207);
--COMMIT;
