function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
    return pattern.test(emailAddress);
};

function resetContactUsForm ()
{
    $("#name").val(''); // reset field after successful submission
    $("#email").val(''); // reset field after successful submission
    $("#msg").val(''); // reset field after successful submission
    $("#phoneNumber").val('');
    $("#subject").val(0);
}

$(function($) {
    $('body').on('submit','#contact_form',function() {
        var $form = $('#contact_form');
        var email = $("#email").val();

        console.log({
            '$form':$form,
            '$form.serialize()':$form.serialize(),
        });

        // if (isValidEmailAddress(email)) {
            $.ajax({
                method: "POST",
                url: "/contact-us/submit",
                data: $form.serialize(),
                success: function() {
                    $(' #messagebag ').remove();
                    // fg.removeClass('has-error');
                    $('.form-group').removeClass('has-error');

                    bootbox.alert('Your message has been sent.Thank you!');
                    resetContactUsForm();
                },
                error: function(xhr, textStatus, errorThrown) {
                    $(' #messagebag ').remove();
                    
                     console.error({
                    textStatus: textStatus,
                    'xhr.response': xhr.responseJSON || xhr.responseText,
                    errorThrown:errorThrown,
                });
                var json= xhr.responseJSON || xhr.responseText ||{};
                     var alerts =new MessageBag();
                       if(xhr.responseJSON.errors)
                    {

                    jQuery.each(xhr.responseJSON.errors, function(key, value) {
                     alerts.add(value.field,value.message);

                    });
                     alerts.sprinkle('form:first');
                    bootbox.alert('There was an error in sending message. Please try again!');

                 }
                },
            });
        // } else {
            // bootbox.alert('Invalid Email Address');

        // }
        return false; // prevent page refresh
    });
});
