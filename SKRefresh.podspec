Pod::Spec.new do |s|  
  s.name         = "SKRefresh"
  s.version      = "0.0.1"
  s.summary      = "An easy way to use pull-to-refresh."
  s.homepage     = "https://github.com/gittowj/SKRefresh"
  s.license      = "MIT"
  s.authors      = {"WJ" => "1057234592@qq.com"}
  s.platform     = :ios, '9.0'
  s.source       = {:git => 'https://github.com/gittowj/SKRefresh.git', :tag => s.version}
  s.source       = 'source/**/*.{h,m}'
  s.requires_arc = true

end
