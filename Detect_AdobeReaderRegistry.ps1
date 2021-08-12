#Credit=https://github.com/TristanvanOnselen/WorkplaceAsCode/tree/master/ProActive_Remediation

#Disable Java 
#HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\bDisableJavaScript
#REG_DWORD value: 1

#Disable Flash
#HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\bEnableFlash
#REG_DWORD value: 0 

try
{
    
    $REG_JAVA = 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown'
    if (Test-Path -Path 'HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown')
    {
        # FeatureLockDown exists therefore Adobe Reader DC has been installed at some time therefore we need to check the Java and flash settings...
        $REG_Value_Java = (Get-ItemProperty -Path $REG_JAVA).bDisableJavaScript
        $REG_Value_Flash = (Get-ItemProperty -Path $REG_JAVA).bEnableFlash
    
        if (($REG_Value_Java -ne "1" -or $REG_Value_Flash -ne "0")){
            #Below necessary for Intune as of 10/2019 will only remediate Exit Code 1
            write-host "Adboe Reader FeatureLockdown values are not secure, Needs remediation"
            exit 1
        }
        else{
            #No matching certificates, do not remediate
            write-host "Adobe Reader DC java and flash ARE disabled, remediation not needed"     
            exit 0
        }  
    }
    else
    {
        # Test-path didn't find FeatureLockDown
        write-host "Test-Path Registry  to FeatureLockdown does not exist, would imply no ReaderDC"
        exit 0
    }
} 
catch{
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
    }