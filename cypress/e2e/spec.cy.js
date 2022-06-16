describe("EPPO", () => {
  it("should list EPPO aspects", () => {
    cy.mediawiki_login("lex", "globi2000globi");
    cy.visit("/wiki/EPPO");
    // #MWSTAKEBP: top-level aspects should be organized in sections
    cy.click_headerTab("All EPPO topic types");
    cy.takeScreenshot("All-EPPO-topic-types");
    cy.click_headerTab("All EPPO topics");
    cy.takeScreenshot("All-EPPO-topics");
    cy.click_headerTab("Facet Graph");
    cy.takeScreenshot("Facet-Graph");
  });
  it("allows a user to add an instance of a EPPO topic type", () => {
    cy.mediawiki_login("lex", "globi2000globi");
    // Fill in form and save
    cy.visit("/w/index.php?title=Special:FormEdit/UseCase");
    cy.eppoForm_editTitle("My use case title", "UseCase");
    cy.eppoForm_editBlurb("My use case blurb", "UseCase");
    cy.eppoForm_editFreeText("My use case free text");
    cy.takeScreenshot("Fill-in-standard-properties-in-EPPO-form");
    cy.eppoForm_addAProperty(
      "Property:Mwstake:use case category",
      "objectName0"
    );
    cy.takeScreenshot("Add-dynamic-properties-in-EPPO-form");
    cy.pageForm_savePage();
    cy.mediawiki_refresh();
    // View existing or initialize new property
    cy.dataspects_initializeOrViewProperty("Mwstake:use case category");
    cy.mediawiki_refresh();
    cy.takeScreenshot("Property-page");
  });

  it("allows a user to refresh a page", () => {
    cy.mediawiki_refresh();
  });
});
