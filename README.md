# CBBasicUtils
        
曹博的pod库
        
因为 中间使用了一些xib文件，所以在创建pod库的时候，需要使用下面的句柄：

```
    pod 'CBBasicUtils'
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
```

### 现在稳定的版本是1.0.51

-> CBBasicUtils (1.0.51)
   caobo's BasicUtils.
   pod 'CBBasicUtils', '~> 1.0.51'
   - Homepage:
   https://github.com/caobo56/CBBasicUtils.git
   - Source:  
   https://github.com/caobo56/CBBasicUtils.git
   - Versions: 1.0.51, 1.0.50, 1.0.39, 1.0.38,
   1.0.36, 1.0.35, 1.0.32, 1.0.30, 1.0.29, 1.0.28,
   1.0.27, 1.0.26, 1.0.25, 1.0.23, 1.0.22, 1.0.19,
   1.0.18, 1.0.17, 1.0.16, 1.0.15, 1.0.12, 1.0.11,
   1.0.10, 1.0.08, 1.0.07, 1.0.06, 1.0.05, 1.0.03,
   1.0.02, 1.0.01, 0.9.99, 0.9.98, 0.9.97, 0.9.95,
   0.9.93, 0.9.92, 0.9.91, 0.9.9, 0.9.7, 0.9.6,
   0.9.5, 0.9.3, 0.9.2 [master repo]
   - Subspecs:
     - CBBasicUtils/MacroAndConstant (1.0.51)
     - CBBasicUtils/Util (1.0.51)
     - CBBasicUtils/Catergory (1.0.51)
     - CBBasicUtils/BasicVC (1.0.51)
     - CBBasicUtils/BasicClass (1.0.51)
     - CBBasicUtils/Requset (1.0.51)
     - CBBasicUtils/ShareView (1.0.51)
     - CBBasicUtils/AboutApp (1.0.51)

