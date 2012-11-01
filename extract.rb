require 'rubygems'
require 'hpricot' 
require 'fileutils'

index = "module.exports = "

def getpath(e, page, i)

	page = page.split("_").last if page.index("_")

	path = e.css_path.gsub("##{page} > ","")
	path = path.gsub(" > ","_")
	path = path.gsub(":","").gsub("nth","_")
	path = path.gsub("(","").gsub(")","")

	return "#{path}#{('a'..'zz').to_a[i]}"
end

#Get list of .eco files in views directory and subdirectories
Dir.glob('app/views/**/*.eco') do |filename|

	page = filename.gsub("/","_").gsub("app_views_","").split(".")[0]
	FileUtils.cp filename, "#{filename}.old"
	doc = open(filename) { |f| Hpricot(f) }
	index << "\n  #{page}:" if (doc/"a,span,li,p,h3,h2,h1").count > 0
	j = 1

	(doc/"a,span,li,p,h3,h2,h1").each do |e|
		i = 1
		unless e.empty?
			e.children.each do |child|	
				if child.is_a?(Hpricot::Text)
					text=child.to_s #.strip.gsub(/\"/,'\\"')
					unless (text.empty? || text.include?("<%"))
						id = getpath(e, page, i)
						child.content = "\<%- t('#{page}.#{id}') %\>"
						e.set_attribute "data-i18n", "#{page}.#{id}"
						index << "\n    #{id}: \"\"\"#{text}\"\"\""
						i = i+1
					end
				end
			end
		end
		j = j+1
	end

	clean_doc = doc.to_html.gsub("&gt;","\>").gsub("&lt;","\<")
	File.open(filename, 'w+') {|f| f.write(clean_doc) }
	puts filename
end

File.open("app/locales/en.coffee", 'w+') {|f| f.write(index) }