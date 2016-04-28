<?php 
if(isset($_POST['submit'])) {
    echo "hello";
    
    $minimun = 5;
    $maximun = 30;
$username = $_POST['username'];
$password = $_POST['password'];
    
  if(strlen($username) < $minimun ) {
  
      echo "Username has to be longer than five";
  
  }  
    
    if(strlen($username) > $maximun  ) {
  
      echo "Username cannot be longer than 30 ";
  
  }  
    
}
?>