### README
# execute from the root folder; ruby ./build/build.rb

# TOC - Sadly, cannot really automate it as Ruby comments also start with #
readme_toc = "
# Table of Contents

- Introduction
  - What you Need
  - What is this book about
  - What is this book NOT about
- Modular Architecture
  - Design
  - Layers
    - Application Layer
    - Domain Layer
    - Service Layer
    - Core Layer
    - Shared Layer
  - Example: International Space Station
    - Overview
    - Cosmonaut
    - Laboratory
  - Conclusion
- Libraries on Apple's ecosystem
  - Dynamic vs static library?
    - PROS & CONS
  - Essentials
  - Exposing static 3rd party library
  - Examining library
    - Mach-O file format
    - Fat headers
    - Executable type
    - Dependencies
    - Symbols table
    - Strings
  - Build system
  - Conclusion
- Swift Compiler (optional)
  - Compiler Architecture
    - Parsing
    - Semantic analysis
    - Clang importer
    - SIL generation
    - LLVM IR Generation
    - Exporting dylib
  - Conclusion
- Development of the Modular Architecture
  - Creating workspace structure
    - Automating the process
    - Xcode's workspace
  - Generating projects
    - Hello XcodeGen
  - Ground Rules
    - Cross-linking dependencies
    - Vertical linking
  - Core Framework
    - Using Core Framework
    - Core Framework Usage and Best Practices
    - Core Framework linking and advantages
    - Core Framework disadvantages
    - Core Framework Rules
  - Testing
    - Unit Testing in Isolation
    - Application Framework App
    - Unit Testing in Application Framework App
    - UITesting in Isolation
    - UITesting in Application Framework App
    - Mock Framework
  - Final Look at One Fully Fledged Xcode Project (module)
  - Conclusion
- App Extensions, Watch and other targets in the Modular Architecture
  - App Extensions
  - Setting up App Extension in Modular Architecture
  - Apple Watch target
  - Conclusion
- Benchmarking of Modular Architecture
  - Test setup
  - Test results
    - App size
    - Memory usage
    - Compile time
    - Launch time
  - Conclusion
- Application Framework - Best Practices
  - App secrets
    - How to handle secrets
    - The GnuPG (GPG)
    - GEM: Mobile Secrets
    - The ugly and brilliant part of the Secrets source code
  - Workflow
    - Teams
    - Git & Contribution
    - Scalability
    - Application Framework & Distribution
  - Common Problems
    - Maintenance
    - Code style
    - Not fully autonomous teams
  - Conclusion
- Dependency Managers
  - Cocoapods
    - Integration with the application framework
    - available libraries within the whole Application Framework
    - Project paths with required libraries
    - Domain
  - Carthage
  - SwiftPM
  - Conclusion
- Design Patterns
  - Coordinator
  - Strategy
  - Configuration
  - Decoupling
  - MVVM + C
  - Protocol Oriented Programming (POP)
  - Conclusion
- Project Automation
  - Fastlane
  - Continuous Integration (CI)
  - Continuous Delivery (CD)
  - Ruby, programmer's best friend
  - Conclusion
- THE END
- Donation
- Licence
"

### README.md
readme_file = "README.md"
modular_architecture_on_ios = "modular_architecture_on_ios"

puts "Generating GitHub README"
puts `pandoc #{modular_architecture_on_ios}.md -o #{readme_file} --from markdown --to markdown --highlight-style tango`

generated_md = File.read(readme_file)
generated_md.gsub!(/\n\\newpage\n/, '')
generated_md.gsub!(/\\tableofcontents/, readme_toc)
File.open(readme_file, "w") { |f| f.puts "\n![Overview](assets/cover.png)\n#{generated_md}" }

### PDF
puts "Generating PDF"
puts `pandoc #{modular_architecture_on_ios}.md -o #{modular_architecture_on_ios}.pdf --from markdown --template "./build/eisvogel.tex" --listings --pdf-engine=xelatex --highlight-style tango`

 ### EPUB
puts "Generating epub"
puts `pandoc #{modular_architecture_on_ios}.md -o #{modular_architecture_on_ios}.epub --from markdown --listings --highlight-style tango --epub-cover-image "./assets/cover.png"`
