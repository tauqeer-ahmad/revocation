module Administrator::TermsHelper
  def term_class(term)
    return 'navy-border' if term.completed?
    return 'lazur-border' if term.active?
    return 'yellow-border' if term.initialized?
  end

  def term_text_class(term)
    return 'label-info' if term.active?
    return 'label-primary' if term.completed?
    return 'label-warning' if term.initialized?
  end
end
