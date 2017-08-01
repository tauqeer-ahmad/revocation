module Administrator::TermsHelper
  def term_class(term)
    return 'navy-bg' if term.completed?
    return 'lazur-bg' if term.active?
    return 'yellow-bg' if term.initialized?
  end

  def term_text_class(term)
    return 'text-navy' if term.completed?
    return 'text-lazur' if term.active?
    return 'text-yellow' if term.initialized?
  end

end
