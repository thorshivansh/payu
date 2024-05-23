<?php
echo header('content-type: application/json');
if(isset($_POST['hashName']) &&  isset($_POST['hashString'])){
    $merchantSalt = "";
    $merchantSecretKey = "";
    $hashName = $_POST['hashName'];
    $hashStringWithoutSalt = $_POST['hashString'];
    $hashType = $_POST['hashType'] ?? null;
    $postSalt = $_POST['postSalt'] ??  null;
    $hash = "";
    if ($hashType == "V2") {
      $hash = getHmacSHA256Hash($hashStringWithoutSalt, $merchantSalt);
    } else if ($hashName == "mcpLookup") {
      $hash = getHmacSHA1Hash($hashStringWithoutSalt, $merchantSecretKey);
    } else {
      $hashDataWithSalt = $hashStringWithoutSalt . $merchantSalt;
      if ($postSalt != null) {
        $hashDataWithSalt = $hashDataWithSalt . $postSalt;
      }
      $hash = getSHA512Hash($hashDataWithSalt);
    }
    $finalHash = [$hashName => $hash];
}

echo json_encode($finalHash);
exit();
  function getSHA512Hash($hashData) {
    $hash = hash("sha512", $hashData);
    return $hash;
  }
  function getHmacSHA256Hash($hashData, $salt) {
    $hmacSha256 = hash_hmac("sha256", $hashData, $salt);
    $hmacBase64 = base64_encode($hmacSha256);
    return $hmacBase64;
  }
  function getHmacSHA1Hash($hashData, $salt) {
    $hmacSha1 = hash_hmac("sha1", $hashData, $salt); // HMAC-SHA1
    $hash = $hmacSha1;
    return $hash;
  }

?>