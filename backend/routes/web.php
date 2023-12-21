<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DetailController;
use App\Http\Controllers\InputController;
use App\Http\Controllers\PesananController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('auth.login');
});

Route::get('/dashboard', function () {
    $pesananController = new PesananController();

    return view('dashboard', [
        'masukCount' => $pesananController->getMasukCount(),
        'prosesCount' => $pesananController->getProsesCount(),
        'selesaiCount' => $pesananController->getSelesaiCount(),
    ]);
})->middleware(['auth', 'verified'])->name('dashboard');

Route::get('/proses/{id}', [PesananController::class, 'showProsesPage'])->name('proses.page');
Route::put('/pesanan/{id}', [PesananController::class, 'update'])->name('pesanan.update');
Route::get('/masuk', function () {
    $request = app('request');
    $pesananLaundry = app(PesananController::class)->index($request)->original['pesanan_laundry'];

    return view('masuk', ['pesanan_laundry' => $pesananLaundry]);
})->middleware(['auth', 'verified'])->name('masuk');

Route::put('/terima-pesanan/{id}', [PesananController::class, 'terimaPesanan'])->name('terima.pesanan');

Route::get('/selesai', [PesananController::class, 'showSelesaiPage'])
    ->middleware(['auth', 'verified'])
    ->name('selesai');

Route::delete('/pesanan/{id}', [PesananController::class, 'destroy'])->name('pesanan.destroy');
Route::delete('/delete-pesanan/{id}', [PesananController::class, 'delete'])->name('delete.pesanan');

Route::get('/laporan', [PesananController::class, 'showLaporanPage'])
    ->middleware(['auth', 'verified'])
    ->name('laporan');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

Route::get('/detail/{id}', [PesananController::class, 'showDetailPage'])->name('detail.page');
Route::get('/input', [InputController::class, 'showUpdatePage'])->name('input.page');

require __DIR__.'/auth.php';
