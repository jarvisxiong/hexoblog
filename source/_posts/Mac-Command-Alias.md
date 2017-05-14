title: Mac Command Alias
author: Jarvis Xiong
tags:
  - linux
categories:
  - tools
date: 2017-05-02 06:50:00
---
### Mac下设置 ll alias

> 在linux下习惯使用ll、la、l等ls别名的童鞋到mac os可就郁闷了～～其实只要在用户目录下建立一个脚本**.bash_profile**，并输入以>下内容即可

```bash
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
```

> 然后 source .bash_profile.