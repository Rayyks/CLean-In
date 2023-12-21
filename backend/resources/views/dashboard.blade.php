<!-- resources/views/layouts/app.blade.php -->

<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Hi, Admin') }}
        </h2>
    </x-slot>

    <div class="flex h-screen">
        

        <!-- Main Content -->
        <div class="flex-1 py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-7">
                <div class="flex space-x-8"> <!-- Menambahkan space-x-8 untuk memberikan jarak yang lebih besar antara card -->
                    <!-- Card 1 -->
                    <div class="bg-red-300 overflow-hidden shadow-sm sm:rounded-lg h-full flex-1 p-4">
                        <div class="p-6 text-gray-900 dark:text-gray-100">
                            <!-- Struktur HTML untuk teks di kiri dan di kanan -->
                            <div class="flex justify-between">
                                <div class="text-lg">
                                    {{ __("Masuk") }}
                                </div>
                                <div>
                                {{ $masukCount }}

                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2 -->
                    <div class="bg-yellow-300 overflow-hidden shadow-sm sm:rounded-lg h-full flex-1 p-4">
                        <div class="p-6 text-gray-900 dark:text-gray-100">
                            <!-- Struktur HTML untuk teks di kiri dan di kanan -->
                            <div class="flex justify-between">
                                <div class="text-lg">
                                    {{ __("Proses") }}
                                </div>
                                <div>
                                {{ $prosesCount }}


                                </div>
                            </div>
                        </div>
                    </div>
                    
                

                    <!-- Card 3 -->
                    <div class="bg-green-300 overflow-hidden shadow-sm sm:rounded-lg h-full flex-1 p-4">
                        <div class="p-6 text-gray-900 dark:text-gray-100">
                            <!-- Struktur HTML untuk teks di kiri dan di kanan -->
                            <div class="flex justify-between">
                                <div class="text-lg">
                                    {{ __("Selesai") }}
                                </div>
                                <div>
                                {{ $selesaiCount }}

                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <!-- SHOW CHART -->
            <div class="mt-10">
                <x-chart
                    :masukCount="$masukCount"
                    :prosesCount="$prosesCount"
                    :selesaiCount="$selesaiCount"
                />
                <!-- SHOW CHART -->
           </div>
        </div>
    </div>
</x-app-layout>
