<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PesananLaundry extends Model
{
    use HasFactory;

    protected $table = 'pesanan_laundry'; 

    protected $fillable = [
        'user_id',
        'name',
        'address',
        'laundry_type',
        'detergen_type',
        'status',
        'pickup_at',
        'delivery_at',
        'laundry_items',
        'laundry_weight',
        'price',
        'rating'
    ];

    public function payment()
    {
        return $this->hasOne(Payment::class);
    }
}
