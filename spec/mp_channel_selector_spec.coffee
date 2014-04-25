describe 'MultiPostChannelHeaderView', ->
  beforeEach ->
    @subject = new MultiPostChannelHeaderView()

  it 'should render the view', ->
    @subject.render()
    expect(@subject.$el).not.toBeEmpty()

