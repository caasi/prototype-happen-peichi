(function(){
  $.getJSON("data.json", function(data){
    var counter, update;
    counter = 0;
    $('#countdown .clock').countdown(data.date, function(it){
      return $(this).html(it.strftime("%D days %H:%M:%S"));
    });
    return (update = function(){
      var d;
      d = data.messages[counter];
      $('#container').css('background-image', "url('" + d.image + "')");
      $('#message').html(d.message);
      counter = (counter + 1) % data.messages.length;
      return setTimeout(update, data.interval * 1000);
    })();
  });
}).call(this);
