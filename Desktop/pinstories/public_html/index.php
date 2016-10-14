
<?php include "includes/db_connect.php"; 
      include "includes/functions.php";
?>
<?php
   ob_start();
   session_start();
?>
<?php
//these chunk of php code here is for register

if(isset($_POST['signUp'])){

$firstname = mysqli_real_escape_string($connection,$_POST['fname']);
$lastname = mysqli_real_escape_string($connection,$_POST['lname']);
$email1 = mysqli_real_escape_string($connection,$_POST['email1']);
$email2 = mysqli_real_escape_string($connection,$_POST['email2']);
$password = mysqli_real_escape_string($connection,$_POST['new-password']);
$hashValue = md5($email1 + microtime());
$year = $_POST['birth-year'];
$month = $_POST['birth-month'];
$day = $_POST['birth-day'];
$birthday = $year."-".$month."-".$day;
$_SESSION['email1'] = $email1;
$_SESSION['ha'] = $hashValue;
$_SESSION['first'] = $firstname;
//$birthday = year.month.day;
$gender = $_POST['optradio'];
//check for if the email already exist in the database
    $sqlemail = "SELECT email FROM user WHERE email = '$email1'";
      
    $retemail = mysqli_query($connection,$sqlemail);
                if(! $retemail )
                    {
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }

                      if(mysqli_num_rows($retemail) > 0 ){
                        echo '<script language="javascript">';
                        echo 'alert("email already registered, please try another email")';
                        echo '</script>';
                        echo '<script language="javascript">';
                        echo 'window.location = "http://pinstories.com/index.php"';
                        echo '</script>';
                      }

                  else {

           $sql = "INSERT INTO user ".
          "(first_name,last_name,email,password,gender,birthday,hash) ".
          "VALUES ( '$firstname', '$lastname', '$email1', '$password','$gender','$birthday','$hashValue')";
      
   
  if (mysqli_query($connection, $sql)) {
  echo '<script language="javascript">';
   echo 'window.location = "http://pinstories.com/emailValidation.php"';
   echo '</script>';
} else {
echo '<script language="javascript">';
echo 'alert(""Error: " . $sql . "<br>" . mysqli_error($connection)")';
echo '</script>';
}
 }  
   mysqli_close($connection);

}

?>

<?php
//this chunk of php code here is for login
           
            
            if (isset($_POST['login']) && !empty($_POST['login-account']) 
               && !empty($_POST['login-password'])) {
              $email = mysqli_real_escape_string($connection,$_POST['login-account']);
              $password = mysqli_real_escape_string($connection,$_POST['login-password']);
                $sql = "SELECT email, password ,active FROM user WHERE email = '".$email."' AND  password = '".$password."' AND active = 1 ";
                  $retval = mysqli_query($connection,$sql);
                if(! $retval )
                    {
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                    
                      }
                     

                if(mysqli_num_rows($retval) > 0 )
                  { 
                  $_SESSION['valid'] = true;
                  $_SESSION['timeout'] = time();
                  $_SESSION['email'] = $email;
                 
                     echo '<script language="javascript">';
                    echo 'window.location = "http://pinstories.com/mainApp.php"';
                    echo '</script>';
               }
               else{

                echo '<script language="javascript">';
                    echo 'alert("Invalid email address or password")';
                    echo '</script>';
                     echo '<script language="javascript">';
                    echo 'window.location = "http://pinstories.com/index.php"';
                    echo '</script>';
               }
                
                 mysqli_close($connection);

               }
            
         ?>

<!doctype html>
<html class="no-js" lang="en-us">
  <head>
    <!-- Fonts -->
    <link href='https://fonts.googleapis.com/css?family=Fjalla+One' rel='stylesheet' type='text/css'>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Pinstories</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Place favicon.ico in the root directory -->
    <link rel="icon" type="image/png" sizes="32x32" href="images/4.ico/favicon-32x32.png"`>
    
    <script src="js/vendor/modernizr-2.8.3.min.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
    <link rel="stylesheet" href="css/bootstrap.css">
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
    <!-- my CSS -->
    <link rel="stylesheet" href="css/normalize.css">
    <link rel="stylesheet" href="css/main.css">
  </head>
  <body>
    <!--[if lt IE 8]>
    <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
    <![endif]-->
    <!-- Add your site or application content here -->

    <main>
      <nav class="navbar navbar-inverse navbar-custom">
        <div class="container navbar-top-container">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand navbar-brand-custom changeFont" href="http://pinstories.com">PinStories</a>
          </div>
          <!-- End of navbar header -->
          <div id="navbar" class="collapse navbar-collapse">
            <!-- Login -->
            <div class="container">
              <form class="navbar-form navbar-right" data-toggle="validator" action="index.php" method="post">
                <div class="form-group">
                  <input type="email" placeholder="Email" class="form-control" name="login-account" id="login-account" required>
                </div>
                <div class="form-group">
                  <input type="password" placeholder="Password" class="form-control" name="login-password" id="login-password" required>
                </div>
                <button type="submit" class="btn btn-success" id="login" name="login">Log in</button>
              </form>
            </div>
            <!-- End of login -->
          </div>
          <!--/.nav-collapse -->
        </div>
        <!-- End of Container -->
      </nav>
      <!-- End of Nav -->
<!--      Forget password-->
      <div class="container">
         <div class="col-md-10 col-sm-9">

         </div>
         <div class="col-md-2 col-sm-3" id="forgetpassword">
              <a href="forget.php" id="fplink">Forget password?</a>
         </div>
      </div>
      <!-- Sign Up -->
      <div class="container" style="margin: 1em;">
        <div class="row">
          <!-- Image Holder -->
          <div class="col-md-6 myimg">
            <img src="images/animate-map.png" alt="image" width="100%" height="100%">
          </div>
          <!-- Sign Up form -->
          <div class="col-md-6">
            <div class="row">
              <h1>Sign Up</h1>
              <p>Share your stories with others!</p>
            </div>
            <!-- End of row -->
            <!-- Sign Up Info -->
            <div class="row">
              <form action="index.php" data-toggle="validator" role="form" id="signupform" method="post">
                <div class="fullName form-inline">
                  <div class="form-group has-feedback">
                    <input type="text" pattern="^\w+$" maxlength="20" class="form-control" id="firstname" name="fname" placeholder="First Name" required>
                    <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
<!--                    <div class="help-block with-errors"></div>-->
                  </div>
                  <div class="form-group has-feedback">
                    <input type="text" pattern="^\w+$" maxlength="20" class="form-control" id="lastname" name="lname" placeholder="Last Name" required>
                    <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
<!--                    <div class="help-block with-errors"></div>-->
                  </div>
                </div>
                <div class="container vertical">
                  <div class="row top-buffer">
                    <div class="form-group has-feedback">
                      <input type="email" class="form-control" id="email1" name="email1" placeholder="Email" data-error="Invalid email address" required>
                      <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                      <div class="help-block with-errors"></div>
                    </div>
                  </div>
                  <!-- End of row-->
                  <div class="row top-buffer">
                    <div class="form-group has-feedback">
                      <input type="email" class="form-control" id="email2" name="email2" placeholder="Re-enter Email" data-match="#email1" data-match-error="Email doesn't match" required>
                      <div class="help-block with-errors"></div>
                    </div>
                  </div>
                  <!-- End of row -->
                  <div class="row top-buffer">
                    <div class="form-group has-feedback">
                      <input type="password" pattern="(?=.*[\d])(?=.*[a-z])(?=.*[A-Z]).{6,}" class="form-control" id="new-password" name="new-password" placeholder="New Password" required>
                      <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                      <div class="help-block">At least six characters that are numbers and letters including upper case and lower case</div>
                    </div>
                  </div>
                  <!-- End of row -->
                  <div class="row top-buffer">
                    <div class="form-group has-feedback">
                      <input type="password" pattern="(?=.*[_\d])(?=.*[a-z])(?=.*[A-Z]).{6,}" class="form-control" id="confirm-password" name="confirm-password" placeholder="Confirm Password" data-match="#new-password" data-match-error="Password doesn't match" required>
                      <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                      <div class="help-block with-errors"></div>
                    </div>
                  </div>
                  <!-- End of row -->
                  <div class="row top-buffer">
                    <div class="form-group">
                      <label for="birthday">Birthday</label>
                      <div class="picker" id="picker1"></div>
                    </div>
                  </div>
                  <!-- End of row -->
                  <div class="row top-buffer">
                    <div class="btn-group" data-toggle="buttons">
                      <label>
                      <input type="radio" id="female" name="optradio" value="0" required/> Female
                      </label>
                      <label>
                      <input type="radio" id="male" name="optradio" value="1"  required/> Male
                      </label>
                    </div>
                  </div>
                  <!-- End of row -->
                  <div class="row top-buffer">
                    <hr>
                    <button type="submit" class="btn btn-success btn-lg" id="signUp" name="signUp">Sign Up</button>
                  </div>
                  <!-- End of row -->
                </div>
                <!-- End of vertical inputs -->
              </form>
            </div>
            <!-- End of row -->
          </div>
          <!-- End of Signup form -->
        </div>
        <!-- End of row for img and signup form -->
      </div>
      <!-- End of Sign Up -->

      <!-- Footer -->
      <div class="container" id="footer">
       <di class="row top-buffer">
        <span class="text-center" id="copyright">&copy; Copyright @ 2016</span>
       </di>
      </div>
    </main>
    <!--<script src="http://code.jquery.com/jquery-2.0.0.min.js"></script>-->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
    <!--    <script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>-->
    <script src="js/main.js"></script>
    <script type="text/javascript" src="js/bday-picker.js"></script>
    <script type="text/javascript">
      $(document).ready(function(){
        $("#picker1").birthdaypicker({});
      });
    </script>
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
    <!-- <script src="//netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script> -->
    <script src="js/validator.min.js"></script>
    <!-- Google Analytics: change UA-XXXXX-X to be your site's ID. -->
    <script>
      (function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=
      function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;
      e=o.createElement(i);r=o.getElementsByTagName(i)[0];
      e.src='https://www.google-analytics.com/analytics.js';
      r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));
      ga('create','UA-XXXXX-X','auto');ga('send','pageview');
    </script>
  </body>
</html>
