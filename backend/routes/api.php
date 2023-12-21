<?php

use App\Http\Controllers\PaymentController;
use App\Http\Controllers\PesananController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
        
    });
    
    Route::put('/user/update', [App\Http\Controllers\UserController::class, 'update']);
    Route::post('/pesanan_laundry', [PesananController::class, 'create']);
    Route::get('/pesanan_laundry', [PesananController::class, 'index']);
    Route::patch('/pesanan_laundry/{id}', [PesananController::class, 'update']);
    Route::get('/pesanan_laundry/{id}', [PesananController::class, 'show']);
    Route::patch('/pesanan_laundry/{id}/payment', [PesananController::class, 'updatePaymentStatus']);
    Route::get('/payment/{id}/status', [PaymentController::class, 'checkPaymentStatus']);
});

Route::post('/register', [App\Http\Controllers\UserController::class, 'register']);
Route::post('/login', [App\Http\Controllers\UserController::class, 'login']);
Route::post('/logout', [App\Http\Controllers\UserController::class, 'logout']);