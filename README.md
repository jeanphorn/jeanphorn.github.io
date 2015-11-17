#Jeanphorn Blog

## Dynamic cloud tag

Add dynamic cloud tag for Featured tags. The sources locate at ./css/tag_cloud.css and ./js/tag_cloud.js. to use them just like follow:
    \<div id="tag-cloud"\> \<a\>...\</a\>\</div\>
![Featured tag](/img/tag_cloud_readme.png)


## Google verify site
use the meta tag with a custom variable set in my _config.yml:

_config.yml:

google_verify: xcuAbsVWfO6omR4WpG9GaghoCbl26_cbNOsxerwfb9w

head.html or default.html (default layout):

{% if site.google_verify %}
    <meta name="google-site-verification" content="{{ site.google_verify }}">
{% endif %}
	No reason to throw a gem or an extra file in ther
![verify](/img/readme-verify.png)

##Include
A full Jekyll environment is included with this theme. If you have Jekyll installed, simply run jekyll serve in your command line and preview the build in your browser. You can use jekyll serve --watch to watch for changes in the source files as well.

A Grunt environment is also included. There are a number of tasks it performs like minification of the JavaScript, compiling of the LESS files, adding banners to keep the Apache 2.0 license intact, and watching for changes. Run the grunt default task by entering grunt into your command line which will build the files. You can use grunt watch if you are working on the JavaScript or the LESS.

You can run jekyll serve --watch and grunt watch at the same time to watch for changes and then build them all at once.

## Thanks

This theme is forked from [Huxpro/huxpro.github.io](https://github.com/Huxpro/huxpro.github.io)  
Thanks Hux, Jekyll and Github Pages!
