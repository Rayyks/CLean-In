<?php

namespace App\Events;

use App\Models\PesananLaundry;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class PesananStatusChanged
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $pesananLaundry;
    public $notificationMessage;

    /**
     * Create a new event instance.
     *
     * @param PesananLaundry $pesananLaundry
     * @param string $notificationMessage
     */
    public function __construct(PesananLaundry $pesananLaundry, $notificationMessage)
    {
        $this->pesananLaundry = $pesananLaundry;
        $this->notificationMessage = $notificationMessage;
    }
}
