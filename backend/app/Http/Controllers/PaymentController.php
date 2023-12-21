<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    // Create a new payment
    public function create(Request $request)
    {
        $request->validate([
            'pesanan_laundry_id' => 'required|exists:pesanan_laundry,id',
            'status' => 'required|string',
            // Add validation for other payment fields as needed
        ]);

        $payment = Payment::create($request->all());

        return response()->json(['payment' => $payment]);
    }

    // Get payment details by pesanan_laundry_id
    public function getPaymentDetails($pesananLaundryId)
    {
        $payment = Payment::where('pesanan_laundry_id', $pesananLaundryId)->first();

        if (!$payment) {
            return response()->json(['message' => 'Payment not found'], 404);
        }

        return response()->json(['payment' => $payment]);
    }

    public function updatePaymentStatus(Request $request, $id)
    {
        $payment = Payment::find($id);

        if (!$payment) {
            return response()->json(['message' => 'Payment not found'], 404);
        }

        $request->validate([
            'status' => 'required|string',
        ]);

        $payment->update(['status' => $request->input('status')]);

        return response()->json(['message' => 'Payment status updated successfully']);
    }

    public function checkPaymentStatus($id)
    {
        try {
            $payment = Payment::where('pesanan_laundry_id', $id)->first();

            if ($payment) {
                return response()->json(['status' => $payment->status]);
            } else {
                return response()->json(['status' => 'unpaid']);
            }
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}