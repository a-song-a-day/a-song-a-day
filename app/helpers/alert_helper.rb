module AlertHelper
  def alert_class(kind)
    {
      'alert' => 'alert-danger',
      'notice' => 'alert-info',
      'success' => 'alert-success'
    }[kind] || 'alert-warning'
  end
end
