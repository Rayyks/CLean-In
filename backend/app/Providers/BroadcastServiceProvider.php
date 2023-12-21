<?php

namespace App\Providers;

use App\Models\PesananLaundry;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\ServiceProvider;

class BroadcastServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        require base_path('routes/channels.php');

        Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
            return (int) $user->id === (int) $id;
        });

        // Make sure the channel name matches exactly with the event
        Broadcast::channel('pesanan-status-changed.{pesananLaundry}', function ($user, PesananLaundry $pesananLaundry) {
            return true; // You can implement specific logic here if needed
        });
    }
}
