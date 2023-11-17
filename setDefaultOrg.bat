call sf config set target-org=ASCBM
call sf project retrieve start --manifest manifest/package.xml
git add -A
set commitMessage="Commit by schedual %date% %time%";
git commit -m %commitMessage%
git push ASCBM