<?php
  ob_start();
   session_start();
   if (!$_SESSION['valid'])
  header("Location: index.php");
  require("includes/db_connect.php");
?>
<?php


// Start XML file, create parent node
$emailadd = $_SESSION['email'];
$dom = new DOMDocument("1.0");
$node = $dom->createElement("markers");
$parnode = $dom->appendChild($node);


//--XML below to send markers data back to mainAPP.js
$doc = new DOMDocument("1.0");
$node = $doc->createElement("markers");
$parnode = $doc->appendChild($node);
$sql = "SELECT * FROM makers WHERE email = '$emailadd'";
$result = mysqli_query($connection,$sql);

    if (mysqli_num_rows($result) > 0) {
        header("Content-type: text/xml");
        while($row = @mysqli_fetch_assoc($result)) {
          $node = $doc->createElement("marker");
          $newnode = $parnode->appendChild($node);
          $newnode->setAttribute("title", $row['title']);
          $newnode->setAttribute("content", $row['content']);
          $newnode->setAttribute("lat", $row['latitude']);
          $newnode->setAttribute("lng", $row['longitude']);
          $newnode->setAttribute("email", $row['email']);
          $newnode->setAttribute("time", $row['CreatedOn']);
          $newnode->setAttribute("owner", $row['owner']);
        }
         echo $doc->saveXML();
    } 
    else 
    {
      echo "0 results";
    }
?>