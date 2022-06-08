# mediawiki-pages-EPPO

This package implements the virtues of [Every Page is Page One](https://everypageispageone.com/the-book/), which are for information topics to *conform to a type*, *stay on one level* and to *link richly*. EPPO formalizes a way to **add information** to your knowledge base **as topics**.

## Features

* **Manage (add/edit/delete) information by EPPO topic type forms**<br/>*fill in title, blurb, free text, [dynamic properties](https://github.com/dataspects/mediawiki-pages-DynamicProperties) and topic type-specific properties*
* **Manage EPPO topic types**<br/>- *define topic type-specific properties*<br/>- *use templates, mainly `TopicMetaTemplate`, `FormHeader`, `StandardFormSections` and `FormFooter`*
* **View all EPPO topic types** at `wiki/EPPO` (<a href="#about-the-wiki-eppo-page">more information&hellip;</a>)<br/>
  ![](readme_images/2206031055.png)  

* **View an EPPO topic's instances** at `wiki/Example`:<pre>
{{TopicType}}
</pre>

* Simplify managing the forms that manage topics, e.g. `Form:YourTopicType` has this wikitext:<pre>
{{{info|add title=New YourTopicType|edit title=Edit YourTopicType|page name=C<unique number;random;10>}}}
{{FormHeader|YourTopicType}}
{{StandardFormSections}}
{{FormFooter|YourTopicType}}
</pre>

## LocalSettings
```
$wgPageFormsLinkAllRedLinksToForms = true;
```

## Development

* Consider automating the addition of a new EPPO topic type (#LEX2206031136)

## Tests

Cypress

### Documentation parsed from Cypress tests

<div style='padding-top:10px; font-family:Sans-serif;'><span style='font-weight:bold; color:green;text-decoration: underline;'>Aspect</span> EPPO</div>
<div style='padding-left:20px; padding-top:10px; padding-bottom:5px; font-family:Sans-serif;'><span style='font-weight:bold; color:green;'>Feature</span>: it should list all EPPO topic types</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> mediawiki_login</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Go to</span> /wiki/EPPO</div>
<div style='padding-left:40px; font-family:Sans-serif; color:grey;'>    #MWSTAKEBP: top-level aspects should be organized in sections</div>

<div style='padding-left:20px; padding-top:10px; padding-bottom:5px; font-family:Sans-serif;'><span style='font-weight:bold; color:green;'>Feature</span>: it allows a user to add an instance of a EPPO topic type</div>
<div style='padding-left:40px; font-family:Sans-serif; color:grey;'>    Fill in form and save</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Go to</span> /w/index.php?title=Special:FormEdit/Aspect</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> eppoForm_editTitle</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> eppoForm_editBlurb</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> eppoForm_editFreeText</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> eppoForm_addAProperty</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> eppoForm_addAProperty</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> pageForm_savePage</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> mediawiki_refresh</div>
<div style='padding-left:40px; font-family:Sans-serif; color:grey;'>    View existing or initialize new property</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> dataspects_initializeOrViewProperty</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> mediawiki_refresh</div>

<div style='padding-left:20px; padding-top:10px; padding-bottom:5px; font-family:Sans-serif;'><span style='font-weight:bold; color:green;'>Feature</span>: it allows a user to refresh a page</div>
    <div style='padding-left:40px; font-family:Sans-serif;'><span style='font-weight:bold; color:orange;'>Do</span> mediawiki_refresh</div>

<div style='padding-top:10px; font-family:Sans-serif;'><span style='font-weight:bold; color:green;text-decoration: underline;'>Aspect</span> EPPO2</div>


## <a id="about-the-wiki-eppo-page"></a>About the `wiki/EPPO` page
<figure>
  <img src="readme_images/2206031129.png" style="background-color:white;"/>
  <figcaption></figcaption>
</figure>


