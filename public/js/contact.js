jQuery(function($)  
{
	var $data=$('#contact-form')

        $.ajax(
        {
            type: "POST",
            url: "/contact-us/submit",
            data: $data.serialize(),
         success: function()
         {
         	bootbox.alert('Your message has been sent.Thank you!');
         	$("#name").val(''); // reset field after successful submission
            $("#email").val(''); // reset field after successful submission
            $("#msg").val(''); // reset field after successful submission
            $("#phoneNumber").val('');
            $("#subject").val('');
         },
         error:function()
         {
         	bootbox.alert('There was an error in sending message. Please try again!');

         },  
        });


});