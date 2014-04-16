data <- $.getJSON "data.json"
counter = 0
$('#countdown .clock').countdown data.date, ->
  $(this).html it.strftime "%D days %H:%M:%S"
do update = ->
  d = data.messages[counter]
  $('#container').css \background-image "url('#{d.image}')"
  $('#message').html d.message
  counter := (counter+1) % data.messages.length
  setTimeout update, data.interval * 1000
