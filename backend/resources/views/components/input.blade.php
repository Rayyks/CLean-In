<!-- resources/views/components/input.blade.php -->
<!-- Include Toastr CSS and JS -->



<script>
    function checkLaundryWeight() {
        var beratInput = document.getElementById('berat');

        if (parseFloat(beratInput.value) === 0) {
            // Use Toastr to display a warning
            toastr.warning('Berat barang masih 0. Silakan isi berat barang terlebih dahulu.');
            return false;
        } else {
            return true;
        }
    }
</script>

<div class="p-4">
    <div id="warningMessage" class="bg-red-100 text-red-700 p-2 mb-4 rounded-md hidden">
        Warning: Berat barang masih 0. Silakan isi berat barang.
    </div>

    <h2 class="text-2xl font-bold mb-2">Proses Pemesanan</h2>
    <p class="mb-4">Nama User: {{ $pesanan_laundry->name }}</p>

    <form onsubmit="return checkLaundryWeight()" method="post" action="{{ route('pesanan.update', ['id' => $pesanan_laundry->id]) }}">
        @csrf
        @method('put')

        <label for="berat" class="block mb-1">Berat barang:</label>
        <input type="text" id="berat" name="berat" class="w-full border p-2 mb-2" placeholder="Masukkan berat barang">

        <label for="harga" class="block mb-1">Harga total:</label>
        <input type="text" id="harga" name="harga" class="w-full border p-2 mb-4" placeholder="Masukkan harga total">

        @foreach(json_decode($pesanan_laundry->laundry_items) as $item)
            <p class="mb-1">{{ $item->quantity }}x {{ $item->item }}</p>
        @endforeach

        <h3 class="text-xl font-bold mt-10 mb-2">Status Pemesanan</h3>

        <div class="grid grid-cols-5 gap-4">
            <div class="flex items-center">
                <label for="cuci" class="inline-flex items-center">
                    <input type="checkbox" id="cuci" name="status[]" value="Cuci" class="form-checkbox h-5 w-5 text-gray-600">
                    <span class="ml-2">Cuci</span>
                </label>
            </div>

            <div class="flex items-center">
                <label for="setrika" class="inline-flex items-center">
                    <input type="checkbox" id="setrika" name="status[]" value="Setrika" class="form-checkbox h-5 w-5 text-gray-600">
                    <span class="ml-2">Setrika</span>
                </label>
            </div>

            <div class="flex items-center">
                <label for="packing" class="inline-flex items-center">
                    <input type="checkbox" id="packing" name="status[]" value="Packing" class="form-checkbox h-5 w-5 text-gray-600">
                    <span class="ml-2">Packing</span>
                </label>
            </div>

            <div class="flex items-center">
                <label for="kirim" class="inline-flex items-center">
                    <input type="checkbox" id="kirim" name="status[]" value="Kirim" class="form-checkbox h-5 w-5 text-gray-600">
                    <span class="ml-2">Kirim</span>
                </label>
            </div>

            <div class="flex items-center">
                <label for="pembayaran" class="inline-flex items-center">
                    <input type="checkbox" id="pembayaran" name="status[]" value="Pembayaran" class="form-checkbox h-5 w-5 text-gray-600">
                    <span class="ml-2">Pembayaran</span>
                </label>
            </div>
        </div>

        <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Update Status</button>
    </form>
</div>
