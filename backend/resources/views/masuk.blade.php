<!-- resources/views/layouts/app.blade.php -->

<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Hi, Admin') }}
        </h2>
    </x-slot>

    <div class="flex h-screen">
        <!-- Komponen Masuk -->
        <div class="flex-1 py-12">
            @foreach ($pesanan_laundry as $index => $pesanan)
                <a href="{{ $pesanan->status === 'selesai' ? route('selesai') : route('detail.page', ['id' => $pesanan->id]) }}">
                    <div class="flex items-center justify-between w-full p-4 bg-white shadow-md mb-4 rounded-lg border-l-4" style="border-color: 
                        @switch($pesanan->status)
                            @case('selesai') green @break
                            @case('proses') orange @break
                            @case('packing') orange @break
                            @case('kirim') orange @break
                            @case('sampai') orange @break
                            @case('pending') red @break
                            @default white
                        @endswitch
                    ">
                        <!-- Bagian Kiri -->
                        <div class="flex items-center">
                            <div class="font-bold text-lg text-gray-800">
                                {{ $index + 1 }}. {{ $pesanan->name }}
                                <span class="text-md ml-2" style="color: @switch($pesanan->status)
                                        @case('selesai') black @break
                                        @case('proses') black @break
                                        @case('packing') black @break
                                        @case('kirim') black @break
                                        @case('sampai') black @break
                                        @case('pending') black @break
                                        @default white
                                    @endswitch">
                                    ({{ $pesanan->status }})
                                </span>
                            </div>
                        </div>

                        <!-- Bagian Kanan -->
                        <div class="flex space-x-4">
                            @if($pesanan->status !== 'selesai')
                                <a href="{{ route('detail.page', ['id' => $pesanan->id]) }}" class="bg-red-500 text-white px-4 py-2 rounded-full">Detail</a>
                                <a href="{{ route('proses.page', ['id' => $pesanan->id]) }}" class="bg-blue-500 text-white px-4 py-2 rounded-full">Ubah</a>
                            @endif

                             <!-- Add the delete button -->
                            <form action="{{ route('delete.pesanan', ['id' => $pesanan->id]) }}" method="post">
                                @csrf
                                @method('delete')
                                <button type="submit" class="bg-gray-500 text-white px-4 py-2 rounded-full">Delete</button>
                            </form>

                            @if(Auth::user() && Auth::user()->role === 'admin' && $pesanan->status === 'pending')
                                <form action="{{ route('terima.pesanan', ['id' => $pesanan->id]) }}" method="post">
                                    @csrf
                                    @method('put')
                                    <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded-full">Terima</button>
                                </form>
                            @endif

                            @if(Auth::user() && Auth::user()->role === 'admin')
                                <form action="{{ route('pesanan.update', ['id' => $pesanan->id]) }}" method="post">
                                    @csrf
                                    @method('put')
                                    <input type="hidden" name="status" value="Pending"> 
                                </form>
                            @endif
                        </div>
                    </div>
                </a>
            @endforeach
        </div>
    </div>
</x-app-layout>
