Pod::Spec.new do |s|
  s.name             = 'DragoDateTimePicker'
  s.version          = '1.0.0'
  s.summary          = 'A clean, modern, fully programmatic iOS date & time picker library written in Swift.'
  s.description      = <<-DESC
    DragoDateTimePicker supports Start/End time range, single time, date,
    and date + time picker modes. Fully programmatic, no storyboards required.
  DESC

  s.homepage         = 'https://github.com/ThrottleCode/DragoDateTimePicker'
  s.license          = { :type => 'MIT' }
  s.author           = { 'ThrottleCode' => '' }
  s.source           = { :git => 'https://github.com/ThrottleCode/DragoDateTimePicker.git', :tag => s.version.to_s }
  s.screenshot       = 'https://raw.githubusercontent.com/ThrottleCode/DragoDateTimePicker/main/Assets/preview.png'

  s.ios.deployment_target = '14.0'
  s.swift_versions        = ['5.9']
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.9' }

  s.source_files = 'Sources/DragoDateTimePicker/**/*.swift'
end
