<?php
   class marker {
      var $title;
      var $content;
      var $longitude;
      var $latitude;
      var $email;
      var $createdOn;
      
      function __construct( $title1, $content2,$longitude3,$latitude4,$email5) {
   $this->title = $title1;
   $this->content = $content2;
   $this->longitude = $longitude3;
   $this->latitude4 = $latitude4;
   $this->email = $email5;

	}

      function setTitle($par){
         $this->title = $par;
      }
      
      function getTitle(){
         echo $this->title ."<br/>";
      }
      
      function setContent($par){
         $this->content = $par;
      }
      
      function getContent(){
         echo $this->content ."<br/>";
      }
      function setlongitude($par){
         $this->longitude = $par;
      }
      
      function getLongitude(){
         echo $this->longitude ."<br/>";
     }
          function setLatitude($par){
         $this->latitude = $par;
      }
      
      function getLatitude(){
         echo $this->latitude ."<br/>";
      }
      function setcreatedOn($par){
         $this->createdOn = $par;
      }
      
      function getcreatedOn(){
         echo $this->createdOn ."<br/>";
      }
   }
?>