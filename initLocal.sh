hexo generate
suod npm install -g hexo-cli
npm install
git clone https://github.com/iissnan/hexo-theme-next themes/next
hexo clean
cp next/_config.yml themes/next
cp next/avatar.jpg  themes/next/source/images/
hexo g

