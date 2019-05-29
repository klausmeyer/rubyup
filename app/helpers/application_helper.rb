module ApplicationHelper
  def job_state_badge(state)
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

  def version_state_badge(state)
    klass = {
      'created'   => 'secondary',
      'available' => 'success',
      'failed'    => 'danger'
    }.fetch(state)

    content_tag :span, class: "badge badge-#{klass}" do
      state
    end
  end
end
