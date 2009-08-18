helpers do


def link_to url,text
  "<a href='#{url}'>#{text}</a>"
end

def page_link page
  "<a href=\"#{page.path}\">#{page.title}</a>"
end

def test
  "Kabooey - the % trick works!"
end

def page_level
  "This page is level " + @page.level.to_s
end

def markdown(text)
  text.gsub!(/(%\s*)(\w+)/) do |function|
    case $2
    when "test"
      test
    when "page_level"
      page_level
    else
      text
    end  
  end 
  RDiscount.new(text).to_html
end

def render_partial(template,locals=nil)
  layout={:layout => false} # layout is always false for partials
  if template.is_a?(String) || template.is_a?(Symbol) # check if the template argument is a string or symbol
    template=('_' + template.to_s).to_sym # make sure the template is a symbol
  else # otherwise is must be an object
    locals=template # set the object as the local variable
    template=template.is_a?(Array) ? ('_' + template.first.class.to_s.downcase).to_sym : ('_' + template.class.to_s.downcase).to_sym #extract the template name from the object name
  end
  if locals.is_a?(Hash) # this means that the locals have been set manually, so just render the template using those variables
    erb(template,layout,locals)      
  elsif locals # otherwise, the locals will be the same name as the partial
    locals=[locals] unless locals.respond_to?(:inject) # a simple object won't repsond to the inject method, but if it is put into an array on its own it will
    locals.inject([]) do |output,element| # cycle through setting each local variable
      output << erb(template,layout,{template.to_s.delete("_").to_sym => element})
    end.join("\n") # join up each partial with a new line to make the output html look nicer
  else # if there are no locals then just render the partial with that name
    erb(template,layout)
  end
end
  
  
end
