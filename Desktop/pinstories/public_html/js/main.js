$(document).ready(function(){
    //disable user copy and paste when entering input in email again 
    $('#email2').bind("cut copy paste",function(e) {
          e.preventDefault();
      });
    
     $('#signUp').click(function(e){
         // Stop form from submitting normally
//         event.preventDefault();
//         checkFormFilledOutOrNot();
        // getVals();
     });
});

function getVals(){
    var firstName = $("#firstname").val(),
        lastName = $("#lastname").val(),
        email1 = $("#email1").val(),
        email2 = $("#email2").val(),
        newPassword = $("#new-password").val(),
        month = $("#birth-month").val(),
        day = $("#birth-day").val(),
        year = $("#birth-year").val(),
        female = $("#female").val(),
        male = $("#male").val();
        console.log("Print year: " + year);
}
