describe 'MultiPostChannelSelector', ->
  beforeEach ->
    @subject = new MultiPostChannelSelector()

  it 'should render the view', ->
    @subject.render()
    expect(@subject.$el).not.toBeEmpty()

