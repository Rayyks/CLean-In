<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Hi, Admin') }}
        </h2>
    </x-slot>

    <div class="flex h-screen">
        <!-- Komponen Dual Text -->
        <div class="flex-1 py-12 m-auto">
            <div class="max-w-md mx-auto bg-white p-6 rounded-md shadow-md">
                <h2 class="font-bold mb-4">Detail Pemesanan</h2>
                
                <p class="mb-4">Nama: {{ $pesanan_laundry->name }}</p>
                <p class="mb-4">Alamat: {{ $pesanan_laundry->address }}</p>
                <p class="mb-4">Jam/Tgl Penjemputan: {{ $pesanan_laundry->pickup_at }}</p>
                <p class="mb-4">Jam/Tgl Pemulangan: {{ $pesanan_laundry->delivery_at }}</p>
                <p class="mb-4">Jenis Pencucian: {{ $pesanan_laundry->laundry_type }}</p>
                <p class="mb-4">Jenis Detergen: {{ $pesanan_laundry->detergen_type }}</p>
                
                <p class="font-bold mb-4">Item Laundry:</p>
                <ul>
                    @foreach(json_decode($pesanan_laundry->laundry_items) as $item)
                        <li>{{ $item->quantity }} {{ $item->item }}</li>
                    @endforeach
                </ul>
                
                <div class="mt-8 text-right">
                    <a href="{{ route('proses.page', ['id' => $pesanan_laundry->id]) }}" class="text-blue-500 hover:underline">Proses</a>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
