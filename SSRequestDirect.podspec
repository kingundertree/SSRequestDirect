Pod::Spec.new do |s|
  s.name         = "SSRequestDirect"
  s.version      = "0.0.1"
  s.summary      = "A short description of SSRequestDirect."
  s.description  = <<-DESC
                    Hi, SSRequestDirect!
                   DESC
  s.homepage     = "git@gitee.com:xiazer/SSRequestDirect.git"
  s.license      = "MIT"
  s.author       = { "Summer Solstice" => "kingundertree@163.com" }
  s.platform     = :ios, "9.0"
#  s.source       = { :git => "git@gitee.com:xiazer/SSRequestDirect.git", :tag => "#{s.version}" }
s.source           = { :git => '', :tag => s.version.to_s }

  s.source_files        = 'Sources/*.h'
  s.public_header_files = 'Sources/*.h'
  s.static_framework = true
#  s.ios.resources = ["Resources/**/*.{png,json}","Resources/*.{html,png,json}", "Resources/*.{xcassets, json}", "Sources/**/*.xib"]

#  s.subspec 'Core' do |ss|
#    ss.source_files = 'Sources/Core/*.{h,m,swift}'
#    ss.public_header_files = 'Sources/Core/*.h'
#  end
  
  s.dependency 'SSRequstHandler'
  s.dependency 'SwiftyJSON'
  
end
