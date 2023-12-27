<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Models\PesananLaundry;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;

class PesananController extends Controller
{
    // Create a new PesananLaundry
    public function create(Request $request)
    {
        $user = $request->user();

        $pickupAt = Carbon::parse($request->input('pickup_at'));
        $deliveryAt = null;

        $pesananLaundry = PesananLaundry::create([
            'user_id' => $user->id,
            'name' => $user->name,
            'address' => $user->address,
            'laundry_type' => $request->input('laundry_type'),
            'detergen_type' => $request->input('detergen_type'),
            'pickup_at' => $pickupAt,
            'delivery_at' => $deliveryAt,
            'laundry_items' => $request->input('laundry_items'), 
        ]);

        // Create a corresponding payment record
        $payment = Payment::create([
            'pesanan_laundry_id' => $pesananLaundry->id,
            'status' => 'pending',
            
        ]);

        return response()->json(['pesanan_laundry' => $pesananLaundry]);
    }

    // Get a list of all PesananLaundry for the authenticated user
    public function index(Request $request)
    {
        $user = $request->user();
    
        // Check if the user has the 'admin' or 'pelanggan' role
        if ($user->role !== 'admin' && $user->role !== 'pelanggan') {
            abort(403, 'Unauthorized action.');
        }
    
        // If the user is an admin or pelanggan, retrieve PesananLaundry based on their role
        if ($user->role === 'admin') {
            $pesananLaundry = PesananLaundry::all();
        } else {
            $pesananLaundry = PesananLaundry::where('user_id', $user->id)->get();
        }
    
        if (!$pesananLaundry) {
            return response()->json(['message' => 'Pesanan tidak ada'], 404);
        }
    
        return response()->json(['pesanan_laundry' => $pesananLaundry]);
    }

    // Get a specific PesananLaundry by ID
    public function show($id)
    {
        $pesananLaundry = PesananLaundry::find($id);

        if (!$pesananLaundry) {
            return response()->json(['pesanan_laundry' => null, 'message' => 'Pesanan tidak ada'], 404);
        }

        return response()->json(['pesanan_laundry' => $pesananLaundry]);
    }

    // TERIMA PESANAN LOGIC
    public function terimaPesanan($id)
    {
        $pesananLaundry = PesananLaundry::find($id);

        if (!$pesananLaundry) {
            return response()->json(['message' => 'Pesanan not found'], 404);
        }

        // Ensure the authenticated user is an admin before updating the status
        $user = Auth::user();
        if (!$user || $user->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Update the status to 'Terima'
        $pesananLaundry->update(['status' => 'terima']);

        return redirect()->route('masuk');
    }

    // DetailController.php
    public function showDetailPage($id)
    {
        $pesananLaundry = PesananLaundry::find($id);

        if (!$pesananLaundry) {
            abort(404, 'Pesanan not found');
        }

        return view('detail', ['pesanan_laundry' => $pesananLaundry]);
    }

    // Show proses
    public function showProsesPage($id)
    {
        $pesananLaundry = PesananLaundry::find($id);

        if (!$pesananLaundry) {
            abort(404, 'Pesanan not found');
        }

        return view('proses', ['pesanan_laundry' => $pesananLaundry]);
    }

    public function getMasukCount()
    {
        return PesananLaundry::where('status', 'terima')->count();
    }

    public function getProsesCount()
    {
        return PesananLaundry::where('status', 'proses')->count();
    }

    public function getSelesaiCount()
    {
        return PesananLaundry::where('status', 'Selesai')->count();
    }

     // Add a new method to update payment status
    public function updatePaymentStatus(Request $request, $id)
    {
        $pesananLaundry = PesananLaundry::find($id);

        if (!$pesananLaundry) {
            return response()->json(['message' => 'Pesanan not found'], 404);
        }

        $payment = $pesananLaundry->payment;

        if (!$payment) {
            return response()->json(['message' => 'Payment not found'], 404);
        }

        $payment->update(['status' => 'selesai']);

        return response()->json(['message' => 'Payment status updated successfully']);
    }

    // Update a PesananLaundry by ID
    public function update(Request $request, $id)
    {
        $pesananLaundry = PesananLaundry::find($id);

        if (!$pesananLaundry) {
            return response()->json(['message' => 'Pesanan not found'], 404);
        }

        $request->validate([
            'laundry_weight' => 'numeric|min:0',
            'price' => 'numeric|min:0',
            'status' => 'string',
            'rating' => 'integer|min:1|max:5',
        ]);
         // Update the rating if provided in the request
        if ($request->has('rating')) {
            $pesananLaundry->update(['rating' => $request->input('rating')]);
        }

        // Check if the price is greater than 0 before updating the status and payment
        if ($request->input('price') > 0) {
            // Manually set the attributes and fire the updating event
            $pesananLaundry->fill($request->all())->save();

            // Update the status to 'selesai' if provided in the request
            if ($request->has('status') && $request->input('status') === 'selesai') {
                $pesananLaundry->update(['status' => 'selesai']);

                // Also update the payment status
                $this->updatePaymentStatus($request, $id);
            }
            
            return redirect()->route('masuk');
        } else {
            // If the price is 0, update the status in the payment table to 'selesai'
            $payment = Payment::where('pesanan_laundry_id', $pesananLaundry->id)->first();

            if ($payment) {
                $payment->update(['status' => 'selesai']);
            }

            // Remove the payment method when the price is still 0,00
            return response()->json(['message' => 'Pesanan updated successfully']);
        }
    }


    // Helper function to calculate the new price
    private function calculateNewPrice($laundryWeight, $laundryType)
    {
        $defaultPricePerKg = 0;

        switch ($laundryType) {
            case 'Premium':
                $calculatedPrice = $laundryWeight * 1000;
                break;
            case 'Cuci Setrika':
                $calculatedPrice = $laundryWeight * 1000;
                break;
            case 'Cuci Kering':
                $calculatedPrice = $laundryWeight * 1000;
                break;
            case 'Setrika':
                $calculatedPrice = $laundryWeight * 1000;
                break;
            case 'Khusus':
                $calculatedPrice = $laundryWeight * 2000;
                break;
            default:
                $calculatedPrice = $laundryWeight * $defaultPricePerKg;
                break;
        }

        // Ensure the calculated price is rounded to 2 decimal places
        $formattedPrice = number_format(round($calculatedPrice, 2), 2, '.', '');

        return $formattedPrice;
    }

    public function showSelesaiPage()
    {
        // Retrieve the completed orders from the database
        $selesaiOrders = PesananLaundry::where('status', 'Selesai')->get();

        // Pass the data to the view
        return view('selesai', ['selesaiOrders' => $selesaiOrders]);
    }

    public function showLaporanPage()
    {
        // Retrieve the completed orders with both status from PesananLaundry and Payments tables
        $laporanPesanan = PesananLaundry::where('status', 'Selesai')
            ->with(['payment' => function ($query) {
                $query->select('id', 'status', 'pesanan_laundry_id');
            }])
            ->get();
    
        // Pass the data to the view
        return view('laporan', ['laporanPesanan' => $laporanPesanan]);
    }

    // Delete a PesananLaundry by ID
    public function destroy($id)
    {
        $pesananLaundry = PesananLaundry::find($id);

        if (!$pesananLaundry) {
            return response()->json(['message' => 'Pesanan not found'], 404);
        }

        $pesananLaundry->delete();

        return redirect()->route('selesai');
    }

    public function delete($id)
    {
        // Find the order by id and delete it
        PesananLaundry::findOrFail($id)->delete();

        // Redirect back or to a different page after deletion
        return redirect()->back();
    }

    // Payment 
    public function getPaymentDetails($id)
    {
        $pesananLaundry = PesananLaundry::find($id);

        if (!$pesananLaundry) {
            return response()->json(['message' => 'Pesanan not found'], 404);
        }

        // Assuming payment details are stored in the 'payments' table
        $paymentDetails = $pesananLaundry->payment;

        return response()->json(['payment_details' => $paymentDetails]);
    }
}
