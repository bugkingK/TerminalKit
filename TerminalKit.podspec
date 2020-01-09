Pod::Spec.new do |s|

  s.name         = "TerminalKit"
  s.version      = "1.0.2"
  s.summary      = "‘TerminalKit’ makes it easy to process scripts."
  s.description  = <<-DESC
‘TerminalKit’ makes it easy to process scripts.

‘TerminalKit’ is a class using Process. The easy callback function allows you to process tasks when scripts are running and when they are complete.
                   DESC

  s.homepage     = "https://github.com/bugkingK/TerminalKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "bugkingK" => "myway0710@naver.com" }
  s.platform     = :osx, "10.10"
  s.source       = { :git => "https://github.com/bugkingK/TerminalKit.git", :tag => "#{s.version}" }
  s.source_files = "Classes", "Sources/**/*.{swift}"

  s.swift_version = '5.0'

end