# mediawiki-pages-EPPO

## Features

This package implements the virtues of [Every Page is Page One](https://everypageispageone.com/the-book/).

### Virtue: EPPO Topics Conform to a Type

* View all EPPO topic types at page `EPPO`
* Every EPPO topic type "Example" has its own page `Example`<pre>
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