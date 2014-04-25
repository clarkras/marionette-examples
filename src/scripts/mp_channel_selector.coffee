update_model = (model, channels) ->
  selected_channels = channels.filter (channel) ->
    channel.get('checked') is 'checked'
  channel_1 = selected_channels[0]?.toJSON() or {}
  channel_2 = selected_channels[1]?.toJSON() or {}
  model.set
    name_1: channel_1.name
    network_1: channel_1.network
    name_2: channel_2.name
    network_2: channel_2.network
    qty_more: if selected_channels.length > 2 then "+ #{selected_channels.length - 2} more" else ''

# ------------------------------------------------------------
# MultiPostChannelCollapsedView
# ------------------------------------------------------------
class MultiPostChannelCollapsedView extends Marionette.ItemView
  template: JST['mp_channel_header.html']
  events:
    'click': 'on_click'

  templateHelpers:
    network_icon: (index) ->
      network = if index is 1 then @network_1 else @network_2
      "Icon--#{network}"

  initialize: (options) ->
    @model = new Backbone.Model()

  onRender: ->
    console.log 'element', @$el.find('[data-js=item-view-container]')
    @$el.find('[data-js=item-view-container]').hide()

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
  templateHelpers:
    network_icon: ->
      "Icon--#{@network}"
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
  templateHelpers:
    network_icon: (index) ->
      network = if index is 1 then @network_1 else @network_2
      "Icon--#{network}"
  events:
    'click': 'on_click'

  initialize: (options) ->
    @model = new Backbone.Model()

  onBeforeRender: ->
    update_model(@model, @collection)

  onAfterItemAdded: (view) ->
    view.listenTo view, 'item-select', (args) =>
      @toggle_channel(args.model)

  on_click: ->
    @close()
    view = new MultiPostChannelCollapsedView collection: @collection
    view.render()
    $('#header-container').html view.el

  toggle_channel: (channel) ->
    console.log "item-select", channel.get('name')
    channel.set 'checked', (if channel.get('checked') then '' else 'checked')

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

