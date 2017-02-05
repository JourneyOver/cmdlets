$downloadURL = "http://downloads.sourceforge.net/project/filebot/filebot/HEAD/FileBot.jar.xz"
$output = "$env:temp\FileBot.jar.xz"

$downloadURL2 = "http://github.com/filebot/filebot/archive/master.zip"
$output2 = "$env:temp\filebot-master.zip"

Import-Module BitsTransfer
Start-BitsTransfer -Source $downloadURL -Destination $output

Start-Sleep -s 30

Start-BitsTransfer -Source $downloadURL2 -Destination $output2