<?php
   session_start();
 
   unset($_SESSION['valid']);
    unset($_SESSION['timeout']);
    unset($_SESSION['email']);
   header('Refresh: 1; URL = index.php');
?>