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
                <div class="flex space-x-8">
                    <!-- Card 1 - Updated color to blue -->
                    <div class="bg-blue-300 overflow-hidden shadow-sm sm:rounded-lg h-full flex-1 p-4">
                        <div class="p-6 text-gray-900 dark:text-gray-100">
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

                    <!-- Card 2 - Updated color to orange -->
                    <div class="bg-orange-300 overflow-hidden shadow-sm sm:rounded-lg h-full flex-1 p-4">
                        <div class="p-6 text-gray-900 dark:text-gray-100">
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

                    <!-- Card 3 - Updated color to teal -->
                    <div class="bg-teal-300 overflow-hidden shadow-sm sm:rounded-lg h-full flex-1 p-4">
                        <div class="p-6 text-gray-900 dark:text-gray-100">
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
