# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    displayNumbers()

    $("#mask_number_form")
      .on("ajax:success", (e, data, status, xhr) ->
        displayNumbers())
      .on "ajax:error", (e, xhr, status, error) ->
        alert xhr.responseText


displayNumbers = () ->  
  clearTable()
  $.ajax
    type: "GET"
    url:    "/numbers.json"
    datatype:"json"
    async:   true
    success: (data, textStatus, jqXHR) ->
        appendNumbersToTable data
    error: (jqXHR, textStatus, errorThrown) ->
        alert errorThrown

clearTable = () ->
  $("#numbers_table tbody").find("tr").remove()

maskNumber = (number) ->
  $.ajax
    type: "POST"
    url:    "/numbers/mask_number"
    datatype:"json"
    async:   true
    data: {number: number}
    success: (data, textStatus, jqXHR) ->
      displayNumbers()
    error: (jqXHR, textStatus, errorThrown) ->
      alert errorThrown
  return false    

appendNumbersToTable = (numbers) ->
  for number in numbers 
    do (number) ->
      numberElement = '<td>' + number.phone_number + '</td>'
      masksElement = '<td>'
      masksElement += (mask.phone_number + '<br>') for mask in number.masks
      masksElement += '</td>'
      deleteNumberLink = '<a class="link-destroy" data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="/numbers/' + number.id + '.json">Destroy</a>'
      newMaskLink = '<a class="newLink" data-remote="true" rel="nofollow" data-number="' + number.phone_number + '">New Mask</a>'
      actionsElement = '<td>' + deleteNumberLink + ' ' + newMaskLink
      rowElement = '<tr>' + numberElement + masksElement + actionsElement + '</tr>'
      $("#numbers_body").append rowElement

  $('a.newLink').click () ->
    number = $(this).data('number')
    maskNumber number

  $(".link-destroy").on("ajax:success", (e, data, status, xhr) ->
    displayNumbers()
  ).on "ajax:error", (e, xhr, status, error) ->
    displayNumbers()
    alert xhr.responseText
