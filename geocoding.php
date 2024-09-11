<?php

header("Cross-Origin-Embedder-Policy: require-corp");
header("Cross-Origin-Opener-Policy: same-origin");

header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Max-Age: 86400');    
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD'])){
       header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS"); // OPTION controle cross request
    }

    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'])){
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}, X-Requested-With, Content-Type, Accept");
    }
       
    header('HTTP/1.1 200 OK');

    exit(0);
}

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if(isset($data['address']) && !empty($data['address'])){
    
    // Clé API Google Maps GEOCODING
    $apiKey = "AIzaSyChOPnV0AfEaN5-r82jGeyUxVPlF9bD2o4"; // KEY DEMO

    // Address
    //$address = '1600 Amphitheatre Parkway, Mountain View, CA';
    $address = $data['address'];

    // URL API
    $url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' . urlencode($address) . '&key=' . $apiKey;
    
    // request POST GEOCODING
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [ "Content-Type: application/json" ]);
    curl_setopt($ch, CURLOPT_POST, true);

    $data_response = curl_exec($ch);
    if (curl_errno($ch)) {
        http_response_code(404);
        $array['success'] = false;
        $array['msg'] = 'Error curl : ' . curl_error($ch);
        echo json_encode($array,JSON_UNESCAPED_UNICODE);
    }
    curl_close($ch);

    $response = json_decode($data_response, true);
    $text_response = json_encode($response);

    http_response_code(200);
    $array['success'] = true;
    $array['msg'] = $text_response;
    echo json_encode($array,JSON_UNESCAPED_UNICODE);
}else{
    http_response_code(503);
    $array['success'] = false;
    $array['msg'] = 'Address empty';
    echo json_encode($array,JSON_UNESCAPED_UNICODE);
}
