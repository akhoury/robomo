addUploadListener = () ->
  $("input[type='file']").change ->
    container = $("#files")
    num = this.id.match(/\d+/)[0]
    num = parseInt(num) + 1
    newId = this.id.replace(/\d+/, num)
    newName = this.name.replace(/\d+/, num)
    if ($("#" + newId).length == 0)
      elem = $("<input />").attr('id', newId).attr('name', newName).attr('type', 'file')
      container.append(elem)
      addUploadListener()


class CCWidget
  constructor: ->
    @defaultUrl = '/cc_users'
    @initRemoveLinks()
    @initAddMeButton()

    if userHash?
      @ccAutoComplete = $("#cc-users" ).autocomplete({
        source: [],
        select: (event, ui) =>
          params = {cc_user: {user_id: userHash[ui.item.label], ticket_id: $(event.target).data('ticket-id')}}
          @ccUserAjax(@defaultUrl, params, ->($(event.target).val('')))
      })
      @updateOptions()

  initRemoveLinks: =>
    $('.remove-cc').click((e)=>
      if confirm("Are you sure you want to remove this notification?")
        @ccUserAjax('/cc_users/' + $(e.target).data('cc_user-id'), {'_method': 'delete'})
      e.preventDefault()
    )

  initAddMeButton: =>
    $('#cc-me').click((e)=>
      @ccUserAjax(@defaultUrl, {cc_user: {user_id: $(e.target).data('user-id'), ticket_id: $(e.target).data('ticket-id')}})
    )

  updateOptions: =>
    options = $.map(userHash, ((value, key) -> key unless $("li#cc-user-#{value}").length))
    @ccAutoComplete.autocomplete('option', 'source',  options)

  ccUserAjax: (url, params, fun) =>
    $.post(url, params, (data) =>
      $('#cced-users').html(data)
      @initAddMeButton()
      @initRemoveLinks()
      @updateOptions()

      fun() if fun?
    )

initTicketLinkingForms = () ->
  $('.ticket-link-toggle').click (event) ->
    event.preventDefault()
    $(".action-forms form[action*=#{$(event.target).attr('data-form')}]").toggle()

  $('.ticket-linker').bind('railsAutocomplete.select', (event, data) ->
    $(event.target).next("input[type=hidden]").val(data.item.value)
    $(event.target).val(data.item.label)
  )

initInlineTagEditing = ->
  $('button.edit-tags').click (e) ->
    $(e.target).parents('dl').children('dt, dd').toggle()
    $('#inline-tag-edit').toggle()

initNewCCUsers = ->
  return unless $('#cc_new_users').length
  input = $('#cc_new_users input.autocomplete').autocomplete
    source: $.map(userHash, ((value, key) -> key unless $("li#cc-user-#{value}").length))
    select: (event, ui) =>
      user_id = userHash[ui.item.label]
      return if $("li#cc-user-#{user_id}").length
      $('ul#cced-users').prepend("<li id=\"cc-user-#{user_id}\">#{ui.item.label}</li>")
      $(event.target).after("<input type=\"hidden\" id=\"ticket_cc_users_attributes__user_id\" name=\"ticket[cc_users_attributes][][user_id]\" value=\"#{user_id}\"/>")
      $(event.target).val('')
      return false
$ ->
  $('td.readiness').tooltip {
    track: true
    bodyHandler: -> return $(this).attr("alt") 
  }
  addUploadListener()
  initTicketLinkingForms()
  initInlineTagEditing()
  initNewCCUsers()
  new CCWidget()
