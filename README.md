# mediawiki-pages-EPPO

## Features

This package implements the virtues of [Every Page is Page One](https://everypageispageone.com/the-book/).

### Virtue: EPPO Topics Conform to a Type

* View all EPPO topic types at page `wiki/EPPO`:
<figure>
  <img src="readme_images/2206031055.png"/>
  <figcaption><a href="#about-the-wiki-eppo-page">More information about the wiki/EPPO page&hellip;</a></figcaption>
</figure>
  

* Every EPPO topic type "Example" has its own page, e.g. `wiki/Example`:<pre>
{{TopicType}}
</pre>

* Simplify managing the forms that manage topics, e.g. `Form:YourTopicType` has this wikitext:<pre>
{{{info|add title=New YourTopicType|edit title=Edit YourTopicType|page name=C<unique number;random;10>}}}
{{FormHeader|YourTopicType}}
{{StandardFormSections}}
{{FormFooter|YourTopicType}}
</pre>
* 

### Virtue: EPPO Topics Stay on One Level
### Virtue: EPPO Topics Link Richly

## LocalSettings
```
$wgPageFormsLinkAllRedLinksToForms = true;
```

## Development

* Consider automating the addition of a new EPPO topic type (#LEX2206031136)

## <a id="about-the-wiki-eppo-page"></a>About the `wiki/EPPO` page
<figure>
  <img src="readme_images/2206031129.png" style="background-color:white;"/>
  <figcaption></figcaption>
</figure>