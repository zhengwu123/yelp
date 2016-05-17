<?php
    ob_start();
   session_start();
   if (!$_SESSION['valid'])
header("Location: index.php");
?>
<?php
include "includes/db_connect.php";
$currentemail = $_SESSION['email'];
$sql = "SELECT first_name,last_name FROM user WHERE email = '$currentemail' AND active = 1";
$retval = mysqli_query($connection,$sql);
            if(!$retval){
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }
        if(mysqli_num_rows($retval) > 0 ){
         $row=mysqli_fetch_assoc($retval);
        $_SESSION['firstname'] = $row["first_name"];
        $_SESSION['lasttname'] = $row["last_name"];          
        }
?>
<!doctype html>
<html class="no-js" lang="">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>mainApp</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Place favicon.ico in the root directory -->
        <link rel="icon" type="image/png" sizes="32x32" href="images/4.ico/favicon-32x32.png">

        <script src="js/vendor/modernizr-2.8.3.min.js"></script>
        <link rel="stylesheet" href="css/normalize.css">
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
        <link rel="stylesheet" href="css/bootstrap.css">
        <!-- Optional theme -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
        <!-- Bootstrap Core CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="css/simple-sidebar.css" rel="stylesheet">
        <link rel="stylesheet" href="css/mainApp.css">
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
         <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
         <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
         
    </head>
    <body>
       <div id="wrapper">

            <!-- Sidebar -->
            <div id="sidebar-wrapper">
                <ul class="sidebar-nav">
                    <li class="sidebar-brand" id="profile-placeholder">
                        <div class="containerfluid profile">
                          <div class="row">
                            <div class="col-md-5">
                              <img src="http://icons.iconarchive.com/icons/designbolts/free-multimedia/1024/iMac-icon.png" alt="" id="profile-icon">
                            </div>
                            <div class="col-md-7" id ="profile-username-container">
                              <!--what if the name is so long? -->
                              <span id="profile-username"><?php echo $_SESSION['firstname']; ?></span>
                            </div>
                          </div><!-- End of row -->
                        </div>
                    </li>
                    <li>
                       <!--a href="#">My Profile</a-->
                       
                   
                    <li><a href="myprofile.php" id="myProfile">My Profile</a></li>

                    </li>
                  
                       
                    </li>
                    <li>
                        <a href="#" id="myPins">My Pins</a>
                    </li>
                     <li>
                        <a href="#">My Friends</a>
                    </li>
                    <li>                    
                        <a href="#" id="searchNearLocation">Pins In 50 miles</a>
                    </li>
                    <li>
                        <a href="logout.php">Log out</a>
                    </li>
<!--
                    <li>
                        <button type="button" id="searchNearLocation">Search</button>
                    </li>
-->
                </ul>
  
            </div>
            <!-- /#sidebar-wrapper -->

            <!-- Page Content -->
            <div id="page-content-wrapper">
                <div class="container-fluid">
                    <div class="row map-place">
                        <div class="col-lg-12 map-place">
                            <h3>
	                            <a href="#menu-toggle" class="gradient-menu" id="menu-toggle"></a>
	                            <input type="text" id="autocomplete" placeholder="">
                            </h3>
                            <script src="https://maps.googleapis.com/maps/api/js?sensor=true&v=3.exp&libraries=geometry,places"></script>
                            <div id="map"></div>
                               
<!--                            <script src="js/geolocation-marker.js"></script>-->
                        </div>
                    </div>
                </div>
            </div>
            <!-- /#page-content-wrapper -->
    </div>
    <!-- /#wrapper -->
    
        <script src="https://code.jquery.com/jquery-1.12.0.min.js"></script>
        <script>window.jQuery || document.write('<script src="js/vendor/jquery-1.12.0.min.js"><\/script>')</script>
<!--
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCkZX_d-WdT_Cb1V5irqhxgD-YSqR84NU4&callback=initMap&sensor=false&signed_in=true&libraries=geometry,places"
        async defer></script>
-->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
        <script src="js/plugins.js"></script>
        <script src="js/mainApp.js"></script>
        
        <!-- Bootstrap Core JavaScript -->
        <script src="js/bootstrap.min.js"></script>
        
<!--
         Menu Toggle Script 
        <script>
        $("#menu-toggle").click(function(e) {
            e.preventDefault();
            $("#wrapper").toggleClass("toggled");
        });
        </script>
-->
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
