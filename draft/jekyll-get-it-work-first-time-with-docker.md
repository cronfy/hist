# Как создать в нашем репозитории новый сайт на Jekyll с нуля с использованием docker

4.2 не заработал с ошибкой   

Bundler: Errno::EACCES: Permission denied @ rb_file_s_rename - (/home/jekyll/.local/share/gem/ruby/2.7.0/cache/rexml-3.2.4.gem, /usr/gem/cache/rexml-3.2.4.gem)

3.9 нет

Взял 3.8

Статья https://michaelcurrin.github.io/code-cookbook/recipes/containers/jekyll.html

./j bash

Папка должна быть пустая

jekyll new .

--> 
...
New jekyll site installed in /srv/jekyll. 

jekyll build --trace

-->
...
       Jekyll Feed: Generating feed for posts
                    done in 0.407 seconds.
 Auto-regeneration: disabled. Use --watch to enable.



jekyll serve

DONE!
