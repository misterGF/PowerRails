# Deploy the script to the c:\scripts directory and back it up on network share (\\e15mautl-mgmt01\SoftwareDist\Code)
Deploy 'Copy to scripts folder' {
  By Filesystem {
    FromSource '.\'
    To "c:\scripts\$module"
    Tagged Prod
  }
}
