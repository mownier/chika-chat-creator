Pod::Spec.new do |s|
  s.name     = 'ChikaChatCreator'
  s.version  = '0.0.1'
  s.summary  = 'Chat creator feature for Chika'
  s.platform = :ios, '11.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/mownier/chika-chat-creator'
  s.author   = { 'Mounir Ybanez' => 'rinuom91@gmail.com' }
  s.source   = { :git => 'https://github.com/mownier/chika-chat-creator.git', :tag => s.version.to_s }
  s.source_files = 'ChikaChatCreator/Source/*.swift'
  s.resources = ['ChikaChatCreator/Source/ChatCreator.storyboard']
  s.requires_arc = true

  s.dependency 'ChikaUI'
  s.dependency 'ChikaFirebase/Writer:ChatCreator'
  s.dependency 'ChikaContactList'
end
