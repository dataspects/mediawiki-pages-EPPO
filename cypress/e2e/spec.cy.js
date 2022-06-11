describe("EPPO", () => {
  it("should list all EPPO topic types", () => {
    cy.mediawiki_login("lex", "globi2000globi");
    cy.visit("/wiki/EPPO");
    // #MWSTAKEBP: top-level aspects should be organized in sections
    cy.get("h2").contains("All EPPO topic types");
  });
  it.only("allows a user to add an instance of a EPPO topic type", () => {
    cy.mediawiki_login("lex", "globi2000globi");
    // Fill in form and save
    cy.visit("/w/index.php?title=Special:FormEdit/UseCase");
    cy.eppoForm_editTitle("My use case title", "UseCase");
    cy.eppoForm_editBlurb("My use case blurb", "UseCase");
    cy.eppoForm_editFreeText("My use case free text");
    cy.screenshot("Fill-in-standard-properties-in-EPPO-form");
    cy.eppoForm_addAProperty(
      "Property:Mwstake:use case category",
      "objectName0"
    );
    // cy.eppoForm_addAProperty(predicateName, "objectName1");
    cy.screenshot("Add-dynamic-properties-in-EPPO-form");
    cy.pageForm_savePage();
    cy.mediawiki_refresh();
    // View existing or initialize new property
    // cy.dataspects_initializeOrViewProperty(predicateName);
    cy.mediawiki_refresh();
  });

  it("allows a user to refresh a page", () => {
    cy.mediawiki_refresh();
  });
});
