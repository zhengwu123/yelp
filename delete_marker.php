<?php
  ob_start();
  session_start();
   if (!$_SESSION['valid'])
  header("Location: index.php");
?>
<?php include "includes/db_connect.php";?>
<?php 
//echo 'Thank you '. $_POST['latitude']. $_POST['longitude'].$_POST['title'].$_POST['content'];
//echo $_SESSION['email'];
$title1 = mysqli_real_escape_string($connection,$_POST['title']);
$content1 = mysqli_real_escape_string($connection,$_POST['content']);
$latitude1 = $_POST['latitude'];
$longitude1 = $_POST['longitude'];
$emailadd = $_SESSION['email'];
$sql = "DELETE FROM makers WHERE title = '$title1' AND content = '$content1'  AND longitude = '$longitude1' AND latitude = '$latitude1' AND email = '$emailadd'";
        // $sql = "INSERT INTO makers ".
         // "(title,content,longitude,latitude,email) ".
          //"VALUES ( '$title1', '$content1', '$longitude1', '$latitude1','$emailadd')";   
   $retvalue = mysqli_query($connection,$sql);
  if(! $retvalue )
                    {
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }
                        else{
            echo "delete success!";

                        }
                      ?>