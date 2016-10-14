<?php
	ob_start();
   session_start();
   if (!$_SESSION['valid'])
	header("Location: index.php");
?>
<?php include "includes/db_connect.php"; ?>
<?php 
//echo 'Thank you '. $_POST['latitude']. $_POST['longitude'].$_POST['title'].$_POST['content'];
$title1 = mysqli_real_escape_string($connection,$_POST['title']);
$content1 = mysqli_real_escape_string($connection,$_POST['content']);
$latitude1 = $_POST['latitude'];
$longitude1 = $_POST['longitude'];
$emailadd = $_SESSION['email'];
$username = $_SESSION['firstname'];
$sql = "INSERT INTO makers ".
          "(title,content,longitude,latitude,email,owner) ".
          "VALUES ( '$title1', '$content1', '$longitude1', '$latitude1','$emailadd','$username')";
   
   //$sql = "INSERT INTO user ".
        //  "(first_name,last_name,email,password,gender,birthday,hash) ".
         // "VALUES ( 'qq', 'qq', 'email', 'password',1,'1988-5-15','hashValue')";   
   $retvalue = mysqli_query($connection,$sql);
  if(! $retvalue )
                    {
                    echo '<script language="javascript">';
                    echo 'alert("open data error ")';
                    echo '</script>';
                    die('Could not get data: ' . mysqli_error());
                      }

//--XML below to send markers data back to mainAPP.js

$doc = new DOMDocument("1.0");
$node = $doc->createElement("markers");
$parnode = $doc->appendChild($node);

$sql = "SELECT * FROM makers WHERE email = '$emailadd'";
$result = mysqli_query($connection,$sql);
header("Content-type: text/xml");
    if (mysqli_num_rows($result) > 0) {
        header("Content-type: text/xml");
        while($row = @mysqli_fetch_assoc($result)) {
            // echo "email: " . $row["email"]. " - latitude: " . $row["latitude"]. "longitude " . $row["longitude"]. "<br>";
        
          $node = $doc->createElement("marker");
          $newnode = $parnode->appendChild($node);
          $newnode->setAttribute("title", $row['title']);
          $newnode->setAttribute("content", $row['content']);
          $newnode->setAttribute("lat", $row['latitude']);
          $newnode->setAttribute("lng", $row['longitude']);
          $newnode->setAttribute("email", $row['email']);
        }
         echo $doc->saveXML();
        //echo "<h2>PHP is Fun!</h2>";
    } 
    else 
    {
      echo "0 results";
    }
//echo $result;
mysqli_close($connection);
?>