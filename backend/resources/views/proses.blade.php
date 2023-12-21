<!-- resources/views/proses.blade.php -->

<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-white dark:text-gray-200 leading-tight">
            {{ __('Hi, Admin') }}
        </h2>
        <!-- Add the following lines at the top of your blade file, before any other scripts -->
    </x-slot>

    <div class="flex items-center justify-center h-screen text-white bg-white dark:bg-gray-800">
        <div class="p-4">
            <h2 class="text-2xl font-bold mb-2">Proses Pemesanan</h2>
            <p class="mb-4">Nama User: {{ $pesanan_laundry->name }}</p>

            <!-- Update the form to include the update button and add an ID to the form for JavaScript targeting -->
            <form id="updateForm" onsubmit="return checkLaundryWeight()" method="post" action="{{ route('pesanan.update', $pesanan_laundry->id) }}" enctype="multipart/form-data">
                @csrf
                @method('PUT')

                <label for="laundry_weight" class="block mb-1">Berat barang:</label>
                <!-- Add an ID to the input for JavaScript targeting -->
                <input type="text" id="laundry_weight" name="laundry_weight" class="text-black w-full border p-2 mb-2" placeholder="Masukkan berat barang" value="{{ $pesanan_laundry->laundry_weight }}">

                <label for="price" class="block mb-1">Harga total:</label>
                <!-- Update the input to be readonly, and add an ID for JavaScript targeting -->
                <input type="text" id="price" name="price" class="text-black w-full border p-2 mb-4" placeholder="Masukkan harga total" value="{{ $pesanan_laundry->price }}" readonly>

                <!-- Modify the following lines to dynamically display laundry items from the database -->
                @foreach(json_decode($pesanan_laundry->laundry_items) as $item)
                    <p class="mb-1">{{ $item->quantity }}x {{ $item->item }}</p>
                @endforeach

                <!-- Fitur Checkbox -->
                <h3 class="text-xl font-bold mt-10 mb-2">Status Pemesanan</h3>

                <div class="grid grid-cols-6 gap-4">
                    <!-- Modify the radio buttons to include the 'status' values -->
                    @foreach(['proses', 'packing', 'kirim', 'sampai', 'selesai'] as $status)
                        <div class="flex items-center">
                            <label for="{{ strtolower($status) }}" class="inline-flex items-center">
                                <input type="radio" id="{{ strtolower($status) }}" name="status" value="{{ $status }}" class="form-radio h-5 w-5 text-gray-600" {{ $pesanan_laundry->status === $status ? 'checked' : '' }}>
                                <span class="ml-2">{{ $status }}</span>
                            </label>
                        </div>
                    @endforeach
                </div>
                <label for="delivery_status" class="block mb-1 mt-5">Waktu Pengiriman:</label>
                <input type="datetime-local" id="delivery_status" name="delivery_at" class="text-black w-full border p-2 mb-2" value="{{ $pesanan_laundry->delivery_at ? Carbon\Carbon::parse($pesanan_laundry->delivery_at)->format('Y-m-d\TH:i') : '' }}">

                <p class="mb-4">Waktu Pengiriman: {{ $pesanan_laundry->delivery_at }}</p>

                <!-- Add the update button -->
                <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded-md mt-4">Update</button>
            </form>

            <!-- Add a script to calculate and update the price in real-time -->
            <script>
                document.getElementById('updateForm').addEventListener('submit', function (event) {
                    // Get the entered laundry weight
                    var laundryWeight = parseFloat(document.getElementById('laundry_weight').value) || 0;

                    // Check if the laundry weight is 0
                    if (laundryWeight === 0) {
                        // Use SweetAlert to display a warning
                        Swal.fire({
                            icon: 'warning',
                            title: 'Warning',
                            text: 'Berat barang masih 0. Silakan isi berat barang terlebih dahulu.',
                        });

                        // Prevent the form submission
                        event.preventDefault();
                    }
                });

                document.getElementById('laundry_weight').addEventListener('input', function () {
                    // Get the entered laundry weight
                    var laundryWeight = parseFloat(this.value) || 0;

                    // Calculate the new price (modify this calculation based on your logic)
                    var newPrice = laundryWeight * 10000; // Example calculation, update as needed

                    // Update the price input field
                    document.getElementById('price').value = newPrice.toFixed(2);
                });
            </script>
        </div>
    </div>
</x-app-layout>
