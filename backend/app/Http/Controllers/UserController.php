<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function register(Request $request)
    {
        $fields = $request->validate([
            'name' => 'required|string',
            'email' => 'required|string|unique:users,email',
            'password' => 'required|string',
            'address' => 'required|string',
            'phone' => 'required|string|unique:users,phone',
        ]);

        $user = User::create([
            'name' => $fields['name'],
            'email' => $fields['email'],
            'password' => bcrypt($fields['password']),
            'address' => $fields['address'],
            'phone' => $fields['phone'],
            'role' => 'pelanggan',
        ]);

        // Return a response without including the token
        $response = [
            'user' => $user,
            'message' => 'Registration successful!',
        ];

        return response($response, 201);
    }

    public function login(Request $request)
    {
        $fields = $request->validate([
            'email' => 'required|string',
            'password' => 'required|string',
        ]);

        // Check email
        $user = User::where('email', $fields['email'])->first();

        // Check password
        if (!$user || !Hash::check($fields['password'], $user->password)) {
            return response([
                'message' => 'Invalid Credentials',
            ], 401);
        }

        // Create token only during the login process
        $token = $user->createToken('myapptoken')->plainTextToken;

        $response = [
            'user' => $user,
            'token' => $token,
        ];

        return response($response, 201);
    }

    public function update(Request $request)
    {
        $user = auth()->user(); // Get the authenticated user

        $fields = $request->validate([
            'name' => 'string',
            'email' => 'string|unique:users,email,' . $user->id,
            'password' => 'string',
            'address' => 'string',
            'phone' => 'string|unique:users,phone,' . $user->id,
        ]);

        // Update user fields
        $user->update([
            'name' => $fields['name'] ?? $user->name,
            'email' => $fields['email'] ?? $user->email,
            'password' => isset($fields['password']) ? bcrypt($fields['password']) : $user->password,
            'address' => $fields['address'] ?? $user->address,
            'phone' => $fields['phone'] ?? $user->phone,
        ]);

        // Return a response
        $response = [
            'user' => $user,
            'message' => 'User details updated successfully!',
        ];

        return response($response, 200);
    }

    public function logout(Request $request)
    {
        Auth::user()->tokens()->delete();

        return [
            'message' => 'Logged out',
        ];
    }
}
