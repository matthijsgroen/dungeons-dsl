
module ObjectFinder
  def find_object(nesting)
    query = nesting.pop

    selection = objects
    selection = selection.select { |i| i.is_a? query[:type] } if query[:type]

    object = case query[:position]
    when :last then selection.last
    when :first then selection.first
    when nil then selection.last
    end

    return object if nesting.empty?

    object.find_object nesting
  end
end

