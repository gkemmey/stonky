class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  DEFAULT_CLASSES = {
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
      "w-full"
    ].join(" "),

    submit: [
      "bg-green-500",
      "cursor-pointer",
      "hover:bg-green-700",
      "px-4",
      "py-2",
      "rounded",
      "text-white"
    ].join(" "),

    wrapper: "block"
  }

  def self.default_class(key); DEFAULT_CLASSES[key.to_sym];   end
  def default_class(key);      self.class.default_class(key); end

  def errors
    return unless errors_from_model_or_flash.any?

    @template.content_tag(:div, role: "alert") do
      @template.content_tag(:div, "Please fix the following:",
                                  class: "bg-red-500 text-white font-bold rounded-t px-4 py-2") +

      @template.content_tag(:div, class: "border border-t-0 border-red-400 rounded-b bg-red-100 px-4 py-3 text-red-700") do
        @template.content_tag(:ul, class: "list-disc list-inside") do
          errors_from_model_or_flash.collect { |error|
            @template.content_tag(:li, error)
          }.reduce(:+)
        end
      end
    end
  end

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

  def submit(value = nil, options = {})
    super(value, apply_classes(:submit, options))
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

    def errors_from_model_or_flash
      return [] if (object.try(:errors) || []).none? &&
                     (@template.flash[object_name].try(:[], :errors) || []).none?

      return object ? object.errors.full_messages : @template.flash[object_name][:errors]
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
