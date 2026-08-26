class ApplicationSerializer
  private

  def money(value)
    return if value.nil?

    format("%.2f", value)
  end
end
