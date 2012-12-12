# uses ajax when there's pagination, otherwise uses javascript tablesorter to
# sort the table inline
class SmartTableSorter
  constructor: ->
    if $('nav.pagination').length
      @params = @paramsFromUrl(window.location.search)
      @hookUpAjaxSort()
    else
      $(".tickets table").tablesorter()
      @drawArrows('last_update', 'asc')

  hookUpAjaxSort: () ->
    @drawArrows(@params['sorted']['col'], @params['sorted']['dir'])

    $('.tickets table thead tr th').click((e)=>
      newSortCol = $(e.target).data('sort') || $(e.target).parent('th').data('sort')

      # flip direction if we're re-sorting the same column
      if @params['sorted']['dir'] == 'desc' && @params['sorted']['col'] == newSortCol
        @params['sorted']['dir'] = 'asc'
      else
        @params['sorted'] = {dir: 'desc', col: newSortCol}

      @loadPage(window.location.pathname + '?' + $.param(@params))
    )

    $('nav.pagination a').click((e)=>
      @paramsFromUrl(e.target.href)
      @loadPage(e.target.href)
      e.preventDefault()
    )

  loadPage: (url) ->
    $.get(url, (data) =>
      $('#real-content').html(data)
      @hookUpAjaxSort()
    )

  drawArrows: (col, dir) ->
    directionClass = if dir == 'asc' then 'headerSortUp' else 'headerSortDown'
    $(".tickets table tr th[data-sort=#{col}]").addClass(directionClass)

  # this only handles 1 level of nested params...
  # look to jQuery BBQ deparam or something similar if you need more
  paramsFromUrl: (url) ->
    query = url.replace(/^.*?\?/, '')

    # defaults
    params = {sorted: {col: 'last_update', dir: 'desc'}}

    regex = /(.+?)=(.+?)(?:&|$)/g
    while (match = regex.exec(query))
      if nested = decodeURIComponent(match[1]).match(/(.*?)\[(.*?)\]/)
        params[nested[1]] ||= {}
        params[nested[1]][nested[2]] = decodeURIComponent(match[2])
      else
        params[match[1]] = decodeURIComponent(match[2])

    params

$ ->
  new SmartTableSorter()
