#
#  Be sure to run `pod spec lint CBBasicUtils.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "CBBasicUtils"
  s.version      = "0.9.2"
  s.summary      = "The basic ios Uitls for caobo."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                         It is a utils used on iOS, which implement by Objective-C.  
                   DESC

  s.homepage     = "https://github.com/caobo56/CBBasicUtils.git"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author       = { "caobo" => "caobo56@sina.com" }
  # Or just: s.author    = "caobo"
  # s.authors            = { "caobo" => "bo.cao@Superd3d.com" }
  # s.social_media_url   = "http://twitter.com/caobo"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  s.platform     = :ios, '8.0'  
  s.requires_arc = true  
  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/caobo56/CBBasicUtils.git", :tag => "0.9.2" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  # s.subspec "Util" do |util|
  #   util.source_files = 'src/Util/*.{h,m}'
  #   util.resources    = ["src/Resource/bank.plist","src/Resource/24_solar_terms/*.json"]
  #   util.public_header_files = 'src/Util/CBUtilsHeader.h'
      
  # end

  # s.subspec "BasicClass" do |basic_class|
  #   basic_class.source_files = 'src/BasicClass/*.{h,m}'
  #   basic_class.resources    = "src/BasicClass/*.xib"
  # end

  #  s.subspec "BasicVC" do |basic_vc|
  #   basic_vc.source_files = 'src/BasicVC/*.{h,m}'
  #   basic_vc.public_header_files = 'src/Util/CBBasicVCHeader.h'

  # end

  s.subspec "Requset" do |re|
    re.source_files = 'CBBasicUtils/Requset/*.{h,m}'
    # re.public_header_files = 'CBBasicUtils/**/CBNetworkHeader.h'
  end

  # s.subspec "Catergory" do |catergory|
  #   catergory.source_files = 'CBBasicUtils/Catergory/*.{h,m}'
  #   catergory.public_header_files = 'CBBasicUtils/Catergory/CBCatergoryHeader.h'
  # end

  # s.subspec "MacroAndConstant" do |m_c|
  #   m_c.source_files = 'CBBasicUtils/MacroAndConstant/*.{h,m}'
  #   m_c.public_header_files = 'CBBasicUtils/MacroAndConstant/ABCreditHeader.h'
  # end

  s.dependency 'SDWebImage'
  s.dependency 'Masonry'
  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
