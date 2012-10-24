$ ->
  that = @
  $("#add-form").ajaxForm url:"/", type:"POST", success:acceptResponse
  $("#login-form").ajaxForm url:"/login", type:"POST", success:acceptLogin

acceptResponse = (data)->
  $("#items").append(data)
  $("#add-form").clearForm()
  $("#title").focus()
  refreshBalance()

refreshBalance = ->
  $.get '/balance', (data) ->
    $("#balance").html data

acceptLogin = (data)->
  if data == "true"
    window.location = "/"
