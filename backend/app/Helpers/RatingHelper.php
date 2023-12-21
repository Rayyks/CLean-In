

<?php

function convertRatingToWord($rating) {
    switch ($rating) {
        case 1:
            return 'Buruk';
        case 2:
            return 'Lumayan';
        case 3:
            return 'Cukup Baik';
        case 4:
            return 'Baik';
        case 5:
            return 'Sempurna';
        default:
            return '';
    }
}
