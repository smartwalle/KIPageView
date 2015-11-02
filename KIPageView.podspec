#
#  Be sure to run `pod spec lint KIPageView.podspec' to ensure this is a
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

  s.name         = "KIPageView"
  s.version      = "0.1"
  s.summary      = "KIPageView"

  s.description  = <<-DESC
                   ## KIPageView
                  UITableView 很强大，可是只能竖向滚动；UICollectionView 可以解决各种布局难题，但是稍显复杂，对于一些简单的需求，有点杀鸡用牛刀的感觉。

                  在 iOS6 以前，还没有 UICollectionView，为了实现横向滚动的 UITableView，只有自己动手写组件。为了达到和 UITableView 差不多的效果，就得先弄清其内部实现机制是怎么回事。

                  在渲染 View 的时候，是很耗系统资源的，如果创建大量的 View, 系统运行将变得异常缓慢，甚至导致内存耗尽。但是，在实际应用中，我们难免会遇到大量的数据需要显示，如果每显示一个数据，我们都创建一个 View，那应用程序的体验将相当糟糕。所以 Apple 为 iOS 开发者提供了 UITableView，Google 为 Android 开发者提供了 ListView。

                  简单来讲，UITableView 采用复用机制，其只会显示其可见区域内的 UITableViewCell。我们在滑动的过程中，当超出 UITableView 可见区域的 Cell，将会从 UITableView 中移除，并加入回收池中以作复用。当 UITableView 需要显示新的 Cell，会先从回收池中查找是否有相应的 Cell 可以重用（通过 dequeueReusableCellWithIdentifier:）。如果有，则直接将其重新显示；如果没有，则创建新的 Cell。这样一来，就可以避免因创建过多的 View，导致内存耗尽的尴尬情况。

                  了解了其内部的运行原理，我们也可以实现一个自己的 UITableView。

                  很常见的一个应用场景——显示图片：如果显示一张图片，我们用一个 UIImageView 足矣，如果要显示多张图片，并且可以左右滚动，最简单的办法是用一个 UIScrollView 包含多个 UIImageView, 但是这样带来的后果则是，如果图片数据量较大，那这个程序根本没有办法正常使用。如果我们还需要实现无限循环滚动，那这个解决方案肯定是不行的。所以这时候，就得我们自己实现一个 UITableView。

                  最开始，我写了一个组件叫 KIFlowView，实现了上面讲的需求，但是都是 iOS5 时代的产物了，难免过于陈旧。在后续的工作中也发现，类似的需求其实挺多的，比如左右滑动的 View，如网易新闻客户端，可以左右滑动，在不同的新闻栏目之间进行切换；有时候我们也需要实现一些 Tab，如果 Tab 的项目比较多，也需要考虑复用的问题，所以决定重新写一个增强组件，作为其替代品，所以就产生了 KIPageView。
                   DESC

  s.homepage     = "https://github.com/smartwalle/KIPageView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = { :type => 'Apache License, Version 2.0', :file => 'COPYING' }
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "SmartWalle" => "smartwalle@gmail.com" }
  # Or just: s.author    = "SmartWalle"
  # s.authors            = { "SmartWalle" => "smartwalle@gmail.com" }
  # s.social_media_url   = "http://twitter.com/杨烽"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/smartwalle/KIPageView.git", :tag => "0.1" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "KIPageView/KIPageView/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

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

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
