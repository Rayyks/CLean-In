
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div style="width:70%;">
    <canvas id="statusChart" width="400" height="200"></canvas>
</div>


<script>
    document.addEventListener('DOMContentLoaded', function () {
       
        var masukCount = {{ $masukCount }};
        var prosesCount = {{ $prosesCount }};
        var selesaiCount = {{ $selesaiCount }}; 

        var ctx = document.getElementById('statusChart').getContext('2d');

        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Masuk', 'Proses', 'Selesai'],
                datasets: [{
                    label: 'Pesanan Status',
                    data: [masukCount, prosesCount, selesaiCount],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.5)',
                        'rgba(54, 162, 235, 0.5)',
                       
                        'rgba(75, 192, 192, 0.5)',
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                 
                        'rgba(75, 192, 192, 1)',
                    ],
                    borderWidth: 1,
                }],
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                    },
                },
            },
        });
    });
</script>
