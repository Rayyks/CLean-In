<!-- resources/views/layouts/app.blade.php -->

<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Hi, Admin') }}
        </h2>
    </x-slot>

    <div class="flex h-screen">
        <div class="h-full w-full p-4">
            <!-- Include the Akhir Blade component here -->
            <!-- Pastikan Anda telah menyertakan link FontAwesome di bagian head HTML Anda -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-...">

            <div class="container mx-auto p-8">
                <div class="flex justify-between items-center mb-6">
                    <h1 class="text-3xl font-bold">Laporan Pesanan</h1>

                    <!-- Fitur Pencarian -->
                    <div class="flex items-center">
                        <button onclick="printTable()" class="bg-blue-500 text-white px-4 py-2 rounded">
                            Print Laporan
                        </button>
                        <label for="search" class="text-lg mr-2">Cari:</label>
                        <input type="text" id="search" class="border p-2">
                        <button class="bg-blue-500 text-white py-2 px-4 ml-2 rounded">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>

                <div class="overflow-x-auto" id="printableArea">
                <table class="w-full bg-white border-collapse border border-gray-300 rounded-lg">
                    <thead class="bg-gray-200 divide-y divide-gray-300">
                        <tr>
                            <td class="py-2 text-lg px-4">No</td>
                            <td class="py-2 text-lg px-4">Nama Pemesan</td>
                            <td class="py-2 text-lg px-4">Status</td>
                            <td class="py-2 text-lg px-4">Pembayaran</td>
                            <td class="py-2 text-lg px-4">Rating</td>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-300">
                        @foreach($laporanPesanan as $index => $order)
                            <tr>
                                <td class="py-2 px-4">{{ $index + 1 }}</td>
                                <td class="py-2 px-4">{{ $order->name }}</td>
                                <td class="py-2 px-4">{{ $order->status }}</td>
                                <td class="py-2 px-4">{{ optional($order->payment)->status }}</td>
                                <td class="py-2 px-4">
                                    <!-- {{-- Use the convertRatingToWord helper function here --}} -->
                                    {{ convertRatingToWord($order->rating) }}
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>

            <script>
                function printTable() {
                    var printContents = document.getElementById("printableArea").innerHTML;
                    var originalContents = document.body.innerHTML;

                    document.body.innerHTML = printContents;
                    window.print();

                    document.body.innerHTML = originalContents;
                }
            </script>
        </div>
    </div>
</x-app-layout>