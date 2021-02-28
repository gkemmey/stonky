class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  DEFAULT_CLASSES = {
    wrapper: "block",
    label: "text-gray-700",
    input: [
      "block",
      "border-gray-300",
      "focus:border-green-500",
      "focus:ring-green-200",
      "focus:ring-opacity-50",
      "focus:ring",
      "rounded-md",
      "shadow-sm",
      "w-full",
    ].join(" ")
  }
  def self.default_class(key); DEFAULT_CLASSES[key.to_sym];   end
  def default_class(key);      self.class.default_class(key); end

  # options[:class] => span, options[:wrapper_class] => label
  def label(method, text = nil, options = {}, &block)
    super(method, text, apply_classes(:wrapper, options, class_key: :wrapper_class)) do |label_builder|
      content = @template.capture {
        block.call(label_builder)
      }

      @template.content_tag(:span, label_builder.to_s,
                                   class: apply_classes(:label, options[:class])) + content
    end
  end

  def password_field(method, options = {})
    super(method, apply_classes(:input, options))
  end

  def text_field(method, options = {})
    super(method, apply_classes(:input, options))
  end

  private

    def apply_classes(type, class_or_options, class_key: nil)
      if class_or_options.is_a?(Hash)
        class_or_options.merge(class: apply_classes(type, class_or_options[class_key || :class]))

      else
        "#{default_class(type)} #{class_or_options}".squish
      end
    end
end

# <label class="block">
#   <span class="text-gray-700">When is your event?</span>
#   <input type="date" class="block w-full mt-1 border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
# </label>
#
# <label class="block">
#   <span class="text-gray-700">What type of event is it?</span>
#   <select class="block w-full mt-1 border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
#     <option>Corporate event</option>
#     <option>Wedding</option>
#     <option>Birthday</option>
#     <option>Other</option>
#   </select>
# </label>
