Pod::Spec.new do |s|

  s.name         = "YJSliderView"
  s.version      = "0.0.1"
  s.summary      = "我的 YJSliderView."
  s.license      = { :type => "MIT" }
  s.homepage 	 = 'https://github.com/Leo-god/YJSliderView'
  s.authors 	 = { '袁杰' => '550936272@qq.com' }
  s.source 	 = { :git => 'https://github.com/Leo-god/YJSliderView.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.source_files = 'YJSliderView/YJSliderView/*.swift'
  s.swift_version = '4.1'
  s.dependency "SnapKit", "~> 4.0.0"

end
