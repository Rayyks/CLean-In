<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    use HasFactory;

    protected $fillable = [
        'pesanan_laundry_id',
        'status',
        // Add other payment fields as needed
    ];

    public function pesananLaundry()
    {
        return $this->belongsTo(PesananLaundry::class);
    }
}
