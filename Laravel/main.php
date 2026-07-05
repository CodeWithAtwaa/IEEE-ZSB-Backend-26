<?php


echo PHP_EOL;
echo date("H:i:sa");
echo PHP_EOL;
// echo date_default_timezone_set("Egypt/Cairo");

if(checkdate(2, 29, 2024)){
    echo "This year is a leap year";
}else{
    echo "This year is not a leap year";
}
echo PHP_EOL;
$time = new DateTime();
echo $time->format('Y-m-d H:i:s');

echo PHP_EOL;

echo date_format($time, 'Y-m-d H:i:s');
echo PHP_EOL;
print_r(getdate());


// ============

