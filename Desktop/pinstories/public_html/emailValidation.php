<?php include "includes/db_connect.php";
	 ob_start();
   session_start();
 ?>
<?php
$e = $_SESSION['email1'];
$p = $_SESSION['ha'] ;
$u = $_SESSION['first'];
/*to active your account.        \n".$_SESSION['ha'] ;

// use wordwrap() if lines are longer than 70 characters
$msg = wordwrap($msg,70);

mail($emailaddress,"Email confirmation from Pinstories.com",$msg);
*/


$to = "$e";              
    $from = "admin@pinstories.com";
    $subject = 'pinstories.com Account Activation';
    $message = '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Pinstories Message</title></head><body style="margin:0px; font-family:Tahoma, Geneva, sans-serif;"><div style="padding:10px; background:#ffcc00; font-size:24px; color:#ffffff;"><a href="http://www.pinstories.com"><img src="http://www.pinstories.com/images/logo.png" width="36" height="30" alt="pinstories" style="border:none; float:left;"></a>Pinstories Account Activation</div><div style="padding:24px; font-size:17px;">Hello '.$u.',<br /><br />Click the link below to activate your account:<br /><br /><a href="http://www.pinstories.com/activation.php?u='.$u.'&e='.$e.'&p='.$p.'">Click here to activate your account now</a><br /><br />Login after successful activation using your:<br /> E-mail Address: <b>'.$e.'</b></div></body></html>';
    $headers = "From: $from\n";
        $headers .= "MIME-Version: 1.0\n";
        $headers .= "Content-type: text/html; charset=iso-8859-1\n";
    mail($e, $subject, $message, $headers);




/*if($mail){
  echo "Thank you for using our mail form";
}else{
  echo "Mail sending failed."; 
}
*/
//echo !user_active($emailaddress);
/*if(isset($_POST['confirm'])){
	$hasht = mysqli_real_escape_string($connection,$_POST['emailcode']);
if(!user_active($emailaddress)){
	if($hasht == $hashValue && strlen($hasht) == 32){
$sql = "UPDATE user SET active = 1 WHERE email = '$emailaddress' AND hash = '$hashValue'";
$retval = mysqli_query($connection,$sql);
 					 if(! $retval )
                    {
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }
                      mysqli_close($connection);
                      $_SESSION['valid'] = true;
echo '<script language="javascript">';
echo 'alert("Active Success, Logging ... ")';
echo '</script>';
echo '<script language="javascript">';
echo 'window.location = "http://pinstories.com/mainApp.php"';
echo '</script>';
}

/*else{
	echo '<script language="javascript">';
      echo 'alert("wrong active code ")';
      echo '</script>'	
}

}
else{
	echo '<script language="javascript">';
      echo 'alert("email is already activated! please log in ")';
      echo '</script>';
      echo '<script language="javascript">';
       echo 'window.location = "http://pinstories.com/index.php"';
       echo '</script>';
}
}*/
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
</head>
<body>
<div class="container">
    
    <div class="col-sm-6">
    <div class="row">
            <h4>Congratulations,<?php echo $_SESSION['first'];?>!</h4>
            <h5> Please check your email box to activate your account.</h5>
            </div>
            
            <!--
        <form action="emailValidation.php" method="post">
            <div class="form-group">
            <label for="emailcode">Please check your mailbox and paste activate code below</label>
            <input type="text" name="emailcode" class="form-control">
            </div>
            </form>
            -->
            <a href="http://www.pinstories.com" class="btn btn-success">Sign In</a>
            
        
        
    </div>


</div>
</body>
</html>