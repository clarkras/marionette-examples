



# ------------------------------------------------------------
# MultiPostChannelCollapsedView
# ------------------------------------------------------------
class MultiPostChannelCollapsedView extends Marionette.ItemView
  template: JST['mp_channel_header.html']
  events:
    'click': 'on_click'

  initialize: (options) ->
    @model = new Backbone.Model()

  onBeforeRender: ->
    update_model(@model, @collection)

  on_click: ->
    @close()
    view = new MultiPostChannelSelectorView collection: @collection
    view.render()
    $('#header-container').html view.el

# ------------------------------------------------------------
# ChannelItemView
# ------------------------------------------------------------
class ChannelItemView extends Marionette.ItemView
  tagName: 'li'
  className: 'selector-channel-item'
  template: JST['mp_channel_item.html']
  triggers:
    'click': 'item-select'

# ------------------------------------------------------------
# MultiPostChannelSelectorView
# ------------------------------------------------------------
class MultiPostChannelSelectorView extends Marionette.CompositeView
  template: JST['mp_channel_header.html']
  itemView: ChannelItemView
  itemViewContainer: '[data-js=item-view-container]'
  collectionEvents:
    change: 'render'
  events:
    'click': 'on_click'

  initialize: (options) ->
    @model = new Backbone.Model()

  onBeforeRender: ->
    update_model(@model, @collection)

  onRender: ->
    $('[data-js=item-view-container]', @el).removeClass 'u-hide'

  onAfterItemAdded: (view) ->
    view.listenTo view, 'item-select', (args) =>
      @toggle_channel(args.model)

  on_click: ->
    @close()
    view = new MultiPostChannelCollapsedView collection: @collection
    view.render()
    $('#header-container').html view.el

  toggle_channel: (channel) ->
    channel.set 'checked', (if channel.get('checked') then '' else 'checked')

# ------------------------------------------------------------
# Shared functions
# ------------------------------------------------------------

# Internal: Updates the the header model that is shared
# by the collapsed view and the selector view.
#
# model    - header model
# channels - collection of channel models
update_model = (model, channels) ->
  selected_channels = channels.filter (channel) ->
    channel.get('checked') is 'checked'
  channel_1 = selected_channels[0]?.toJSON() or {}
  channel_2 = selected_channels[1]?.toJSON() or {}
  model.set
    name: _.compact [channel_1.name, channel_2.name]
    network: _.compact [channel_1.network, channel_2.network]
    qty_more: if selected_channels.length > 2 then "+ #{selected_channels.length - 2} more" else ''

# ------------------------------------------------------------
# Application
# ------------------------------------------------------------
MultiPostChannelSelectorApp = ->
  collection = new Backbone.Collection channel_data
#  header_view = new MultiPostChannelSelectorView collection: collection
  header_view = new MultiPostChannelCollapsedView collection: collection
  header_view.render()
  $('#header-container').html header_view.el

# ------------------------------------------------------------
# Test Data
# ------------------------------------------------------------
channel_data = [
  { name: 'Heavenly Croissants',  network: 'facebook', checked: 'checked' }
  { name: '@Heavenly Croissants', network: 'twitter', checked: 'checked'}
  { name: '@Pagoda Pete',         network: 'twitter', checked: '' }
  { name: '@Kaygo',               network: 'twitter', checked: ''}
]

