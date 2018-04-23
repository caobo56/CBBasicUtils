# CBBasicUtils
        
曹博的pod库
        
因为 中间使用了一些xib文件，所以在创建pod库的时候，需要添加下面的句柄：

```
         post_install do |installer|
            installer.pods_project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
```



-> CBBasicUtils (1.0.11)
   caobo's BasicUtils.
   pod 'CBBasicUtils', '~> 1.0.11'
   - Homepage: https://github.com/caobo56/CBBasicUtils.git
   - Source:   https://github.com/caobo56/CBBasicUtils.git
   - Versions: 1.0.11, 1.0.10, 1.0.08, 1.0.07, 1.0.06, 1.0.05, 1.0.03, 1.0.02, 1.0.01, 0.9.99, 0.9.98,
   0.9.97, 0.9.95, 0.9.93, 0.9.92, 0.9.91, 0.9.9, 0.9.7, 0.9.6, 0.9.5, 0.9.3, 0.9.2 [master repo]
   - Subspecs:
     - CBBasicUtils/ArrBounds (1.0.11)
     - CBBasicUtils/MacroAndConstant (1.0.11)
     - CBBasicUtils/Util (1.0.11)
     - CBBasicUtils/Catergory (1.0.11)
     - CBBasicUtils/BasicVC (1.0.11)
     - CBBasicUtils/BasicClass (1.0.11)
     - CBBasicUtils/Requset (1.0.11)
