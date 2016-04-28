<?php include "db_connect.php"; ?>

<?php

function user_active($email){
$email1 = mysqli_real_escape_string($email);
$sql = "SELECT active, email FROM user WHERE email = '$email1' AND active = 1";
$retval = mysqli_query($connection,$sql);
if(mysqli_num_rows($retval) > 0 ){
	return true;
}
else{

	return false;
}
mysqli_close($connection);

}
function RandomString($length = 15) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

function get_FirstName($email){
$email1 = mysqli_real_escape_string($email);
$sql = "SELECT first_name FROM user WHERE email = '$email1' AND active = 1";
$retval = mysqli_query($connection,$sql);
if(mysqli_num_rows($retval) > 0 ){
	$row=mysqli_fetch_assoc($retval);
	return $row["first_name"];
}
else{

	return "hello";
}
mysqli_close($connection);
}
?>