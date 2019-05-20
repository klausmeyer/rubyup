module ApplicationHelper
  def state_badge(state)
    klass = {
      'created'     => 'secondary',
      'rescheduled' => 'secondary',
      'completed'   => 'success',
      'failed'      => 'danger'
    }.fetch(state)

    content_tag :span, class: "badge badge-#{klass}" do
      state
    end
  end
end
