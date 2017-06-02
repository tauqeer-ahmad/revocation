module Administrator::TermsHelper
  def term_class(term)
    return 'navy-bg' if term.completed?
    return 'lazur-bg' if term.active?
    return 'yellow-bg' if term.initialized?
  end

end
