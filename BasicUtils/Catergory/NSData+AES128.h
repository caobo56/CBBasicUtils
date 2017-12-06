#import <Foundation/Foundation.h>  
#import <CommonCrypto/CommonCryptor.h>  
#import <CommonCrypto/CommonKeyDerivation.h>  
@interface NSData (AES128)
+ (NSString *)AES128EncryptWithPlainText:(NSString *)plain password:(NSString *)password;        /*加密方法,参数需要加密的内容*/
+ (NSString *)AES128DecryptWithCiphertext:(NSString *)ciphertexts password:(NSString *)password; /*解密方法，参数数密文*/
@end  
