#------------------------------------------------------------
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
#
# Select channels for a multi-post activity. Initially the view
# shows the header part (represented by the model) and hides the
# item view container (the collection). The item view container
# drops down when the header is clicked.
#
# collection - channels
# model      - header items
# collapsed  - boolean, true if channels dropdown is collapsed
# ------------------------------------------------------------
class MultiPostChannelSelectorView extends Marionette.CompositeView
  template: JST['mp_channel_header.html']
  itemView: ChannelItemView
  itemViewContainer: '[data-js=item-view-container]'
  collectionEvents:
    change: 'render'
  events:
    'click [data-js=mp-channel-selector-header]': 'on_header_click'

  initialize: ->
    @model = new Backbone.Model()
    @collapsed = true

  onBeforeRender: ->
    @update_model(@model, @collection)

  onRender: ->
    $('[data-js=item-view-container]', @el).toggleClass 'u-hide', @collapsed

  onAfterItemAdded: (view) ->
    view.listenTo view, 'item-select', (args) =>
      @toggle_channel(args.model)

  on_header_click: ->
    $('[data-js=item-view-container]', @el).toggleClass 'u-hide'
    @collapsed = $('[data-js=item-view-container]', @el).hasClass 'u-hide'

  # Internal: toggles the 'checked' attribute of a channel model.
  #
  # channel - channel model
  #
  # Returns: channel model
  toggle_channel: (channel) ->
    channel.set 'checked', (if channel.get('checked') then '' else 'checked')

  # Internal: Updates the the model that is used
  # by the header, containing up to two channel
  # names and the "+ n more" message.
  #
  # model    - header model
  # channels - collection of channel models
  update_model: (model, channels) ->
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
  header_view = new MultiPostChannelSelectorView collection: collection
  header_view.render()
  $('#selector-container').html header_view.el
  # For debugging:
  window.app =
    collection: collection
    model: header_view.model
    view: header_view

# ------------------------------------------------------------
# Test Data
# ------------------------------------------------------------
channel_data = [
  { name: 'Heavenly Croissants',  network: 'facebook', checked: 'checked' }
  { name: '@Heavenly Croissants', network: 'twitter', checked: 'checked'}
  { name: '@Pagoda Pete',         network: 'twitter', checked: '' }
  { name: '@Kaygo',               network: 'twitter', checked: ''}
]

