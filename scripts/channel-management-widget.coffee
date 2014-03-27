#
# The channel management widget is a sandbox for building a SPUI widget.
#

# ------------------------------------------------------------
# Channels
# ------------------------------------------------------------
class Channels extends Backbone.Collection

  # Channel model
  #   name      - channel name
  #   state     - connected, pending, disconnected
  #   posts     - number of posts for this channel
  #   campaigns - number of active campaigns for this channel
  model: Backbone.Model

  connect: (model) ->
    model.set state: 'connected'

  pending: (model) ->
    @each (m) ->
      if m isnt model and m.get('state') is 'pending'
        m.set state: 'connected'
    model.set state: 'pending'

  disconnect: (model) ->
    if model.get('state') is 'connected'
      @pending model
    else
      model.set state: 'disconnected'

# ------------------------------------------------------------
# ChannelView: the ItemView for the collection view
# ------------------------------------------------------------
class ChannelView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: '#item-template'
  className: -> @model.get 'state'

  triggers:
    'click [data-js=item-disconnect]' : 'item-disconnect'
    'click [data-js=item-undo]'       : 'item-undo'
    'click [data-js=item-cancel]'     : 'item-cancel'

# ------------------------------------------------------------
# ChannelManagementView
# ------------------------------------------------------------
class ChannelManagementView extends Backbone.Marionette.CompositeView
  itemView: ChannelView
  itemViewContainer: '[data-js=item-view-container]'
  template: '#channel-management-template'
  collectionEvents:
    change: 'render'

  onAfterItemAdded: (view) ->
    view.listenTo view, 'item-disconnect', (args) =>
      @collection.disconnect args.model
    view.listenTo view, 'item-undo item-cancel', (args) =>
      @collection.connect args.model

# ------------------------------------------------------------
# Application
# ------------------------------------------------------------
$ ->
  collection = new Channels channel_data
  view = new ChannelManagementView collection: collection
  view.render()
  $('#widget-container').html view.el

# ------------------------------------------------------------
# Test Data
# ------------------------------------------------------------
channel_data = [
  { name: 'Heavenly Croissants', posts: 24, campaigns: 2, state: 'connected' }
  { name: 'Pagoda Pete',         posts:  4, campaigns: 1, state: 'connected' }
  { name: 'Kaygo',               posts:  7, campaigns: 1, state: 'connected' }
]

