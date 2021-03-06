<# 

Simple decryptor for Hawkeye Keylogger/ configuration options. 

#>

function Hawkeye-Decrypt($Encrypted, $secret="HawkEyeKeylogger", $salt="099u787978786") 
{              
    $Encrypted = [Convert]::FromBase64String($Encrypted) 
     
    $rijman = new-Object System.Security.Cryptography.RijndaelManaged 
    $rfc2898 = new-Object System.Security.Cryptography.Rfc2898DeriveBytes([string]$secret, [System.Text.Encoding]::Unicode.GetBytes($salt))
    
    $rijman.KeySize = 256
    $rijman.IV = $rfc2898.GetBytes($rijman.BlockSize / 8)
    $rijman.Key = $rfc2898.GetBytes($rijman.KeySize / 8)    
    $rijman.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7        
    $decryptor = $rijman.CreateDecryptor()         
    
    $memstream = new-Object System.IO.MemoryStream @(,$Encrypted)            
    $cryptostream = new-Object Security.Cryptography.CryptoStream($memstream,$decryptor,[Security.Cryptography.CryptoStreamMode]::Read)        
    $streamreader = new-Object System.IO.StreamReader($cryptostream, [System.Text.Encoding]::Unicode)
        
    $decrypted_setting = $streamreader.ReadToEnd()
     
    $streamreader.Close()     
    $cryptostream.Close()     
    $memstream.Close()     
    $rijman.Clear() 
    
    return $decrypted_setting
  
} 
cls

Write-Host ""
Write-Host "Decrypting Hawkeye Configuration Setting"
Write-Host ""
$encrypted_setting = read-host "Encrypted Setting:"
$decrypted_setting = Hawkeye-Decrypt $encrypted_setting
Write-Host "-------------"
Write-Host "Decrypted Setting: $decrypted_setting"
Write-Host "-------------"
Write-Host ""