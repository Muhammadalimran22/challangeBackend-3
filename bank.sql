CREATE TABLE Nasabah (
    ID_Nasabah SERIAL PRIMARY KEY,
    Nama_Nasabah VARCHAR(255),
    Alamat VARCHAR(255),
    Nomor_Telepon VARCHAR(15),
    Tanggal_Lahir DATE
);

CREATE TABLE Akun (
    Nomor_Akun SERIAL PRIMARY KEY,
    Jenis_Akun VARCHAR(50),
    Saldo DECIMAL(10, 2),
    Tanggal_Pembukaan DATE,
    ID_Nasabah INT REFERENCES Nasabah(ID_Nasabah)
);

CREATE TABLE Transaksi (
    ID_Transaksi SERIAL PRIMARY KEY,
    Tanggal_Transaksi DATE,
    Jenis_Transaksi VARCHAR(50),
    Jumlah DECIMAL(10, 2),
    Nomor_Akun INT REFERENCES Akun(Nomor_Akun)
);

INSERT INTO Nasabah (Nama_Nasabah, Alamat, Nomor_Telepon, Tanggal_Lahir)
VALUES 
    ('muhammad al imran 1', 'aceh 1', '081397648082', '2002-11-23'),
    ('muhammad al imran 2', 'aceh 2', '081397648082', '2002-11-23'),
    ('muhammad al imran 3', 'aceh 3', '081397648082', '2002-11-23'),
    ('muhammad al imran 4', 'aceh 4', '081397648082', '2002-11-23'),
    ('muhammad al imran 5', 'aceh 5', '081397648082', '2002-11-23');
   
INSERT INTO Akun (Nomor_Akun, Jenis_Akun, Saldo, Tanggal_Pembukaan, ID_Nasabah)
VALUES 
	(1, 'tabungan', 100000, '2023-09-22', 1),
	(2, 'giro', 100000, '2023-09-22', 1),
	(3, 'deposito', 100000, '2023-09-22', 1),
	(4, 'tabungan', 10000, '2023-09-22', 2),
	(5, 'giro', 300000, '2023-09-22', 2),
	(6, 'deposito', 200000, '2023-09-22', 2),
	(7, 'tabungan', 200000, '2023-09-22', 3),
	(8, 'giro', 40000, '2023-09-22', 3),
	(9, 'deposito', 400000, '2023-09-22', 3),
	(10, 'giro', 300000, '2023-09-22', 4),
	(11, 'deposito', 100000, '2023-09-22', 5),
	(12, 'giro', 100000, '2023-09-22', 5);

INSERT INTO Transaksi (ID_Transaksi, Tanggal_Transaksi, Jenis_Transaksi, Jumlah, Nomor_Akun) 
VALUES 
	(1, '2023-08-10', 'Debit', 50000, 1),
	(2, '2023-08-10', 'Kredit', 50000, 2),
	(3, '2023-08-10', 'Transfer', 50000, 3),
	(4, '2023-08-10', 'Transfer', 50000, 6),
	(5, '2023-08-10', 'Debit', 50000, 7),
	(6, '2023-08-10', 'Kredit', 50000, 8),
	(7, '2023-08-10', 'Debit', 50000, 10),
	(8, '2023-08-10', 'Debit', 50000, 12);

UPDATE nasabah SET nama_nasabah = 'muhammad al imran 2' WHERE id_nasabah = 2;

SELECT nasabah.nama_nasabah, nasabah.alamat, akun.nomor_akun, akun.jenis_akun, akun.saldo 
FROM nasabah 
LEFT JOIN akun ON nasabah.id_nasabah = akun.id_nasabah
ORDER BY nasabah.nama_nasabah;

SELECT nasabah.nama_nasabah, akun.nomor_akun, akun.jenis_akun, akun.saldo AS saldo_awal,
	t.tanggal_transaksi, t.jenis_transaksi,
	(akun.saldo + sum(CASE WHEN t.jenis_transaksi = 'debit' THEN -t.jumlah ELSE t.jumlah END )) AS saldo_akhir
FROM nasabah 
JOIN akun ON nasabah.id_nasabah = akun.id_nasabah 
LEFT JOIN transaksi t ON akun.nomor_akun = t.nomor_akun 
WHERE t.tanggal_transaksi IS NOT NULL 
GROUP BY nasabah.nama_nasabah, akun.nomor_akun, akun.jenis_akun, akun.saldo, t.tanggal_transaksi, t.jenis_transaksi
ORDER BY nasabah.nama_nasabah, akun.nomor_akun, t.tanggal_transaksi;

-- cte
WITH Transaksi AS (
    SELECT nasabah.nama_nasabah, akun.nomor_akun, akun.jenis_akun, akun.saldo AS saldo_awal,
           t.tanggal_transaksi, t.jenis_transaksi,
           (akun.saldo + SUM(CASE WHEN t.jenis_transaksi = 'debit' THEN -t.jumlah ELSE t.jumlah END)) AS saldo_akhir
    FROM nasabah
    JOIN akun ON nasabah.id_nasabah = akun.id_nasabah
    LEFT JOIN transaksi t ON akun.nomor_akun = t.nomor_akun
    WHERE t.tanggal_transaksi IS NOT NULL
    GROUP BY nasabah.nama_nasabah, akun.nomor_akun, akun.jenis_akun, akun.saldo, t.tanggal_transaksi, t.jenis_transaksi
)
SELECT * FROM Transaksi
ORDER BY nama_nasabah, nomor_akun, tanggal_transaksi;

 