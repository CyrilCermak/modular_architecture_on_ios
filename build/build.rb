### README
# execute from the root folder; ruby ./build/build.rb

### README.md
readme_file = "README.md"
modular_architecture_on_ios = "modular_architecture_on_ios"

puts "Generating GitHub README"
puts `pandoc #{modular_architecture_on_ios}.md -o #{readme_file} --from markdown --to markdown --highlight-style tango`
generated_md = File.read(readme_file)
generated_md.gsub! "```\{=tex\}\n\\newpage\n```", "" 
generated_md.gsub! "```\{=tex\}\n\\newpage\n\\tableofcontents\n\\newpage\n```", ""
File.open(readme_file, "w") { |f| f.puts "\n![Overview](assets/cover.png)\n#{generated_md}" }

### PDF
puts "Generating PDF"
puts `pandoc #{modular_architecture_on_ios}.md -o #{modular_architecture_on_ios}.pdf --from markdown --template "./build/eisvogel.tex" --listings --pdf-engine=xelatex --highlight-style tango`
 
 ### EPUB
puts "Generating epub"
puts `pandoc #{modular_architecture_on_ios}.md -o #{modular_architecture_on_ios}.epub --from markdown --listings --highlight-style tango --epub-cover-image "./assets/cover.png"`