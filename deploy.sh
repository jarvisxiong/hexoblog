hexo generate
mkdir -p ../deploy/jarvisxiong.github.io
cp -R public/* ../deploy/jarvisxiong.github.io
cd ../deploy/jarvisxiong.github.io
echo 'push to github jarvisxiong.github.io ....'
git add .
git commit -m “update”
git push origin master
echo 'push to github jarvisxiong.github.io ....'
echo 'push to github hexoblog ....'
cd ../../hexoblog/
git add .
git commit -m "update"
git push origin master
echo 'push to github hexoblog over ....'
pause
