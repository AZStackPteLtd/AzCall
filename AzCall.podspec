Pod::Spec.new do |s|
  s.name                    = 'AzCall'
  s.version                 = '1.0.1'
  s.summary                 = 'This is a part of AzStack communication platform. You can make a phone call or video call via VoIP.'
  s.module_name             = 'AzCall'

  s.description             = <<-DESC
  AzStack is communication platform. This is the iOS sdk for AzStack.

  At the moment, AzCall include:
  - Free video/audio call with WebRTC.
  - Call to GSM with low price.
                   DESC

  s.homepage                = 'https://azstack.com/'
  s.license                 = { :type => 'BSD', :file => 'LICENSE' }
  s.authors                 = { 'Luong Van Lam' => 'lamlv@azstack.com' }
  s.social_media_url        = 'https://twitter.com/lam2305'
  s.platform                = :ios, '9.0'
  s.source                  = { 
    :http => 'https://github.com/AZStackPteLtd/AzCall/archive/' + s.version.to_s + '.zip'
  }
  s.ios.source_files        = [
    'AzCall-' + s.version.to_s + '/AzCall.framework/Headers/*.h', 
    'AzCall-' + s.version.to_s + '/AzCall.framework/*.nib'
  ]
  s.ios.public_header_files = 'AzCall-' + s.version.to_s + '/AzCall.framework/Headers/*.h'
  s.ios.vendored_frameworks = 'AzCall-' + s.version.to_s + '/AzCall.framework'
  s.resource = [
    'AzCall-' + s.version.to_s + '/AzCall.framework/*.car', 
    'AzCall-' + s.version.to_s + '/AzCall.framework/*.wav', 
    'AzCall-' + s.version.to_s + '/AzCall.framework/*.mp3'
  ]
  
  s.ios.weak_frameworks     = 'PushKit'
  s.requires_arc            = true
  s.swift_version           = '4.0'
  s.dependency 'AzCore'
  s.dependency 'GoogleWebRTC'
  s.dependency 'PulsingHalo'

end
