# CLEAN.IN

**Highly recommend to read the installation guide 😊**

### buka 4 terminal di vscode (di saranin pakek terminal git biar cepat) baru cd ./backend : arahin ke folder backend (u know la caranya gimana)
lalu ketik

```
composer install
```

### Jalankan perintah berikut untuk mengatur _environment variable_ tapi kalo dah ada `.env` di folder backnednya ga perlu lakuin ini lagi

```
cp .env.example .env
```

### Pastikan Anda telah membuat database baru di MySQL dan silakan sesuaikan file `.env` dengan database Anda. Jalankan perintah berikut untuk membuat _key_ untuk web app Anda

```
php artisan key:generate
```

### Jalankan perintah berikut untuk menghubungkan folder public Anda dengan storage

```
php artisan storage:link
```

### Jalankan perintah berikut untuk membuat skema database

```
php artisan migrate
```

### Terakhir, jalankan perintah berikut untuk menyalakan web server bawaan laravel

```
php artisan serve
```

### Di terminal baru lagi, masuk ke folder backend lalu jalankan ini

```
npm i && npm run dev
```

### DI bagian Flutter code nya (terminal baru)

jalanin ini

```
flutter upgrade && flutter run
```

### kalo make ide android studio itu udah otomatis jalanin ke virtual androidnya / tapi kalo ga ada pilih nomor 2 (web)

## Lalu jangan lupa ke mode inspect biar ada fitur mobilenya karena nanti bakal make scroll down reload untuk update datanya, terus pilih ini 

![image](https://github.com/Rayyks/CLEAN.IN/assets/95673499/d472f475-09f2-4f7d-a34b-717939714d42)

terus pilih aja ip 14 pro

 ![image](https://github.com/Rayyks/CLEAN.IN/assets/95673499/d29ea501-d942-4f0e-873a-672d21b44d01)

and you good to go 
