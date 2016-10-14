<?php 
include "includes/db_connect.php"; 
   ob_start();
   session_start();
  if (!$_SESSION['valid'])
header("Location: index.php");
?>
<?php
//these chunk of php code here is for update password.

if(isset($_POST['submit'])){

$password0 = mysqli_real_escape_string($connection,$_POST['pwd0']);
$password1 = mysqli_real_escape_string($connection,$_POST['pwd1']);
$password2 = mysqli_real_escape_string($connection,$_POST['pwd2']);
$email = $_SESSION['email'];

//check for if the email already exist in the database
$sql = "UPDATE user SET password = '$password1' WHERE email = '$email' AND active = 1";

      
            $retpass = mysqli_query($connection,$sql);
                if(! $retpass )
                    {
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }
                     else{
                    echo '<script language="javascript">';
                    echo 'alert("password reset success! ")';
                    echo '</script>';
}
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>profile page</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
  <style type="text/css">
.navbar-default {
  background-color: #f7ba02;
  border-color: #5bc02b;
}
.navbar-default .navbar-brand {
  color: #fbfbfb;
}
.navbar-default .navbar-brand:hover,
.navbar-default .navbar-brand:focus {
  color: #110910;
}
.navbar-default .navbar-text {
  color: #fbfbfb;
}
.navbar-default .navbar-nav > li > a {
  color: #fbfbfb;
}
.navbar-default .navbar-nav > li > a:hover,
.navbar-default .navbar-nav > li > a:focus {
  color: #110910;
}
.navbar-default .navbar-nav > .active > a,
.navbar-default .navbar-nav > .active > a:hover,
.navbar-default .navbar-nav > .active > a:focus {
  color: #110910;
  background-color: #5bc02b;
}
.navbar-default .navbar-nav > .open > a,
.navbar-default .navbar-nav > .open > a:hover,
.navbar-default .navbar-nav > .open > a:focus {
  color: #110910;
  background-color: #5bc02b;
}
.navbar-default .navbar-toggle {
  border-color: #5bc02b;
}
.navbar-default .navbar-toggle:hover,
.navbar-default .navbar-toggle:focus {
  background-color: #5bc02b;
}
.navbar-default .navbar-toggle .icon-bar {
  background-color: #fbfbfb;
}
.navbar-default .navbar-collapse,
.navbar-default .navbar-form {
  border-color: #fbfbfb;
}
.navbar-default .navbar-link {
  color: #fbfbfb;
}
.navbar-default .navbar-link:hover {
  color: #110910;
}

@media (max-width: 767px) {
  .navbar-default .navbar-nav .open .dropdown-menu > li > a {
    color: #fbfbfb;
  }
  .navbar-default .navbar-nav .open .dropdown-menu > li > a:hover,
  .navbar-default .navbar-nav .open .dropdown-menu > li > a:focus {
    color: #110910;
  }
  .navbar-default .navbar-nav .open .dropdown-menu > .active > a,
  .navbar-default .navbar-nav .open .dropdown-menu > .active > a:hover,
  .navbar-default .navbar-nav .open .dropdown-menu > .active > a:focus {
    color: #110910;
    background-color: #5bc02b;
  }
}
  </style>
</head>
<body>

<div class="container">
<nav class="navbar navbar-default">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="mainApp.php">Pinstories.com</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active"><a href="myprofile.php">My Profile</a></li>
    <!-- add list here-->
    </ul>
  </div>
</nav>
  <button type="button" class="btn btn-success" data-toggle="collapse" data-target="#demo">Reset Password</button>
  <div id="demo" class="collapse">
  <form class="form-horizontal" role="form"  data-toggle="validator" action="myprofile.php" id="forgetPasswordform" method="post">
    <div class="form-group has-feedback">
      <label class="control-label col-sm-2" for="pwd0">current:</label>
      <div class="col-sm-10">
        <input type="password" class="form-control" id="pwd0" name="pwd0" placeholder="current password" required>
      </div>
    </div>
    <div class="form-group has-feedback">
      <label class="control-label col-sm-2" for="pwd1">new:</label>
      <div class="col-sm-10">          
        <input type="password" pattern="(?=.*[\d])(?=.*[a-z])(?=.*[A-Z]).{6,}" class="form-control" id="pwd1" data-minlength="6" name="pwd1" placeholder="new password" required>
         <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                      <div class="help-block">At least six characters that are numbers and letters including upper case and lower case</div>
      </div>
    </div>
    <div class="form-group has-feedback">
      <label class="control-label col-sm-2" for="pwd2">re-type:</label>
      <div class="col-sm-10">  
          <input type="password" pattern="(?=.*[\d])(?=.*[a-z])(?=.*[A-Z]).{6,}" class="form-control" id="pwd2" name="pwd2" data-match="#pwd1" data-match-error="Whoops, passwords do not match." placeholder="retype password" required>
        </div>
      </div>
    <div class="form-group">        
      <div class="col-sm-offset-2 col-sm-10">
        <button type="submit" class="btn btn-warning" id="submit" name="submit">Submit</button>
      </div>
    </div>
  <div class="passwordFormAlert" id="checkpassdiv">
    
  </div>
  </form>
</div>
</div>
<script>
function checkPasswordMatch() {
    var password = $("#pwd1").val();
    var confirmPassword = $("#pwd2").val();
    if(password == "" || confirmPassword=="" || confirmPassword.length < 6 || password.length <6 )
        $('#submit').prop('disabled', true);
    if (password != confirmPassword){
      $('#submit').prop('disabled', true);
        $("#checkpassdiv").html("Passwords do not match!");
    }
    else{
      $('#submit').prop('disabled', false);
        $("#checkpassdiv").html("");
    }
}

$(document).ready(function () {
   $("#pwd2").keyup(checkPasswordMatch);
});
</script>
</body>
</html>


