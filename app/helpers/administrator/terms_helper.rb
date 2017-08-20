module Administrator::TermsHelper
  def term_class(term)
    return 'navy-border' if term.completed?
    return 'lazur-border' if term.active?
    return 'yellow-border' if term.initialized?
  end

  def term_text_class(term)
    return 'text-navy' if term.completed?
    return 'text-lazur' if term.active?
    return 'text-yellow' if term.initialized?
  end

end
