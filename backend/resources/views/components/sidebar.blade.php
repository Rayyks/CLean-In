<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script defer src="https://unpkg.com/alpinejs@2.8.2/dist/alpine.min.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css" />
    <title>Resizable Sidebar</title>
</head>

<body class="bg-gray-100 text-gray-700">

    <!-- page -->
    <main class="min-h-screen bg-gray-200 text-gray-700" x-data="layout">
        <!-- header page -->
        <div class="flex">
            <!-- aside -->
            <aside class="flex flex-col border-r-2 border-gray-200 bg-white h-full p-2 transition-all duration-300"
                :class="{ 'w-64': asideOpen, 'w-16': !asideOpen }">
                <a href="/dashboard"
                    class="flex items-center space-x-2 p-3 hover:bg-gray-100 hover:text-blue-600 transition-all duration-300">
                    <span class="text-2xl"><i class="bx bx-home"></i></span>
                    <span x-show="asideOpen">Home</span>
                </a>

                <a href="/update"
                    class="flex items-center space-x-2 p-3 hover:bg-gray-100 hover:text-blue-600 transition-all duration-300">
                    <span class="text-2xl"><i class="bx bx-timer"></i></span>
                    <span x-show="asideOpen">Update</span>
                </a>

                <a href="/laporan"
                    class="flex items-center space-x-2 p-3 hover:bg-gray-100 hover:text-blue-600 transition-all duration-300">
                    <span class="text-2xl"><i class="bx bx-detail"></i></span>
                    <span x-show="asideOpen">Laporan</span>
                </a>
            </aside>

            <!-- main content page -->
        </div>
    </main>

    <style>
        :root {
            --sidebar-width: 16rem; /* Lebar sidebar saat terbuka */
            --sidebar-closed-width: 5rem; /* Lebar sidebar saat tertutup */
        }
    </style>

    <script>
        document.addEventListener("alpine:init", () => {
            Alpine.data("layout", () => ({
                profileOpen: false,
                asideOpen: true,
            }));
        });
    </script>
</body>

</html>
