<!-- resources/views/components/akhir.blade.php -->

<!-- Pastikan Anda telah menyertakan link FontAwesome di bagian head HTML Anda -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-...">


<div class="container mx-auto p-8" id="printableArea">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold">Data Pemesanan</h1>

        <!-- Fitur Pencarian -->
        <div class="flex items-center">
            <button class="bg-yellow-400 text-white px-4 py-2 rounded">
                <a href="{{ route('masuk') }}">Semua Pesanan</a>
            </button>
            <label for="search" class="text-lg mr-2">Cari:</label>
            <input type="text" id="search" class="border p-2">
            <button class="bg-blue-500 text-white py-2 px-4 ml-2 rounded">
                <i class="fas fa-search"></i>
            </button>
        </div>
    </div>

    <div class="overflow-x-auto">
        <table class="w-full bg-white border-collapse border border-gray-300 rounded-lg">
            <thead class="bg-gray-200 divide-y divide-gray-300">
                <tr>
                    <td class="py-2 text-lg px-4">No</td>
                    <td class="py-2 text-lg px-4">Nama Pemesan</td>
                    <td class="py-2 text-lg px-4">Status</td>
                    <td class="py-2 text-lg px-4">Aksi</td> <!-- Add a new column for actions -->
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-300">
                <!-- Isi tabel di sini -->
                @foreach($selesaiOrders as $index => $order)
                    <tr>
                        <td class="py-2 px-4">{{ $index + 1 }}</td>
                        <td class="py-2 px-4">{{ $order->name }}</td>
                        <td class="py-2 px-4">{{ $order->status }}</td>
                        <td class="py-2 px-4">
                            {{-- Action buttons --}}
                            <div class="flex items-center space-x-2">
                                {{-- Rollback button --}}
                                @if(Auth::user() && Auth::user()->role === 'admin')
                                    <form action="{{ route('pesanan.update', ['id' => $order->id]) }}" method="post" class="inline-block">
                                        @csrf
                                        @method('put')
                                        <input type="hidden" name="status" value="Pending">
                                        <button type="submit" class="bg-yellow-400 text-white px-3 py-1 rounded hover:bg-yellow-500 focus:outline-none focus:shadow-outline-yellow">Rollback</button>
                                    </form>

                                    {{-- Delete button --}}
                                    <form action="{{ route('pesanan.destroy', ['id' => $order->id]) }}" method="post" class="inline-block">
                                        @csrf
                                        @method('delete')
                                        <button type="submit" class="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 focus:outline-none focus:shadow-outline-red">Delete</button>
                                    </form>
                                @endif
                            </div>
                        </td>
                    </tr>
                @endforeach
                <!-- Tambahkan baris lain jika diperlukan -->
            </tbody>
        </table>
    </div>
</div>