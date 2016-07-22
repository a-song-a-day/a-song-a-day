class Crumb
  attr_reader :name, :path

  def initialize(name, path)
    @name = name
    @path = path
  end
end
