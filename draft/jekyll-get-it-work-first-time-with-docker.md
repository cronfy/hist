# Как создать в нашем репозитории новый сайт на Jekyll с нуля с использованием docker

## Определяемся с образом

Возьмем официальный jekyll/jekyll, но какой версии?

 * 4.2 не заработал с ошибкой `Bundler: Errno::EACCES: Permission denied @ rb_file_s_rename - (/home/jekyll/.local/share/gem/ruby/2.7.0/cache/rexml-3.2.4.gem, /usr/gem/cache/rexml-3.2.4.gem)`
 * 3.9 docker не существует

Взял 3.8

## Как теперь запускать jekyll в docker

Везде, где далее указано `jekyll команда` имеется в виду, что её нужно запускать в контейнере docker.

Чтобы попасть в контейнер, нужно запустить `./j bash`.

Для разовых команд можно `./j jekyll команда`

## Как проинициализировать блог в папке

За основу взял статью https://michaelcurrin.github.io/code-cookbook/recipes/containers/jekyll.html

Действия:

* Создать **пустую** папку `./jekyll/` в корне репозитория.
* Запускаем `./j bash` (перейдет в ./jekyll и запустит bash в jekyll docker)
* `jekyll new .` проинициалмзирует блог, в конце выведет `New jekyll site installed in /srv/jekyll`.
* `jekyll build` соберет папку `_site` выведет примерно это:
    ```
	ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux-musl]
	Configuration file: /srv/jekyll/_config.yml
	            Source: /srv/jekyll
	       Destination: /srv/jekyll/_site
	 Incremental build: disabled. Enable with --incremental
	      Generating... 
	       Jekyll Feed: Generating feed for posts
	                    done in 0.43 seconds.
	 Auto-regeneration: disabled. Use --watch to enable.
	```

В итоге будет собран собран пустой блог.

## Просмотр на локалке

 * `jekyll serve`

В первый раз он будет долго молчать и думать, потом ставить пакеты. После этого выведет

```
    Server address: http://0.0.0.0:4000/
  Server running... press ctrl-c to stop.
```

Можно заходить на http://0.0.0.0:4000/ , там отображается блог.

## Размещение на github pages

От push до публикации проходит около минуты.

curl и wget все время получают кеш.

Симлинки поддерживаются только внутри выбранного корня документов. А вот например, если 
для публицации выбрать `docs/`, а из него (или с него) сделать симлинк на что-либо вне 
`docs/`, то github так и скажет [symbolic link ... targets a file which does not exist](https://docs.github.com/en/github/working-with-github-pages/troubleshooting-jekyll-build-errors-for-github-pages-sites#symlink-does-not-exist-within-your-sites-repository)


...информация дополняется...
