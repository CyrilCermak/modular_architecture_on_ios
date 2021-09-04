### README.md
puts "Generating GitHub README"
puts `pandoc "modular_architecture_on_ios.md" -o "README.md" --from markdown --to markdown --highlight-style tango`
generated_md = File.read("README.md")
generated_md.gsub! "```\{=tex\}\n\\newpage\n```", "" 
generated_md.gsub! "```\{=tex\}\n\\newpage\n\\tableofcontents\n\\newpage\n```", ""
File.open("README.md", "w") { |f| f.puts "\n![Overview](assets/cover.png)\n#{generated_md}" }

### PDF
puts "Generating PDF"
puts `pandoc "modular_architecture_on_ios.md" -o "modular_architecture_on_ios.pdf" --from markdown --template "./eisvogel.tex" --listings --pdf-engine=xelatex --highlight-style tango`
 
 ### EPUB
puts "Generating epub"
puts `pandoc "modular_architecture_on_ios.md" -o "modular_architecture_on_ios.epub" --from markdown --listings --highlight-style tango --epub-cover-image "./assets/cover.png"`