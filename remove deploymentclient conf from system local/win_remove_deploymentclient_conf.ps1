<#
  This script is extracted and modified from the SCCM deployment Script by droehr168
  https://github.com/droehr168/Splunk-Universal-Forwarder-SCCM-Package/tree/main

  Why?:
  When you set the deployment client configuration during installation, it will be stored in SPLUNK_HOME/etc/system/local.
  As these configs take precedence over any config in SPLUNK_HOME/etc/apps/app_name/local, we are not able to change this setting via the Splunk deployment server. Therefore, you have to remove the system/local file before your config is taken into account. This script can be used as scripted input and deployed as an app via the Splunk deployment server to achieve this.

  What does the script?:
  The script checks the install location of Splunk Enterprise or Splunk Universal Forwarder and checks whether a deploymentclient.conf is present in SPLUNK_HOME/etc/system/local.

  If the file exists, the deploymentclient.conf will be deleted, and the Splunk component will be restarted.
#>


$splunk_root_directory         = (Get-WmiObject -Class Win32_Product -Property InstallLocation -Filter "Name='Splunk Enterprise'").InstallLocation


$check_system_local_conf_files = Get-ChildItem -Path "$splunk_root_directory\etc\system\local"

if( ($check_system_local_conf_files.Name -cmatch "deployment")  )
        {
          $delete_deploymentclient = Get-ChildItem -Path "$splunk_root_directory\etc\system\local\deploymentclient.conf" | Remove-Item -Force -ErrorAction SilentlyContinue

        }


Start-Process -FilePath "$splunk_root_directory\bin\splunk.exe" -ArgumentList restart -NoNewWindow