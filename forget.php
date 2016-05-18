<?php
 session_start();
include "includes/db_connect.php"; 
include_once 'securimage/securimage.php';


if(isset($_POST['submit'])){
  $securimage = new Securimage();
if ($securimage->check($_POST['captcha_code']) == false) {

  echo "The security code entered was incorrect.<br /><br />";

  echo "Please go <a href='javascript:history.go(-1)'>back</a> and try again.";

  exit;

}
else{

$email=filter_var(mysqli_real_escape_string($connection,$_POST['email']),FILTER_SANITIZE_EMAIL);
$tmpass = md5($email + microtime());

$gender = $_POST['optradio'];
//check for if the email already exist in the database
    $sqlemail = "SELECT email FROM user WHERE email = '$email'";
      
    $retemail = mysqli_query($connection,$sqlemail);
                if(! $retemail )
                    {
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }

                      if(mysqli_num_rows($retemail) > 0 ){
                         $sql = "UPDATE user SET password = '$tmpass' WHERE email = '$email' AND active = 1";

      
            $retpass = mysqli_query($connection,$sql);
                if(! $retpass )
                    {
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }
                     else{
                      //send email to user with new password
                   
    $from = "admin@pinstories.com";
    $headers ="From: $from\n";
    $headers .= "MIME-Version: 1.0\n";
    $headers .= "Content-type: text/html; charset=iso-8859-1 \n";
    $subject ="pinstories.com Temporary Password";
    $msg = '<h2>Dear user:</h2><p>This is an automated message from pinstories.com. If you did not recently initiate the Forgot Password process, please disregard this email.</p><p>You indicated that you forgot your login password. We can generate a temporary password for you to log in with, then once logged in you can change your password to anything you like.</p><p>Your temporary password to login will be:<br /><b>'.$tmpass.'</b></p><br/><p>After you logged in, Click <b>My Profile</b> ->  <b>Reset Password</b> button to reset your password.</p>';
    if(mail($email,$subject,$msg,$headers)) {
      echo '<script language="javascript">';
        echo 'alert("Please check your email box for temporary password. ")';
        echo '</script>';
          echo '<script language="javascript">';
          echo 'window.location = "http://pinstories.com"';
          echo '</script>';
    
    } else {
      echo "email_send_failed";
      exit();
    }

                        
                     }
                      }
                      else{
                        echo '<script language="javascript">';
                        echo 'alert("email already not registered, please try another email")';
                        echo '</script>';

                      }
}
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</head>
<body>

<div class="container">
  <h2>Forget Password</h2>
  <form action="forget.php"role="form" method="post">
    <div class="form-group">
      <label for="email">Email:</label>
      <input type="email" class="form-control" id="email" name="email" placeholder="Enter email to receive your password." required>
    </div>
    <img id="captcha" src="/securimage/securimage_show.php" alt="CAPTCHA Image" />
    <input type="text" name="captcha_code" size="10" maxlength="6" />
    <a href="#" onclick="document.getElementById('captcha').src = '/securimage/securimage_show.php?' + Math.random(); return false">[ Different Image ]</a>
    <br>
    <br>
    <button type="submit" class="btn btn-success" name="submit">Submit</button>
  </form>
</div>

</body>
</html>
