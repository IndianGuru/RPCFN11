class Module
  alias :_attr_reader :attr_reader
  def attr_reader(*attributes)
    attributes.each { |attribute|
      if attribute.id2name.end_with? '?'
        class_eval "def #{attribute}; @#{attribute.id2name[0...-1]}; end"
      else
        _attr_reader(attribute)
      end
    }
  end
end
