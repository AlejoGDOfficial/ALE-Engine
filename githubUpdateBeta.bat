@echo off

title GitHub Update (beta)

echo Add all changes to git

git add .

set /p commitMessage=Enter commit name: 

echo Running git commit with the provided name...

git commit -m "%commitMessage%"

echo Pushing to the 'beta' branch...

git push origin beta

echo Finished!

pause
