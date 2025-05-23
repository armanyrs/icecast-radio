TUGAS AKHIR SEMESTER
Web Streaming Radio Lokal dengan Fitur Switch Input Real-Time Menggunakan Icecast dan Liquidsoap



Penjelasan System :<br>
•	Sumber Input: Berasal dari folder kumpulan lagu, file jingle, dan input live dari mic penyiar.<br>
•	Encoder (Liquidsoap): Menggabungkan semua sumber input, mengatur kapan mic atau playlist yang aktif, dan memproses output stream. Kontrol switching mic dilakukan via Telnet yang terhubung ke antarmuka web.<br>
•	Server Streaming (Icecast): Menerima stream dari Liquidsoap dan menyediakannya dalam bentuk mount point yang dapat diakses banyak pengguna secara bersamaan.<br>
•	Web UI Radio (Apache Web Server): Menampilkan pemutar audio yang bisa diakses siapa saja melalui browser.<br>
•	Web UI Kontrol Admin: Antarmuka khusus penyiar untuk menghidupkan atau mematikan input mic secara real-time.
