echo "Generating GitHub README"
pandoc "modular_architecture_on_ios.md" -o "README.md" --from markdown --listings --highlight-style tango
echo "Generating PDF"
pandoc "modular_architecture_on_ios.md" -o "modular_architecture_on_ios.pdf" --from markdown --template "./eisvogel.tex" --listings --pdf-engine=xelatex --highlight-style tango
echo "Generating epub"
pandoc "modular_architecture_on_ios.md" -o "modular_architecture_on_ios.epub" --from markdown --listings --highlight-style tango --epub-cover-image "./assets/cover.png"