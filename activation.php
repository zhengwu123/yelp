<?php include "includes/db_connect.php";
	 ob_start();
   session_start();
 ?>

<?php
if (isset($_GET['u']) && isset($_GET['e']) && isset($_GET['p'])) {
	$u = mysqli_real_escape_string($connection,$_GET['u']);
	$e = mysqli_real_escape_string($connection, $_GET['e']);
	$p = mysqli_real_escape_string($connection, $_GET['p']);
	
	// Evaluate the lengths of the incoming $_GET variable
	// Check their credentials against the database
	$sql = "SELECT * FROM user WHERE first_name ='$u' AND email='$e' AND hash='$p' LIMIT 1";
    $query = mysqli_query($connection, $sql);
	$numrows = mysqli_num_rows($query);
	// Evaluate for a match in the system (0 = no match, 1 = match)
	if($numrows == 0){
		// Log this potential hack attempt to text file and email details to yourself
		header("location: message.php?msg=Your credentials are not matching anything in our system");
    	exit();
	}
	// Match was found, you can activate them
	$sql = "UPDATE user SET active = 1 WHERE email ='$e' LIMIT 1";
    $query = mysqli_query($connection, $sql);
	// Optional double check to see if activated in fact now = 1
	$sql = "SELECT * FROM user WHERE email ='$e' AND active = 1 LIMIT 1";
    $query = mysqli_query($connection, $sql);
	$numrows = mysqli_num_rows($query);
	// Evaluate the double check
    if($numrows == 0){
		// Log this issue of no switch of activation field to 1
        header("location: message.php?msg=activation_failure");
    	exit();
    } else if($numrows == 1) {
		// Great everything went fine with activation!
        header("location: message.php?msg=activation_success");
    	exit();
    }
} else {
	// Log this issue of missing initial $_GET variables
	header("location: message.php?msg=missing_GET_variables");
    exit(); 
}
?>