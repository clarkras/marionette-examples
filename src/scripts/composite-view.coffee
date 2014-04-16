# ------------------------------------------------------------
# TreeView
# ------------------------------------------------------------
class TreeView extends Backbone.Marionette.CompositeView
  template: "#node-template"
  tagName: "li"

  initialize: ->
    @collection = @model.get('nodes')

  appendHtml: (cv, iv) ->
    @$('ul:first').append iv.el
  
  onRender: ->
    @$('ul').remove() unless @collection

# ------------------------------------------------------------
# TreeRoot
# ------------------------------------------------------------
class TreeRoot extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: TreeView
  
# ------------------------------------------------------------
# TreeNode
# ------------------------------------------------------------
class TreeNode extends Backbone.Model
  initialize: ->
    nodes = @get 'nodes'
    if nodes
      nodes = new TreeNodeCollection(nodes)
      @set 'nodes', nodes

# ------------------------------------------------------------
# TreeNodeCollection
# ------------------------------------------------------------
class TreeNodeCollection extends Backbone.Collection
  model: TreeNode

# ------------------------------------------------------------
# application code
# ------------------------------------------------------------
tree = new TreeNodeCollection(treeData)
treeView = new TreeRoot collection: tree
$ ->
  treeView.render()
  $('#tree').html treeView.el
