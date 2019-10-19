#App.chat = App.cable.subscriptions.create "ChatChannel",
App.chat = null

current_user_id = ->
  $('input:hidden[name="from_id"]').val()

user_id = ->
  $('input:hidden[name="to_id"]').val()

room_id = ->
  $('input:hidden[name="room_id"]').val()

room_ch = ->
  id = room_id()
  if id?
    return {channel: 'ChatChannel', room_id: id}
  else
    return null

messages_height = ->
  temp = 0;
  $("div.message").each ->
    temp += ($(this).height());
  return temp + 500

document.addEventListener 'turbolinks:request-start', ->
  if room_ch()?
    App.chat.unsubscribe()

document.addEventListener 'turbolinks:load', ->
  if room_ch()?
    App.chat = App.cable.subscriptions.create room_ch(),
      received: (data) ->
        $('#messages').append data['message']
        $('section.message_box').scrollTop(messages_height());

      speak: (from_id, to_id, room_id, content) ->
        @perform 'speak', {
          "from_id": from_id
          "to_id": to_id
          "room_id": room_id
          "content": content
        }

$(document).on 'keypress', '[data-behavior~=chat_speaker]', (event) ->
  if event.which is 13
    value = event.target.value
    App.chat.speak(current_user_id(), user_id(), room_id(), value)
    event.target.value = ''
    event.preventDefault()
