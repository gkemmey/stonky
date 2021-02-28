module ApplicationHelper
  def tailwind_form_with(model: nil, scope: nil, url: nil, format: nil, **options, &block)
    form_with(model: model,
              scope: scope,
              url: url,
              format: format,
              **{ builder: TailwindFormBuilder }.merge(options),
              &block)
  end
end
