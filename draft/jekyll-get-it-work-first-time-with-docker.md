# Как создать сайт на Jekyll с нуля с использованием docker и разместить его на github pages

Инструкция как перейти из состояния "Я хочу вести блог
в git и бесплатно размещать его на github pages" к состоянию "У меня есть блог на github pages,
вот ссылка".

Инструкция получилась слишком большая и требует декомпозиции. 

## Определяемся с движком

Ну а правда, почему Jekyll? Хотел же Hugo?

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

* Создать **пустую** папку `jekyll/` в корне репозитория.
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

Если это первый запуск после старта контейнера, он будет долго молчать и думать, потом ставить пакеты. После этого выведет

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

Придется копировать _site руками.

Пришлось прописать baseurl в jekyll, т. к. gh-pages размещает все директории по имени репозитория,
в моём случае репозиторий github.com/hist -> https://cronfy.github.io/hist/

Настройка GHP - ветка main, папка docs, там особо ничего не настраивается. 

## Самое важное - создание favicon

Потому что как так - сайт уже есть, а favicon еще нет. Непорядок!

Сразу скажу, что при установке favicon есть различные нюансы. Я их сейчас игнорирую, просто хочу, чтобы на сайте
быстрее появилась иконка. Важен для меня только один момент: чтобы иконка лежала не в корне, а в отдельной папочке.  

### Сначала нужно создать сам файл

 1. Гуглим 'create favicon'
 2. Идем на https://favicon.io/
 3. Выбираем TEXT -> ICO
 4. Вводим первую букву своего имени, выбираем свой любимый Font color и белый/серый/черный Background Color.

Скачиваем архив с картинками. На странице внизу также есть html для вставки в head, но он нам не понадобится.

### Размещаем файл на сайте

Воспользуемся [советом из документации]([https://jekyllrb.com/docs/posts/#including-images-and-resources]) и создадим
папку `jekyll/assets/favicon`. В нее распаковыаем архив с иконками.

### Копируем шапку

Копируем шапку сайта из темы себе в `_includes/`.

```
# Узнать путь gem темы.
# при ошибке Could not find public_suffix-4.0.6 in any of the sources
# нужно запустить bundle install
# причина описана в "Прочее | Кеширование gem".
bundle show minima

# копируем
mkdir -p _includes
cp  /usr/local/bundle/gems/minima-2.5.1/_includes/head.html ./_includes/
# а то владелец будет root
chown -R jekyll:jekyll _includes/
``` 

### Вставляем html код для иконок в шапку

А вот тут то, чего нет в других статьях! Т. к. у нас блог находится не в корне сайта, а в папке, нужно особым образом 
прописать путь к favicon - а именно через `relative_url`. В таком случае jekyll учтет при генерации ссылок значение 
`baseurl` из `_config.yml`.

Вставляем в `_includes/head.html` код:

```html
  <link rel="shortcut icon" href="{{ "/assets/favicon/favicon.ico" | relative_url }}">
  <link rel="icon" type="image/png" sizes="32x32" href="{{ "/assets/favicon/favicon-32x32.png" | relative_url }}">
  <link rel="icon" type="image/png" sizes="16x16" href="{{ "/assets/favicon/favicon-16x16.png" | relative_url }}">
```

### Проверяем

```
jekyll build
jekyll serve
```
 
## Тема

Так, ну ладно. Блогов со стандартной темой на Jekyll много. Ее в любом случае нужно будет менять. Возьмем просто любую другую тему.

Возьмем эту https://github.com/mmistakes/minimal-mistakes . Звездочек 7k, релизы свежие есть, и с десяток за 2020, видел её в статьях. Подойдет.

Устанавливаем по инструкции с github.

Ага, ей нужен сначала jekyll-include-cache. Прописываем jekyll-include-cache по инструкции (в Gemfile `group :jekyll_plugins` и в _config.yml в `plugins:`.

Устанавливаем саму тему по инструкции - в Gemfile удаляем старую minima и добавляем нашу, а в _config.yml прописываем theme.

Пробуем взлететь: 

```
./j bash
bundle
jekyll build
```

А, мы же там добавляли favicon и у нас в _include шапка от minima. Переименуем пока head.html в head.html.old и попробуем еще раз

```
jekyll build
# ура!
jekyll serve
```

Так, что-то ни фига. А где шаблон в постах? Ах, там в каждом посте прописан layout...

Ага, там в quick start guide есть раздел [Starting from jekyll newPermalink](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/#starting-from-jekyll-new), то что надо. Заменяем index.md. А что значит 'Be sure to enable pagination'? Ладно, потом разберемся, постов пока все равно нет. Возможно, речь про это https://jekyllrb.com/docs/pagination/ . Далее, в posts/ меняем layout, а about.md удаляем.

```
# ну что там?
jekyll build
# хм, собралось.
jekyll serve
# вот теперь нормально!
```

Правда все равно как-то бледненько. А, вот, если с `minimal_mistakes_skin` поиграться (а узнать про него можно, заглянув в пример конфига, ссылка на который есть [здесь](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/#starting-fresh))), то что-то меняется. 

Ладно, потом поиграемся, сейчас самое главное - вернуть favicon'ку!

Гугл говорит, что для minimal-mistakes нужно менять favicon в `/_includes/head/custom.html`. Ок.

```bash
mkdir _includes/head
bundle show minimal-mistakes
cp /usr/local/bundle/gems/minimal-mistakes-jekyll-4.22.0/_includes/head/custom.html _includes/head
# оп, чуть не забыл
chown -R jekyll:jekyll _includes
```

Вставляем в custom.html то же самое для favicon'ок, что и раньше, и...

```bash
jekyll build
jekyll serve
# wooooooooooho!
```

Супер! Осталось разместить первый пост! А старый head.html.old от minima теперь можно и удалить. 

Минуточку. `miminal-mistakes` создает robots.txt и sitemap.xml, и кладет туда ссылки на локалку вида http://0.0.0.0/.... С этим нужно что-то сделать. И в постах url `jekyll/update` мне не нравятся. И зачем там вообще абсолютные ссылки? Надо разбираться. 

... 

Ага. Это происходит после `jekyll serve`. А `jekyll build` все делает как надо. Значит, перед публикацией нужно запускать `jekyll build`.

Ну все, теперь точно можно размещать первый пост.

## Размещение первого поста

Собственно, он уже есть - это "Welcome to Jakyll", который висит на главной странице, его контент в `_posts`. Посмотрим, что у нас там есть.

 * `layout`. Это, значит, [вид отображения поста](https://mmistakes.github.io/minimal-mistakes/docs/layouts/#single-layout). Пусть пока остается как есть. Потом как-нибудь поиграемся.
 * `title`, `date` понятно. Заменяем на наши.
   * Кстати, еще нужно не забыть переименовать файл.
 * `categories` - а это что? Ага! Это то, из чего [составляется url к посту](https://jekyllrb.com/docs/posts/#categories). Как раз то что нужно в контексте моих 'seo-размышлений'. Будет пока одна категория - v1.

Чтобы вдохновиться возможностями форматирования перед размещением контента, заглянем на [minimal-mistakes demo pages](https://mmistakes.github.io/minimal-mistakes/about/#demo-pages). Впрочем, вдохновляться особо нечем - markdown и markdown. С другой стороны это даже хорошо, что будет использоваться только чистый markdown без дополнительных возможностей форматирования - легче будет переехать на другой движок блога.

Размещаем контент. Проверяем, что все хорошо.

```bash
# оказалось, он сам собирает, да еще и обновляет сборку, когда посты меняются, очень удобно и не надо каждый
# раз запускать build и перезапускать serve  
jekyll serve
```

Ура! Срочно публикуем на github! Только надо не забыть пересобрать для публикации:

```bash
jekyll build
```

К сожалению, сайт выглядит не очень. А все потому, что в шаблоне настройки шапки и футера по умолчанию. Значит, нужно заняться настройкой шаблона.

...информация дополняется...

## TODO

 * Настроить шаблон (шапку/футер/etc). Откладывал этот шаг на потом, чтобы заниматься этом в контексте существования
   реального поста в блоге. Но теперь уж точно надо. 
 * И похоже, потом нужно будет переключить шаблон на русский. Об этом сказано в [minimal-mistakes site-locale](https://mmistakes.github.io/minimal-mistakes/docs/configuration/#site-locale), но читать нужно очень внимательно.
 * Есть принципиальная разница между состояниями 0, 1 и > 1. Поэтому для полной уверенности, что все идет хорошо, нужно разместить еще и второй пост.

## Прочее

### Кеширование gem

[Кеширование gem](https://github.com/envygeeks/jekyll-docker/blob/master/README.md#caching) нужно, чтобы зависимости каждый раз при запуске docker контейнера не пересобирались заново.

Если не кешировать, то после выхода из контейнера docker любая первая команда `jekyll что-нибудь` будет долго думать и ставить зависимости.

В принципе терпимо, т. к. в контейнер можно зайти и не выходить, пока работаешь.

Поэтому кеширование пока не реализовано.
