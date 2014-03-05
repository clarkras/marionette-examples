###
  This example shows how to use a Marionette CompositeView to display a table with a footer that
  contains the sum of cells in one column. The composite view collection is a simple list of objects. There is
  no model in the composite view. Instead, a template helper is used to calculate the sum of the
  column.

  To demonstrate event handling, clicking on a status cell toggles the boolean value.
  Changing the model in the collecition fires a change event and causes the composite view to re-render.
###

class RowView extends Backbone.Marionette.ItemView
  tagName: 'tr'
  template: '#row-template'

  events:
    'click [data-js=status-cell]': ->
      # click to toggle status
      @model.set 'status', !@model.get('status')

  templateHelpers:
    # In templateHelpers remember that `this` is the serialized object
    item_count: ->
      if @status then @count else 'N/A'
    status_class: (active, inactive) ->
      # class names are passed in from template...this makes it easier to
      # change class names without having to change coffeescript code
      if @status then active else inactive

class TableView extends Backbone.Marionette.CompositeView
  itemView: RowView
  itemViewContainer: 'tbody'
  template: '#table-template'

  collectionEvents:
    change: 'render'

  templateHelpers: ->
    total_count: @total_count

  # Sums the values in the 'Count' column where status is true.
  total_count: =>
    @collection.reduce (n, model) ->
      n = n + model.get('count') if model.get('status')
      n
    , 0

$ ->
  data = [
    { name: 'row1', count: 3, status: true }
    { name: 'row2', count: 5, status: false }
    { name: 'row3', count: 1, status: true }
  ]

  collection = new Backbone.Collection(data)
  view = new TableView collection: collection
  view.render()
  $('body').html view.el
